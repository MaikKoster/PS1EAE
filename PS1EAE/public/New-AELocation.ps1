function New-AELocation {
    <#
        .SYNOPSIS
        Adds a new AE Location

        .DESCRIPTION
        The New-AELocation Cmdlet adds a new AE location

        .EXAMPLE
        PS C:\>

    #>
    [CmdLetBinding()]
    param(
        # Specified the URL of the 1E ActiveEfficiency server
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$AEServer,

        # Specifies the Site name
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string]$Site,

        # Specifies the Subnet identifier.
        # Must be in CIDR format
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({$_ -match "^([0-9]{1,3}\.){3}[0-9]{1,3}(\/([0-9]|[1-2][0-9]|3[0-2]))?$"})]
        [string]$Subnet
    )

    process{
        $Path = "Locations"

        $Location = @{
            Site = $Site
            Subnet = $Subnet
        }

        Invoke-AERequest -Method Post -AEServer $AEServer -ResourcePath $Path -Body $Location
    }
}