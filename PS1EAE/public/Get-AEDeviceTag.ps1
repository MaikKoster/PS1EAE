function Get-AEDeviceTag {
    <#
        .SYNOPSIS
        Returns ActiveEfficiency Device tags.

        .DESCRIPTION
        The Get-AEDevice Cmdlet returns ActiveEfficiency Device tags.

        .EXAMPLE
        PS C:\>$AEInfo = Get-AELocalDeviceInfo
        PS C:\>$Tags = Get-AEDeviceTag -AEServer $AEInfo.PlatformUrl -DeviceID $AEInfo.DeviceId

    #>
    [CmdLetBinding()]
    param(
        # Specified the URI of the 1E ActiveEfficiency server
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$AEServer,

        # Specifies the AE DeviceID
        [Parameter(Mandatory)]
        [string]$DeviceID,

        # Specifies the Tag Category
        [string]$Category,

        # Specifies the Tag name
        [string]$Name,

        # Specifies the Tag Index
        [int]$Index
    )

    process{
        $Path = "devices/$DeviceID/tags"

        if (-Not([string]::IsNullOrWhiteSpace($Category))) {
            $Path = "$Path/$Category"

            if (-Not([string]::IsNullOrWhiteSpace($Name))) {
                $Path = "$Path/$Name"

                if (-Not([string]::IsNullOrWhiteSpace($Category))) {

                }
            }
        }

        Invoke-AERequest -Method Get -AEServer $AEServer -ResourcePath $Path
    }
}