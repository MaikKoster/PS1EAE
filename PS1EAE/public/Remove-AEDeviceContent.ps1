function Remove-AEDeviceContent {
    <#
        .SYNOPSIS
        Removes an ActiveEfficiency Device content entry.

        .DESCRIPTION
        The Remove-AEDeviceContent Cmdlet removes an ActiveEfficiency Devices content entry.

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
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string]$DeviceID,

        # Specifies the AE device content ID.
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias("Id")]
        [string]$ContentID
    )

    process{
        $Path = "devices/$DeviceID/ContentDelivery"

        if (-Not([string]::IsNullOrWhiteSpace($ContentID))) {
            $Path = "$Path/$ContentID"
        }
        Invoke-AERequest -Method Delete -AEServer $AEServer -ResourcePath $Path
    }
}