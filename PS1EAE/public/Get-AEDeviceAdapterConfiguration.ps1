function Get-AEDeviceAdapterConfiguration {
    <#
        .SYNOPSIS
        Returns ActiveEfficiency Device adapter configuration.

        .DESCRIPTION
        The Get-AEDeviceAdapterConfiguration Cmdlet returns ActiveEfficiency Device adapter configuration.

        .EXAMPLE
        PS C:\>$AEInfo = Get-AELocalDeviceInfo
        PS C:\>$AdapterConfig = Get-AEDeviceAdapterConfiguration -AEServer $AEinfo.PlatformUrl -DeviceID $AEInfo.DeviceId

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

        # Specifies the AE device adapter ID.
        [string]$AdapterConfigurationID
    )

    process{
        $Path = "Devices/$DeviceID/AdapterConfigurations"

        if (-Not([string]::IsNullOrWhiteSpace($AdapterConfigurationID))) {
            $Path = "$Path/$AdapterConfigurationID"
        }

        Invoke-AERequest -Method Get -AEServer $AEServer -ResourcePath $Path
    }
}