function New-AEDevice {
    <#
        .SYNOPSIS
        Creates a new ActiveEfficiency Device

        .DESCRIPTION
        The New-AEDevice Cmdlet creates a new ActiveEfficiency Device.
        If a device with the same Identifiers exists already, the entry will be updated.
        If multiple devices with the same Identifier exist, it will fail.

        .EXAMPLE
        PS C:\>

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