#Requires -Version 3.0

<#
    .SYNOPSIS
    Publishes all locally cached packages to Active Efficieny.

    .DESCRIPTION
    The Publish-LocalNomadPackage Cmdlet reads the content that is cached locally by the Nomad client
    and ensures all is available in Active Efficiency, so other devices are aware of their availability.
    Very useful if machines are used to precache content, but the information in AE is no longer available,
    as the Nomad client will only publish new content and never validate existing one, assuming it exists
    in a perfect world ;)

    The "Standalone" version of this script contains all the functions from the PS1EAE module so no further
    reference or import is needed. This can be useful for scenarios, where the existence of a module can't
    be guaranteed.

    .NOTES
    Idea and main logic by Rustam Gadeev.

    Copyright: https://github.com/MaikKoster/PS1EAE/blob/master/LICENSE

    Version History:
        2019-07-31 - v1.0  - MK: Initial version
#>
[CmdLetBinding()]
Param(
    # Specifies, if the client validation part should be skipped.
    # On default it will first check, if the local DeviceID matches
    # the DeviceID registered with the device in Active Efficiency
    # based on the SMBios GUID and FQDN.
    [switch]$SkipClientValidation,

    # Specifies if content for Software Updates should be skipped.
    # Can speed up the process.
    [switch]$SkipUpdates
)

