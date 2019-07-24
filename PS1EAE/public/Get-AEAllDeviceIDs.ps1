function Get-AEAllDeviceIDs {
    <#
        .SYNOPSIS
        Returns all Active Efficiency Device IDs.

        .DESCRIPTION
        The Get-AEAllDeviceIDs Cmdlet returns all Active Efficiency Device IDs.

        .EXAMPLE
        PS C:\>$Url = (Get-AELocalDeviceInfo).PlatformUrl
        PS C:\>$DeviceIDs = Get-AEAllDeviceIDs -AEServer $Url

    #>
    [CmdLetBinding()]
    param(
        # Specified the URI of the 1E ActiveEfficiency server
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$AEServer
    )

    process{
        $DeviceIDs = Invoke-AERequest -Method Get -AEServer $AEServer -ResourcePath "AllDeviceIds"

        Write-Output $Device
    }
}