function Get-AEContentDistributionJob {
    <#
        .SYNOPSIS
        Returns ActiveEfficiency Content Distribution Jobs.

        .DESCRIPTION
        The Get-AEContentDistributionJob Cmdlet returns ActiveEfficiency Content Distribution Jobs (Precache Jobs).

        .EXAMPLE
        PS C:\>$Url = (Get-AELocalDeviceInfo).PlatformUrl
        PS C:\>$Jobs = Get-AEContentDistributionJobs -AEServer $Url

    #>
    [CmdLetBinding()]
    param(
        # Specified the URI of the 1E ActiveEfficiency server
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$AEServer
    )

    process{
        $Path = "ContentDistributionJobs"

        Invoke-AERequest -Method Get -AEServer $AEServer -ResourcePath $Path
    }
}