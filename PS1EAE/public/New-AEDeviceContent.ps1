function New-AEDeviceContent {
    <#
        .SYNOPSIS
        Creates new ActiveEfficiency Device content.

        .DESCRIPTION
        The New-AEDeviceContent Cmdlet creates new ActiveEfficiency Devices content.

        .NOTES
        CreatedBy is not supported by the api call.

        .EXAMPLE
        PS C:\>

    #>
    [CmdLetBinding()]
    param(
        # Specified the URL of the 1E ActiveEfficiency server
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$AEServer,

        # Specifies the AE DeviceID
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string]$DeviceID,

        # Specifies the content name
        # Typically the SCCM PackageID or Content ID of the application or update
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [Alias("ContentName")]
        [string]$Name,

        # Specifies the content version
        [Parameter(Mandatory)]
        [ValidateScript({$_ -ge 1})]
        [int]$Version,

        # Specifies the size of the content in Bytes
        [ValidateScript({$_ -gt 0})]
        [int]$Size,

        # Specifies the number of files of the content.
        [int]$NumberOfFiles = 1,

        # Specifies the current percentage of the downloaded content
        # Will be 100% on default.
        [int]$Percent = 100,

        # Specifies the starttime of the download
        [datetime]$StartTime = (Get-Date),

        # Specifies the endtime of the download
        [datetime]$EndTime = (Get-Date)
    )

    process{
        $Path = "Devices/$DeviceID/ContentDelivery"

        $Content = @{
            DeviceId = $DeviceID
            ContentName = $Name
            Version = $Version
            Percent = $Percent
            Size = $Size
            NumberOfFiles = $NumberOfFiles
            StartTime = $StartTime.ToUniversalTime().ToString('u')
            EndTime = $EndTime.ToUniversalTime().ToString('u')
        }

        Invoke-AERequest -Method Post -AEServer $AEServer -ResourcePath $Path -Body $Content
    }
}