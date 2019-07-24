function Get-AEDeviceContent {
    <#
        .SYNOPSIS
        Returns ActiveEfficiency Device content.

        .DESCRIPTION
        The Get-AEDevice Cmdlet returns ActiveEfficiency Devices content.

        .EXAMPLE
        PS C:\>$AEInfo = Get-AELocalDeviceInfo
        PS C:\>$Content = Get-AEDeviceContent -AEServer $AEInfo.PlatformUrl -DeviceID $AEInfo.DeviceId

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