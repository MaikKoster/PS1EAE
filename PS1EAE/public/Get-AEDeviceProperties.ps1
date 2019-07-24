function Get-AEDeviceProperties {
    <#
        .SYNOPSIS
        Returns ActiveEfficiency Device properties.

        .DESCRIPTION
        The Get-AEDevice Cmdlet returns ActiveEfficiency Devices properties.

        .EXAMPLE
        PS C:\>$AEInfo = Get-AELocalDeviceInfo
        PS C:\>$SysProps = Get-AEDeviceProperties -AEServer $AEInfo.PlatformUrl -DeviceID $AEInfo.DeviceId

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
        [string]$DeviceID
    )

    process{
        $Path = "Devices/$DeviceID/SystemProperties"

        Invoke-AERequest -Method Get -AEServer $AEServer -ResourcePath $Path
    }
}