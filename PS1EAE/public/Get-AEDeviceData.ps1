function Get-AEDeviceData {
    <#
        .SYNOPSIS
        Returns ActiveEfficiency Device data.

        .DESCRIPTION
        The Get-AEDevice Cmdlet returns ActiveEfficiency Device data.

        .EXAMPLE
        PS C:\>$AEInfo = Get-AELocalDeviceInfo
        PS C:\>$Data = Get-AEDeviceData -AEServer $AEInfo.PlatformUrl -DeviceID $AEInfo.DeviceId

    #>
    [CmdLetBinding()]
    param(
        # Specified the URI of the 1E ActiveEfficiency server
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$AEServer,

        # Specifies the AE DeviceID
        [string]$DeviceID
    )

    process{
        if (-Not([string]::IsNullOrWhiteSpace($DeviceID))) {
            $DeviceURL = "DeviceData/$DeviceID"
        } else  {
            $DeviceURL = "DevicesData"
        }

        Invoke-AERequest -Method Get -AEServer $AEServer -ResourcePath $DeviceURL
    }
}