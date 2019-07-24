function Update-AEDeviceAdapterConfiguration {
    <#
        .SYNOPSIS
        Updates an existing Active Efficiency Device adapter configuration.

        .DESCRIPTION
        The Update-AEDeviceAdapterConfiguration Cmdlet updates an existing ActiveEfficiency Device adapter configuration.

        .NOTES


        .EXAMPLE
        PS C:\>

    #>
    [CmdLetBinding(SupportsShouldProcess)]
    param(
        # Specified the URL of the 1E ActiveEfficiency server
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$AEServer,

        # Specifies the AE DeviceID
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$DeviceID,

        # Specifies the AE DeviceID
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [Alias("Id")]
        [string]$AdapterConfigurationID,

        # Specifies the IPv4 address of the adapter
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [Alias("IPv4")]
        [string]$IP,

        # Specifies the IPv4 subnet for the adapter
        # Need to be supplied in CIDR format
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({$_ -match "^([0-9]{1,3}\.){3}[0-9]{1,3}(\/([0-9]|[1-2][0-9]|3[0-2]))?$"})]
        [Alias("ipV4Subnet")]
        [string]$Subnet
    )

    process{
        $Path = "Devices/$DeviceID/AdapterConfigurations"

        $Adapter = @{
            Id = $AdapterConfigurationID
            Ipv4 = $IP
            Ipv4Subet = $Subnet
        }

        Invoke-AERequest -Method Put -AEServer $AEServer -ResourcePath $Path -Body $Adapter
    }
}