process {
    # Set up logging
    $Script:LogPath = "$Env:WinDir\SCCM\Logs\Publish-LocalNomadPackage.log"
    Write-Log '--------------------------------------------'
    Write-Log "Start 'Publish-LocalNomadPackage'"
    Write-Log 'Script version 1.0 (2019-07-31)'

    # Get information about ActiveEfficieny
    $AEInfo = Get-AELocalDeviceInfo

    # Don't bother running if AE isn't even configured
    if ($null -ne $AEInfo) {
        if (-Not([string]::IsNullOrWhiteSpace(($AEInfo.DeviceID)))) {
            $NomadRootPath = "HKLM:\SOFTWARE\1E\NomadBranch"

            if (-Not($SkipClientValidation.IsPresent)) {
                $AERegPath = Join-Path -Path $NomadRootPath -ChildPath "ActiveEfficiency"
                # First validate local Active Efficiency information.
                # local DeviceID must match DeviceID registered in AE
                # We need SMBios GUID and FQDN as Identifiers
                $CSP = Get-CimInstance -ClassName Win32_ComputerSystemProduct
                $UUID = $CSP.UUID
                $CS = Get-CimInstance -ClassName Win32_ComputerSystem

                if (-Not([string]::IsNullOrWhiteSpace($CS.Domain)) -and (-Not([string]::IsNullOrWhiteSpace($UUID)))) {
                    $DeviceType = [int](Get-ItemPropertyValue -Path $AERegPath -Name NomadDeviceType -ErrorAction SilentlyContinue)

                    $Device = New-AEDevice -AEServer $AEInfo.PlatformUrl -HostName $CS.Name -DomainName $CS.Domain -SMBiosGuid $UUID -TypeID $DeviceType -Verbose:$false

                    $DeviceID = $Device.Id
                } elseif ([string]::IsNullOrWhiteSpace($CS.Domain)) {
                    Write-Log "No domain found." -Severity Error
                } else {
                    Write-Log "No UUID found." -Severity Error
                }

                if (-Not([string]::IsNullOrWhiteSpace($DeviceID))) {
                    if ($DeviceID -ne $AEInfo.DeviceID) {
                        Write-Log "Local DeviceId and DeviceId in Active Efficiency don't match. Restarting NomadBranch service to force re-evaluation." -Severity Warning
                        Restart-Service -Name NomadBranch -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -Verbose:$false
                        # Use AE DeviceId to update content
                        $AEInfo.DeviceID = $DeviceID
                    }
                } else {
                    Write-Log "No DeviceID returned from Active Efficieny, based on supplied identifiers." -Severity Warning
                }
            }

            # Get current information about Device content from AE
            # Use a hashtable to store values, as this speeds up the process by ~10-20 times
            # Create another hashtable to easily identify duplicate entries
            Write-Log 'Get currently published device content from Active Efficiency.'
            $DeviceHash = @{}
            $DeviceContentCount = @{}
            $DeviceContent = Get-AEDeviceContent -AEServer $AEInfo.PlatformUrl -DeviceID $AEInfo.DeviceId -Verbose:$false
            $DeviceContent | ForEach-Object {$DeviceContentCount[($_.ContentName.ToLower())] += 1; $DeviceHash[($_.ContentName.ToLower())] = $_}

            Write-Log "Found $($DeviceContentCount.Count) content items in Active Efficiency."

            $PkgPath = Join-Path -Path $NomadRootPath -ChildPath "PkgStatus"
            if (Test-Path -Path $PkgPath) {
                Write-Log 'Get locally cached Nomad content.'
                $NomadPackages = Get-ChildItem -Path $PkgPath

                Write-Log 'Validate local content against Active Efficiency'
                $LocalDeviceHash = @{}
                foreach($NomadPackage in $NomadPackages) {
                    # Get initial nomad content info
                    $Name = $NomadPackage.PSChildName

                    # Add to hashtable to later validate AE content against local content
                    $LocalDeviceHash[$Name.ToLower()] = $Name
                    $Version = $NomadPackage.GetValue("Version")
                    if ($SkipUpdates -and $Name.Length -eq 36) {
                        Write-Log "$($Name) ($($Version)): Skipping Software Update"
                        Continue
                    }
                    $Percent = $NomadPackage.GetValue("Percent")

                    if (-Not([string]::IsNullOrWhiteSpace($Percent)) -and $Percent.StartsWith("100")) {
                        # Try to evaluate correct start and end time
                        $StartTime = $NomadPackage.GetValue("StartTimeUTC") | Convert-DateString
                        if ($null -eq $StartTime) {
                            $StartTime = Get-Date
                        }
                        $EndTime = $NomadPackage.GetValue("FinishTimeUTC") | Convert-DateString
                        if ($null -eq $EndTime) {
                            $EndTime = Get-Date
                        }

                        # Size and NumberOfFiles should be properly set by AE iself, if not supplied as this information comes from SCCM
                        # Keep logic for Size for now.
                        # TODO: If necessary, add logic for umberOfFiles
                        # for size, use "BytesFromPeer" first
                        # $Size = $NomadPackage.GetValue("BytesFromPeer")
                        #if ([string]::IsNullOrWhiteSpace($Size)) {
                        #    # else use "DiskUsageKB"
                        #    $Size = [int]($NomadPackage.GetValue("DiskUsageKB")) * 1024
                        #}

                        $ContentCount = $DeviceContentCount[$Name.ToLower()]
                        if ($ContentCount -gt 1) {
                            #Duplicate content. Remove duplicate entries and start fresh
                            Write-Log "$($Name) ($Version): Multiple entries for content detected. Clean up Active Efficiency."
                            foreach ($ContentEntry in ($DeviceContent | Where-Object {$_.ContentName -eq $Name})) {
                                try {
                                    $RemovedContent = Remove-AEDeviceContent -AEServer $AEInfo.PlatformUrl -DeviceID $AEInfo.DeviceId -ContentID $ContentEntry.Id -Verbose:$false
                                    if ($RemovedContent.WasSuccessful) {
                                        Write-Log "$($ContentEntry.ContentName) ($($ContentEntry.Version)): $($RemovedContent.Message)"
                                    } else {
                                        Write-Log "$($ContentEntry.ContentName) ($($ContentEntry.Version)): $($RemovedContent.Message)" -Severity Error
                                    }
                                } catch {
                                    Write-Log "$($ContentEntry.ContentName) ($($ContentEntry.Version)): Failed to remove content delivery '$($ContentEntry.Id)'" -Severity Error
                                }
                            }

                            # Remove from Hashtable. Shouldn't matter as it will be overwritten, but just to be sure
                            $DeviceHash[$Name.ToLower()] = $null

                            $ContentCount = $null
                        }

                        if ($null -eq $ContentCount) {
                            # Content available locally but not registered in AE
                            # Publish to AE
                            $NewContent = New-AEDeviceContent -AEServer $AEInfo.PlatformUrl -DeviceID $AEInfo.DeviceID -Name $Name -Version $Version -Percent 100 -StartTime $StartTime -EndTime $EndTime -Verbose:$false
                            Write-Log "$($Name) ($($Version)): Added content delivery '$($NewContent.Id)'"

                            # Add new content to Hashtable
                            $DeviceHash[$Name.ToLower()] = $NewContent
                        } else {
                            # Content exists already. No need to update
                            # $ContentEntry = $DeviceContent | Where-Object {$_.ContentName -eq $Name}
                            $ContentEntry = $DeviceHash[$Name.ToLower()]

                            if (($null -ne $ContentEntry) -and ([Math]::Floor($ContentEntry.Percent) -ne 100)) {
                                $UpdatedContent = Update-AEDeviceContent -AEServer $AEInfo.PlatformUrl -DeviceID $AEInfo.DeviceID -ContentID $ContentEntry.Id -Percent 100 -EndTime $EndTime -Verbose:$false
                                if ($UpdatedContent.WasSuccessful) {
                                    Write-Log "$($Name) ($($Version)): Updated content delivery $($UpdatedContent.Value)"
                                } else {
                                    Write-Log "$($Name) ($($Version)): $($UpdatedContent.Message)" -Severity Error
                                }
                            } else {
                                Write-Log "$($Name) ($($Version)): Validated content delivery '$($ContentEntry.Id)'"
                            }
                        }
                    } else {
                        # Download not finished yet
                        Write-Log "$($Name) ($Version): Download not finished."
                    }
                }

                # Now iterate over Content information from AE to make sure there aren't any lingering entries
                # as content might have been cleaned locally without updating AE properly.
                foreach ($ContentEntry in $DeviceHash.Keys) {
                    if (-Not($LocalDeviceHash.ContainsKey($ContentEntry))) {
                        $ContentEntry = $DeviceHash[$ContentEntry]

                        if ($null -ne $ContentEntry) {
                            try {
                                $RemovedContent = Remove-AEDeviceContent -AEServer $AEInfo.PlatformUrl -DeviceID $AEInfo.DeviceId -ContentID $ContentEntry.Id -Verbose:$false
                                if ($RemovedContent.WasSuccessful) {
                                    Write-Log "$($ContentEntry.ContentName) ($($ContentEntry.Version)): $($RemovedContent.Message)"
                                } else {
                                    Write-Log "$($ContentEntry.ContentName) ($($ContentEntry.Version)): $($RemovedContent.Message)" -Severity Error
                                }
                            } catch {
                                Write-Log "$($ContentEntry.ContentName) ($($ContentEntry.Version)): Failed to remove content delivery '$($ContentEntry.Id)'" -Severity Error
                            }
                        } else {
                            # How did you get here?
                        }
                    }
                }
            }
        } else {
            Write-Log 'No local Active Efficiency DeviceID found.' -Severity Error
        }
    } else {
        Write-Log 'No Active Efficiency information found. Probably not installed/configured.' -Severity Error
    }

    Write-Log "Finish 'Publish-LocalNomadPackage'"
    Write-Log '-------------------------------------------'
}

