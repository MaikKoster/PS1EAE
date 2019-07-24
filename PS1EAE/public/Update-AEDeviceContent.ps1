function Update-AEDeviceContent {
    <#
        .SYNOPSIS
        Updates an existing ActiveEfficiency Device content entry.

        .DESCRIPTION
        The Update-AEDeviceContent Cmdlet updates an existing new ActiveEfficiency Devices content entry.

        .NOTES
        Only Percent and EndTime can be updated.
        Name, Version, Size, NumberOfFiles, and StartTime can't be updated. Need to remove and re-add the entry to update.

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
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string]$DeviceID,

        # Specifies the AE ContentID
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [Alias("Id")]
        [string]$ContentID,

        # Specifies the current percentage of the downloaded content
        # Will be 100% on default.
        [Parameter(ValueFromPipelineByPropertyName)]
        [int]$Percent = 100,

        # Specifies the endtime of the download
        [Parameter(ValueFromPipelineByPropertyName)]
        [datetime]$EndTime
    )

    process{
        $Path = "Devices/$DeviceID/ContentDelivery"

        $Content = @{
            Id = $ContentID
            DeviceId = $DeviceID
        }

        if ($Percent -gt 0) {
            $Content.Percent = $Percent
        }

        if ($null -ne $EndTime) {
            $Content.EndTime = $EndTime.ToUniversalTime().ToString('u')
        }

        Invoke-AERequest -Method Put -AEServer $AEServer -ResourcePath $Path -Body $Content
    }
}