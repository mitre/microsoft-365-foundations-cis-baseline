param (
    [Parameter(Mandatory)]
    [string]$JSON_CERT,
    [Parameter(Mandatory)]
    [string]$CERT_SECRET,
    [Parameter(Mandatory)]
    [string]$AAD_APP_ID,
)

$byteCert = Get-Content $JSON_CERT -AsByteStream
# Convert the bytes to int and then json
$byteCert | %{[int]$_} | ConvertTo-Json -Compress

$certPath = "$PSScriptRoot\cert.pfx"
[IO.File]::WriteAllBytes($certPath,($JSON_CERT | ConvertFrom-Json | %{[byte]$_}))


