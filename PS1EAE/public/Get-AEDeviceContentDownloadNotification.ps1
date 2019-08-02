function Get-AEDeviceContentDownloadNotification {
    <#
        .SYNOPSIS
        Returns ActiveEfficiency Device content download notifications.

        .DESCRIPTION
        The Get-AEDeviceContentDownloadNotification Cmdlet returns ActiveEfficiency Device content download notifications.

        .EXAMPLE
        PS C:\>$AEInfo = Get-AELocalDeviceInfo
        PS C:\>$Notifications = Get-AEDeviceContentDownloadNotifications -AEServer $AEInfo.PlatformUrl -DeviceID $AEInfo.DeviceId

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
        [string]$DeviceID,

        # Specifies how many entries should be returned in one batch
        [int]$Top = 100,

        # Specifies how many batches should be skipped
        [int]$Skip = 0,

        # Specifies, if only the latest version should be returned
        [switch]$LatestVersionOnly
    )

    process{
        $Path = "ContentDownloadNotifications"

        $Body = @{
            deviceid=$DeviceID
        }

        if ($Top -gt 0 ) {
            $Body.'$Top' = $Top
            $Body.'$Skip' = $Skip
        }

        if ($LatestVersionOnly.IsPresent) {
            $Body.LatestVersionOnly = $LatestVersionOnly.IsPresent
        }

        Invoke-AERequest -Method Get -AEServer $AEServer -ResourcePath $Path -Body $Body
    }
}