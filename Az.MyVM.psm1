Get-ChildItem -Path (Join-Path $PSScriptRoot "Functions") -Filter *.ps1 | ForEach-Object {
    . $_.FullName
}
