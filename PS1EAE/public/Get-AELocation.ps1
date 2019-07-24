function Get-AELocation {
    <#
        .SYNOPSIS
        Returns ActiveEfficiency Locations.

        .DESCRIPTION
        The Get-AELocations Cmdlet returns ActiveEfficiency Locations.

        .EXAMPLE
        PS C:\>$AEInfo = Get-AELocalDeviceInfo
        PS C:\>$Locations = Get-AELocation -AEServer $AEInfo.PlatformUrl

    #>
    [CmdLetBinding()]
    param(
        # Specified the URI of the 1E ActiveEfficiency server
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$AEServer,

        # Specifies the AE LocationID
        [string]$LocationID,

        # Specifies how many entries should be returned in one batch
        # Default is 100. Set to 0 to return all entries
        # Doesn't apply if LocationID is supplied
        [int]$Top = 100,

        # Specifies how many batches should be skipped
        # Doesn't apply if LocationID is supplied
        [int]$Skip = 0
    )

    process{
        $Path = "Locations"

        if (-Not([string]::IsNullOrWhiteSpace($LocationID))) {
            $Path = "$Path/$LocationID"
        } else {
            if ($Top -gt 0 ) {
                $Body = @{
                    '$Top' = $Top
                    '$Skip' = $Skip
                }
            }
        }

        Invoke-AERequest -Method Get -AEServer $AEServer -ResourcePath $Path -Body $Body
    }
}