begin {
Function Join-Parts {

    <#
        .SYNOPSIS
        Joins multiple parts of an URI.

        .DESCRIPTION
        Helper method to properly join multiple parts of an URI

    #>
    [CmdLetBinding()]
    param(

        $Parts = $null,
        $Separator = '',
        $ReplaceSeparator
    )

    process {
        ($Parts | Where-Object { $_ } | Foreach-Object{if(-Not([string]::IsNullOrEmpty($ReplaceSeparator))) {$_ -replace [regex]::Escape($ReplaceSeparator), $Separator} else {$_}} | ForEach-Object { ([string]$_).trim($Separator) } | Where-Object { $_ } ) -join $Separator
    }
}

Function Invoke-AERequest {


    [CmdLetBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$AEServer,

        [Parameter(Mandatory)]
        [string]$ResourcePath,

        [ValidateSet("Get", "Post", "Put", "Delete")]
        [string]$Method = "Get",

        $Body
    )

    process {
        $InvokeParams = @{
            Method = $Method
            Uri = Join-Parts -Separator '/' -ReplaceSeparator '\' -Parts $AEServer, $ResourcePath
            ContentType = "application/json"
            Headers = @{ACCEPT="application/json"}
        }

        # Add Body if supplied
        if ($null -ne $Body) {
            if ($Method -eq "Get") {
                # Get can't handle json body.
                # will add the parameters to the url instead.
                $InvokeParams.Body = $Body
            } else {
                $InvokeParams.Body = ConvertTo-Json $Body
            }
        }

        try {
            $Result = Invoke-RestMethod @InvokeParams -ErrorVariable RestError -ErrorAction SilentlyContinue
        } catch {
            # Handle certain exceptions in a better way
            if ($_.exception -is [System.Net.WebException]) {
                $HttpStatusCode = $_.exception.Response.StatusCode.Value__
                $HttpStatusDescription = $_.exception.Response.StatusDescription

                if ($HttpStatusCode -eq 404) {
                    # Resource not found. Just return $null.
                    Write-Verbose $HttpStatusDescription
                } else {
                    Throw $_
                }
            } else {
                Throw $_
            }
        }

        if ($RestError) {
            $HttpStatusCode = $RestError.ErrorRecord.Exception.Response.StatusCode.value__
            $HttpStatusDescription = $RestError.ErrorRecord.Exception.Response.StatusDescription
            Write-Verbose $HttpStatusDescription
            #Throw "Http Status Code: $($HttpStatusCode) `nHttp Status Description: $($HttpStatusDescription)"
        }

        Write-Output $Result
    }
}

Function Get-AELocalDeviceInfo {

    <#
    .EXTERNALHELP PS1EAE-help.xml
    #>
    [CmdLetBinding()]
    param()

    process{
        if (Test-Path -Path "HKLM:\\SOFTWARE\1E\NomadBranch\ActiveEfficiency") {
            $AE = Get-ItemProperty -Path "HKLM:\\SOFTWARE\1E\NomadBranch\ActiveEfficiency" -ErrorAction SilentlyContinue

            if ($null -ne $AE) {
                $AEInfo = [PSCustomObject]@{
                    DeviceID = $AE.DeviceID
                    DeviceType = $AE.NomadDeviceType
                    AdapterConfigurationId = $AE.AdapterConfigurationId
                    ipv4 = $AE.ipv4
                    ipv4Subnet = $AE.ipv4Subnet
                    PlatformUrl = $AE.PlatformUrl
                    ContentProvider = ($AE.ContentProvider -eq 1)
                    ContentRegistration = ($AE.ContentRegistraiton -eq 1)
                }
            }
        }

        if (($null -ne $AEInfo) -and  (Test-Path -Path "HKLM:\\SOFTWARE\1E\Common")) {
            $1E = Get-ItemProperty -Path "HKLM:\\SOFTWARE\1E\Common" -ErrorAction SilentlyContinue

            if ($null -ne $1E) {
                $AEInfo | Add-Member -MemberType NoteProperty -Name "HardwareId" -Value ($1E.HardwareId)
                $AEInfo | Add-Member -MemberType NoteProperty -Name "UniqueIdentifier" -Value ($1E.UniqueIdentifier)
            }
        }

        Write-Output $AEInfo
    }
}

Function Convert-DateString {

    [CmdLetBinding()]
    param(
        [Parameter(ValueFromPipeline)]
        [String]$Date,
        [String[]]$Format = 'yyyyMMddHHmmssfff'
    )

    process{
        $result = New-Object DateTime

        $convertible = [DateTime]::TryParseExact(
            $Date,
            $Format,
            [System.Globalization.CultureInfo]::InvariantCulture,
            [System.Globalization.DateTimeStyles]::None,
            [ref]$result)

        if ($convertible) { $result }
    }
 }

Function Get-AEDeviceContent {

    <#
    .EXTERNALHELP PS1EAE-help.xml
    #>
    [CmdLetBinding()]
    param(
        # Specified the URI of the 1E ActiveEfficiency server
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$AEServer,

        # Specifies the AE DeviceID
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [Alias("Id")]
        [string]$DeviceID,

        # Specifies the AE device content ID.
        [string]$ContentID
    )

    process{
        $Path = "Devices/$DeviceID/ContentDelivery"

        if (-Not([string]::IsNullOrWhiteSpace($ContentID))) {
            $Path = "$Path/$ContentID"
        }

        Invoke-AERequest -Method Get -AEServer $AEServer -ResourcePath $Path
    }
}

Function Update-AEDeviceContent {

    <#
    .EXTERNALHELP PS1EAE-help.xml
    #>
    [CmdLetBinding(SupportsShouldProcess)]
    param(
        # Specified the URL of the 1E ActiveEfficiency server
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$AEServer,

        # Specifies the AE DeviceID
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string]$DeviceID,

        # Specifies the AE ContentID
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [Alias("Id")]
        [string]$ContentID,

        # Specifies the current percentage of the downloaded content
        # Will be 100% on default.
        [Parameter(ValueFromPipelineByPropertyName)]
        [int]$Percent = 100,

        # Specifies the endtime of the download
        [Parameter(ValueFromPipelineByPropertyName)]
        [datetime]$EndTime
    )

    process{
        $Path = "Devices/$DeviceID/ContentDelivery"

        $Content = @{
            Id = $ContentID
            DeviceId = $DeviceID
        }

        if ($Percent -gt 0) {
            $Content.Percent = $Percent
        }

        if ($null -ne $EndTime) {
            $Content.EndTime = $EndTime.ToUniversalTime().ToString('u')
        }

        Invoke-AERequest -Method Put -AEServer $AEServer -ResourcePath $Path -Body $Content
    }
}

