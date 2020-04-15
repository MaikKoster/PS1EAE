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
            if ($PSVersionTable.PSVersion.Major -gt 3) {
                $Result = Invoke-RestMethod @InvokeParams -ErrorVariable RestError -ErrorAction SilentlyContinue
            } else {
                # PS3.0 doesnt allow ACCEPT header for Invoke-RestMethod, so using webclient and UploadData to allow set ContentType
                $WebClient = New-Object System.Net.WebClient
                $WebClient.Headers['Content-Type'] = $InvokeParams.ContentType
                $InvokeParams.Headers.GetEnumerator() | ForEach-Object { $WebClient.Headers[$_.key]=$_.value}
                $Encoding = [System.Text.Encoding]::UTF8
                #TODO: Test body with GET. Might need to convert to url parameters instead
                # DELETE typically has no body. Need to pass in proper HTTP Method.
                #TODO: Validate for other http methods.
                if ($InvokeParams.Body -or $InvokeParams.Method -eq "Delete") {
                    if ($InvokeParams.Method -eq "Delete") {
                        $InvokeParams.Body = ""
                    }
                    $Data = $WebClient.UploadData($InvokeParams.Uri, $InvokeParams.Method, $Encoding.GetBytes($InvokeParams.Body))
                } else {
                    $Data = $WebClient.DownloadData($InvokeParams.Uri)
                }
                $Result = ConvertFrom-Json $Encoding.GetString($data)
            }
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