function Update-AEDevice {
    <#
        .SYNOPSIS
        Updates an existing ActiveEfficiency Device

        .DESCRIPTION
        The Update-AEDevice Cmdlet Updates an existing ActiveEfficiency Device.

        .EXAMPLE
        PS C:\>

    #>
    [CmdLetBinding()]
    param(
        # Specified the URI of the 1E ActiveEfficiency server
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$AEServer,

        # Specifies the Device Id
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Alias("Id")]
        [string]$DeviceID,

        # Specifies the Hostname
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$HostName,

        # Specifies the Domain Name
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$DomainName,

        # Specifies the Fqdn of the machine.
        # If not specified, it will be created based on Hostname and Domain name
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$Fqdn,

        # Specifies a list of Identities. At least one must be defined
        # Each Identity should contain
        # - Source (eg "SMBIOS", or "FQDN")
        # - Identity (eg "AEC72B25-6D7E-11E1-8967-452301000030", or "MyMachine.Domain.com")
        # - CreatedBy
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [PSCustomObject[]]$Identities,

        [Parameter(ValueFromPipelineByPropertyName)]
        [int]$Type,

        # Specifies the Creator of the entry
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$CreatedBy = "1E Nomad"
    )

    process{

        $Path = "Devices"

        if ([string]::IsNullOrWhiteSpace($Fqdn)) {
            if (-Not([string]::IsNullOrWhiteSpace($DomainName))) {
                $Fqdn = "{0}.{1}" -f $Hostname, $DomainName
            }
        }

        $Body = @{
            Id = $DeviceID
            Hostname = $HostName
            DomainName = $DomainName
            Fqdn = $Fqdn
            CreatedBy = $CreatedBy
            Type = $Type
            DeviceIdentities = $Identities
        }

        Invoke-AERequest -Method Put -AEServer $AEServer -ResourcePath $Path -Body $Body
    }
}