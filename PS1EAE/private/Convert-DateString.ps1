# Helper function to convert the Nomad Datetimestring into a usable DateTime format
function Convert-DateString {
    [CmdLetBinding()]
    param(
        [Parameter(ValueFromPipeline)]
        [String]$Date,
        [String[]]$Format = 'yyyyMMddHHmmssfff'
    )

    process{
        $result = New-Object DateTime

        $convertible = [DateTime]::TryParseExact(
            $Date,
            $Format,
            [System.Globalization.CultureInfo]::InvariantCulture,
            [System.Globalization.DateTimeStyles]::None,
            [ref]$result)

        if ($convertible) { $result }
    }
 }