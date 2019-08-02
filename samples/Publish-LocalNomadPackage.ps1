#Requires -Version 3.0
#Requires -Modules PS1EAE

<#
    .SYNOPSIS
    Publishes all locally cached packages to Active Efficieny.

    .DESCRIPTION
    The Publish-LocalNomadPackage Cmdlet reads the content that is cached locally by the Nomad client
    and ensures all is available in Active Efficiency, so other devices are aware of their availability.
    Very useful if machines are used to precache content, but the information in AE is no longer available,
    as the Nomad client will only publish new content and never validate existing one, assuming it exists
    in a perfect world ;)

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

                    $Device = New-AEDevice -AEServer $AEInfo.PlatformUrl -HostName $CS.Name -DomainName $CS.Domain -SMBiosGuid $UUID -TypeID $DeviceType

                    $DeviceID = $Device.Id
                } elseif ([string]::IsNullOrWhiteSpace($CS.Domain)) {
                    Write-Log "No domain found." -Severity Error
                } else {
                    Write-Log "No UUID found." -Severity Error
                }

                if (-Not([string]::IsNullOrWhiteSpace($DeviceID))) {
                    if ($DeviceID -ne $AEInfo.DeviceID) {
                        Write-Log "Local DeviceId and DeviceId in Active Efficiency don't match. Restarting NomadBranch service to force re-evaluation." -Severity Warning
                        Restart-Service -Name NomadBranch -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
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
            $DeviceContent = Get-AEDeviceContent -AEServer $AEInfo.PlatformUrl -DeviceID $AEInfo.DeviceId
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
                                    $RemovedContent = Remove-AEDeviceContent -AEServer $AEInfo.PlatformUrl -DeviceID $AEInfo.DeviceId -ContentID $ContentEntry.Id
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
                            $NewContent = New-AEDeviceContent -AEServer $AEInfo.PlatformUrl -DeviceID $AEInfo.DeviceID -Name $Name -Version $Version -Percent 100 -StartTime $StartTime -EndTime $EndTime
                            Write-Log "$($Name) ($($Version)): Added content delivery '$($NewContent.Id)'"

                            # Add new content to Hashtable
                            $DeviceHash[$Name.ToLower()] = $NewContent
                        } else {
                            # Content exists already. No need to update
                            # $ContentEntry = $DeviceContent | Where-Object {$_.ContentName -eq $Name}
                            $ContentEntry = $DeviceHash[$Name.ToLower()]

                            if (($null -ne $ContentEntry) -and ([Math]::Floor($ContentEntry.Percent) -ne 100)) {
                                $UpdatedContent = Update-AEDeviceContent -AEServer $AEInfo.PlatformUrl -DeviceID $AEInfo.DeviceID -ContentID $ContentEntry.Id -Percent 100 -EndTime $EndTime
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
                                $RemovedContent = Remove-AEDeviceContent -AEServer $AEInfo.PlatformUrl -DeviceID $AEInfo.DeviceId -ContentID $ContentEntry.Id
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
            if ($PassThru.IsPresent) {
                switch ($Severity) {
                    'Error' { Write-Error $Message }
                    'Warning' { Write-Warning $Message }
                    'Info' { Write-Verbose $Message }
                }
            }
        }
    }
}
