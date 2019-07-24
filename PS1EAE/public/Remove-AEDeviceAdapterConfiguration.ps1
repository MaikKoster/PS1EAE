function Remove-AEDeviceAdapterConfiguration {
    <#
        .SYNOPSIS
        Removes an ActiveEfficiency Device Adapter Configuration.

        .DESCRIPTION
        The Remove-AEDeviceAdapterConfiguration Cmdlet removes an ActiveEfficiency Device Adapter Configuration.

        .EXAMPLE
        PS C:\>

    #>
    [CmdLetBinding(SupportsShouldProcess)]
    param(
        # Specified the URI of the 1E ActiveEfficiency server
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
        [string]$AdapterConfigurationID
    )

    process{
        $Path = "Devices/$DeviceID/AdapterConfigurations/$AdapterConfigurationID"

        Invoke-AERequest -Method Delete -AEServer $AEServer -ResourcePath $Path
    }
}