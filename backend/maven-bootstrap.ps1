param([Parameter(Mandatory=$true)][string]$Version)
$ErrorActionPreference = 'Stop'
$root = Join-Path $env:USERPROFILE ".m2\wrapper\dists\cloudcart-maven\$Version"
$mavenHome = Join-Path $root "apache-maven-$Version"
if (Test-Path (Join-Path $mavenHome 'bin\mvn.cmd')) { exit 0 }
$work = Join-Path ([System.IO.Path]::GetTempPath()) ("cloudcart-maven-" + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $work -Force | Out-Null
try {
    $archive = Join-Path $work "apache-maven-$Version-bin.zip"
    $url = "https://dlcdn.apache.org/maven/maven-3/$Version/binaries/apache-maven-$Version-bin.zip"
    Invoke-WebRequest -Uri $url -OutFile $archive
    Expand-Archive -LiteralPath $archive -DestinationPath $work
    New-Item -ItemType Directory -Path $root -Force | Out-Null
    Move-Item -LiteralPath (Join-Path $work "apache-maven-$Version") -Destination $mavenHome -Force
    if (-not (Test-Path (Join-Path $mavenHome 'bin\mvn.cmd'))) { throw 'Maven archive did not contain the expected executable.' }
} catch {
    Write-Error "Could not download Maven. Check your internet connection and retry. $($_.Exception.Message)"
    exit 1
} finally {
    Remove-Item -LiteralPath $work -Recurse -Force -ErrorAction SilentlyContinue
}
