function Find-AEContent {
    <#
        .SYNOPSIS
        Returns ActiveEfficiency Devices.

        .DESCRIPTION
        The Find-AEContent Cmdlet searches for Devices with the specified content.

        .EXAMPLE
        PS C:\>PS C:\>$Url = (Get-AELocalDeviceInfo).PlatformUrl
        PS C:\>$Sources = Find-AEContent -AEServer $Url -Name 'TST012345' -Version 1 -Subnet '10.10.10.0/24' -Extend Subnet

    #>
    [CmdLetBinding()]
    param(
        # Specified the URI of the 1E ActiveEfficiency server
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$AEServer,

        # Specifies the Content Name to find
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [Alias("ContentName")]
        [string]$Name,

        # Specifies the subnet for the content to find
        # Need to be supplied in CIDR format
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({$_ -match "^([0-9]{1,3}\.){3}[0-9]{1,3}(\/([0-9]|[1-2][0-9]|3[0-2]))?$"})]
        [Alias("ipV4Subnet")]
        [string]$Subnet,

        # Specifies the version of the content to find
        [Parameter(Mandatory)]
        [string]$Version,

        # Specifies the extent of the search
        # Can be 'SiteOnly' or 'Subnet'. Default is SiteOnly
        [ValidateSet("SiteOnly", "Subnet")]
        [string]$Extent = "SiteOnly",

        # Specifies the required percentage.
        # Defaults to 100%.
        # Is there a legit reason to look for anything below 100%?
        [int]$Percent = 100,

        # Specifies if all subnets of the site should be included in the search
        [switch]$AllSubnets,

        # Specifies if Device Tag should be excluded from the result
        [switch]$ExcludeDeviceTags,

        # Specifies if the result should be randomized
        [switch]$RandomizeResult,

        # Specifies how many entries should be returned in one batch
        [int]$Top = 100,

        # Specifies how many batches should be skipped
        [int]$Skip = 0
    )

    process{
        $Path = "ContentDelivery"

        $Query = @{
            contentName = $Name
            version = $Version
            percent = $Percent
            ipv4Subnet = $Subnet
            extent = $Extent
        }

        if ($AllSubnets.IsPresent) {
            $Query.allSubnets = $true
        }

        if ($ExcludeDeviceTags.IsPresent) {
            $Query.excludeDeviceTags = $true
        }

        if ($RandomizeResult.IsPresent) {
            $Query.randomizeResult = $true
        }

        # The Web api uses "Take" rather than "Top" on this query
        # Using "Top" as general term in the wrapper to harmonize
        if ($Top -gt 0 ) {
            $Query.Take = $Top
            $Query.Skip = $Skip
        }

        Invoke-AERequest -Method Get -AEServer $AEServer -ResourcePath $Path -Body $Query
    }
}