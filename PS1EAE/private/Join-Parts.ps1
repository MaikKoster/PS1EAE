function Join-Parts {
    <#
        .SYNOPSIS
        Joins multiple parts of an URI.

        .DESCRIPTION
        Helper method to properly join multiple parts of an URI

    #>
    [CmdLetBinding()]
    param(

        $Parts = $null,
        $Separator = '',
        $ReplaceSeparator
    )

    process {
        ($Parts | Where-Object { $_ } | Foreach-Object{if(-Not([string]::IsNullOrEmpty($ReplaceSeparator))) {$_ -replace [regex]::Escape($ReplaceSeparator), $Separator} else {$_}} | ForEach-Object { ([string]$_).trim($Separator) } | Where-Object { $_ } ) -join $Separator
    }
}