function Remove-AELocation {
    <#
        .SYNOPSIS
        Removes an ActiveEfficiency Location.

        .DESCRIPTION
        The Remove-AEDeviceContent Cmdlet removes an ActiveEfficiency Location.
        Currently restricted to a single Location.
        TODO: add suppor to delete all locations

        .EXAMPLE
        PS C:\>

    #>
    [CmdLetBinding(SupportsShouldProcess)]
    param(
        # Specified the URI of the 1E ActiveEfficiency server
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$AEServer,

        # Specifies the AE LocationID
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [Alias("Id")]
        [string]$LocationID
    )

    process{
        $Path = "Locations/$LocationID"

        Invoke-AERequest -Method Delete -AEServer $AEServer -ResourcePath $Path
    }
}