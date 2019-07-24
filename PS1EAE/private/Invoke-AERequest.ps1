# Just a generic function to centrally handle errors, logging etc when executing the web requests
function Invoke-AERequest {

    [CmdLetBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$AEServer,

        [Parameter(Mandatory)]
        [string]$ResourcePath,

        [ValidateSet("Get", "Post", "Put", "Delete")]
        [string]$Method = "Get",

        $Body
    )

    process {
        $InvokeParams = @{
            Method = $Method
            Uri = Join-Parts -Separator '/' -ReplaceSeparator '\' -Parts $AEServer, $ResourcePath
            ContentType = "application/json"
            Headers = @{ACCEPT="application/json"}
        }

        # Add Body if supplied
        if ($null -ne $Body) {
            if ($Method -eq "Get") {
                # Get can't handle json body.
                # will add the parameters to the url instead.
                $InvokeParams.Body = $Body
            } else {
                $InvokeParams.Body = ConvertTo-Json $Body
            }
        }

        try {
            $Result = Invoke-RestMethod @InvokeParams -ErrorVariable RestError -ErrorAction SilentlyContinue
        } catch {
            # Handle certain exceptions in a better way
            if ($_.exception -is [System.Net.WebException]) {
                $HttpStatusCode = $_.exception.Response.StatusCode.Value__
                $HttpStatusDescription = $_.exception.Response.StatusDescription

                if ($HttpStatusCode -eq 404) {
                    # Resource not found. Just return $null.
                    Write-Verbose $HttpStatusDescription
                } else {
                    Throw $_
                }
            } else {
                Throw $_
            }
        }

        if ($RestError) {
            $HttpStatusCode = $RestError.ErrorRecord.Exception.Response.StatusCode.value__
            $HttpStatusDescription = $RestError.ErrorRecord.Exception.Response.StatusDescription
            Write-Verbose $HttpStatusDescription
            #Throw "Http Status Code: $($HttpStatusCode) `nHttp Status Description: $($HttpStatusDescription)"
        }

        Write-Output $Result
    }
}