Function New-AEDeviceContent {

    <#
    .EXTERNALHELP PS1EAE-help.xml
    #>
    [CmdLetBinding()]
    param(
        # Specified the URL of the 1E ActiveEfficiency server
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$AEServer,

        # Specifies the AE DeviceID
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string]$DeviceID,

        # Specifies the content name
        # Typically the SCCM PackageID or Content ID of the application or update
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [Alias("ContentName")]
        [string]$Name,

        # Specifies the content version
        [Parameter(Mandatory)]
        [ValidateScript({$_ -ge 1})]
        [int]$Version,

        # Specifies the size of the content in Bytes
        [ValidateScript({$_ -gt 0})]
        [int]$Size,

        # Specifies the number of files of the content.
        [int]$NumberOfFiles = 1,

        # Specifies the current percentage of the downloaded content
        # Will be 100% on default.
        [int]$Percent = 100,

        # Specifies the starttime of the download
        [datetime]$StartTime = (Get-Date),

        # Specifies the endtime of the download
        [datetime]$EndTime = (Get-Date)
    )

    process{
        $Path = "Devices/$DeviceID/ContentDelivery"

        $Content = @{
            DeviceId = $DeviceID
            ContentName = $Name
            Version = $Version
            Percent = $Percent
            Size = $Size
            NumberOfFiles = $NumberOfFiles
            StartTime = $StartTime.ToUniversalTime().ToString('u')
            EndTime = $EndTime.ToUniversalTime().ToString('u')
        }

        Invoke-AERequest -Method Post -AEServer $AEServer -ResourcePath $Path -Body $Content
    }
}

Function Remove-AEDeviceContent {

    <#
    .EXTERNALHELP PS1EAE-help.xml
    #>
    [CmdLetBinding(SupportsShouldProcess)]
    param(
        # Specified the URI of the 1E ActiveEfficiency server
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$AEServer,

        # Specifies the AE DeviceID
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string]$DeviceID,

        # Specifies the AE device content ID.
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias("Id")]
        [string]$ContentID
    )

    process{
        $Path = "devices/$DeviceID/ContentDelivery"

        if (-Not([string]::IsNullOrWhiteSpace($ContentID))) {
            $Path = "$Path/$ContentID"
        }
        Invoke-AERequest -Method Delete -AEServer $AEServer -ResourcePath $Path
    }
}

Function New-AEDevice {

    <#
    .EXTERNALHELP PS1EAE-help.xml
    #>
    [CmdLetBinding(DefaultParameterSetName="ByUUID")]
    param(
        # Specified the URI of the 1E ActiveEfficiency server
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$AEServer,

        [Parameter(Mandatory)]
        [string]$HostName,

        [Parameter(Mandatory)]
        [string]$DomainName,

        # Specifies the Fqdn of the machine.
        # If not specified, it will be created based on Hostname and Domain name
        [string]$Fqdn,

        # Specifies a list of Identities. At least one must be defined
        # Each Identity should contain
        # - Source (eg "SMBIOS", or "FQDN")
        # - Identity (eg "AEC72B25-6D7E-11E1-8967-452301000030", or "MyMachine.Domain.com")
        # - CreatedBy
        [Parameter(Mandatory, ParameterSetName="ByIdentities")]
        [PSCustomObject[]]$Identities,

        # Specifies the SMBIOS GUID
        [Parameter(Mandatory, ParameterSetName="ByUUID")]
        [string]$SMBiosGuid,

        # Specifies the Nomad UniqueIdentifier
        # Typically stored in HKLM:\SOFTWARE\1E\Common
        [Parameter(ParameterSetName="ByUUID")]
        [string]$NomadUUID,

        # Specifies the Device Type
        [ValidateSet("Unknown", "Desktop", "Laptop", "Server")]
        [string]$Type = "Unknown",

        # Specifies the Device Type ID
        # Can be specified if the underlying value is known
        # Takes precedence over "Type" if specified
        [int]$TypeID = -1,

        # Specifies the Creator of the entry
        [string]$CreatedBy = "1E Nomad"
    )

    process{

        $Path = "Devices"

        if ([string]::IsNullOrWhiteSpace($Fqdn)) {
            if (-Not([string]::IsNullOrWhiteSpace($DomainName))) {
                $Fqdn = "{0}.{1}" -f $Hostname, $DomainName
            }
        }

        if ($TypeID -lt 0) {
            switch ($Type) {
                "Unknown" {$TypeID = 0; break}
                "Desktop" {$TypeID = 1; break}
                "Laptop" {$TypeID = 2; break}
                "Server" {$TypeID = 3; break}
            }
        }

        if (-Not([string]::IsNullOrWhiteSpace($SMBiosGuid))) {
            $DeviceIdentities = @(@{Source = "SMBIOS"; Identity = $SMBiosGuid}, @{Source = "FQDN"; Identity = $FQDN})

            if (-Not([string]::IsNullOrWhiteSpace($NomadUUID))) {
                $DeviceIdentities += @{Source = "MACHINE_ID"; Identity = $NomadUUID}
            }
        } else {
            $DeviceIdentities = $Identities
        }

        $Body = @{
            Hostname = $HostName
            DomainName = $DomainName
            Fqdn = $Fqdn
            CreatedBy = $CreatedBy
            Type = $TypeID
            DeviceIdentities = $DeviceIdentities
        }

        Invoke-AERequest -Method Put -AEServer $AEServer -ResourcePath $Path -Body $Body
    }
}

    # Helper function to convert the Nomad Datetime string into a usable DateTime object
    function Convert-DateString {
        [CmdLetBinding()]
        param(
            [Parameter(ValueFromPipeline)]
            [String]$Date,
            [String[]]$Format = 'yyyyMMddHHmmssfff'
        )

        process{
            $result = New-Object DateTime

            $convertible = [DateTime]::TryParseExact(
                $Date,
                $Format,
                [System.Globalization.CultureInfo]::InvariantCulture,
                [System.Globalization.DateTimeStyles]::None,
                [ref]$result)

            if ($convertible) { $result }
        }
     }

    function Write-Log {
        <#
        .SYNOPSIS
            Write-Log writes a message to a specified log file with the current time stamp.

        .DESCRIPTION
            The Write-Log function is designed to add logging capability to other scripts.
            In addition to writing output and/or verbose you can write to a log file for
            later debugging.

        .EXAMPLE
            Write-Log -Message 'Log message'
            Writes the message to c:\Logs\PowerShellLog.log.

        .EXAMPLE
            Write-Log -Message 'Restarting Server.' -Path c:\Logs\Scriptoutput.log
            Writes the content to the specified log file and creates the path and file specified.

        .EXAMPLE
            Write-Log -Message 'Folder does not exist.' -Path c:\Logs\Script.log -Level Error
            Writes the message to the specified log file as an error message, and writes the message to the error pipeline.
        #>
        [CmdletBinding()]
        param (
            # Defines the content that should be added to the log file.
            [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
            [ValidateNotNullOrEmpty()]
            [Alias('LogContent')]
            [string]$Message,

            # The path to the log file to which the Message shall be written.
            # Path and file will be created if it does not exist.
            # If omitted function will use the $LogPath variable defined on script or global level.
            # If that isn't set as well, function will fail
            [Parameter(Mandatory=$false)]
            [Alias('LogPath')]
            [string]$Path,

            # Defines the criticality of the log information being written to the log.
            # Can be any of Error, Warning, Informational
            # Default is Info
            [Parameter(Mandatory=$false)]
            [ValidateSet('Error','Warning','Info')]
            [Alias('Level')]
            [string]$Severity='Info',

            # Defines if the Message should be passed through the pipeline.
            # Severity will be mapped to the corresponding Write-Verbose, Write-Warning
            # or Write-Error functions
            [Switch]$PassThru,

            # Defines if the message should be written as plain text message.
            # On default, System Center Configuration Manager log format is used.
            [Alias('AsText','a')]
            [Switch] $AsPlainText
        )

        begin {
            # Get Logpath from script/global level if not supplied explicitly
            if ([string]::IsNullOrEmpty($Path)) {
                $Path = $Script:LogPath
                if ([string]::IsNullOrEmpty($Path)) {
                    $Path = $Global:LogPath
                }
            }

            # Evaluate caller information
            $Caller = (Get-PSCallStack)[1]
            $Component = $Caller.Command
            $Source = $Caller.Location
        }

        process {
            if ([string]::IsNullOrEmpty($Path)) {
                Write-Error 'Neither 'Path' parameter nor global variable 'LogPath' have been set. Unable to write log entry.'
                Return
            }

            # Make sure file and path exist
            if (-not(Test-Path $Path)) {
                Write-Verbose "Creating '$Path'."
                New-Item $Path -Force -ItemType File -ErrorAction SilentlyContinue | Out-Null
            }

            if ($AsPlainText) {
                $FormattedDate = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
                $LogText = "$FormattedDate [$($Severity.ToUpper())] - $Message"
            } else {
                # Prepare ConfigMgr Log entry
                switch ($Severity) {
                    'Error' { $Sev = 3 }
                    'Warning' { $Sev = 2 }
                    'Info' { $Sev = 1 }
                }

                # Get Timezone Bias to allign log entries through different timezones
                if ($null -eq $Script:TimezoneBias) {
                    [int] $Script:TimezoneBias = Get-CimInstance -ClassName Win32_TimeZone -ErrorAction SilentlyContinue -Verbose:$false | Select-Object -ExpandProperty Bias
                }

                $Date = Get-Date -Format 'MM-dd-yyyy'
                $Time = Get-Date -Format 'HH:mm:ss.fff'
                $TimeString = "$Time$script:TimezoneBias"

                $LogText = "<![LOG[$Message]LOG]!><time=`"$TimeString`" date=`"$Date`" component=`"$Component`" context=`"`" type=`"$Sev`" thread=`"0`" file=`"$Source`">"
            }

            # Write log entry to $Path
            $LogText | Out-File -FilePath $Path -Append -Force -Encoding default -NoClobber -ErrorAction SilentlyContinue

            # forward to pipeline
            $Verbose = $VerbosePreference -ne 'SilentlyContinue'
            if ($PassThru.IsPresent -or $Verbose) {
                switch ($Severity) {
                    'Error' { Write-Error $Message }
                    'Warning' { Write-Warning $Message }
                    'Info' { Write-Verbose $Message }
                }
            }
        }
    }
}

