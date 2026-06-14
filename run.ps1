param(
    [switch]$CompileOnly
)

$ErrorActionPreference = "Stop"

$ProjectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $ProjectRoot

$JavaFxVersion = "21.0.6"
$CacheDir = Join-Path $ProjectRoot ".javafx-cache"
$OutDir = Join-Path $ProjectRoot "out"
$Artifacts = @("javafx-base", "javafx-graphics", "javafx-controls")

if (-not (Get-Command java -ErrorAction SilentlyContinue)) {
    throw "java not found. Install JDK 21 or newer."
}

if (-not (Get-Command javac -ErrorAction SilentlyContinue)) {
    throw "javac not found. Install JDK 21 or newer, not JRE only."
}

New-Item -ItemType Directory -Force -Path $CacheDir | Out-Null

foreach ($Artifact in $Artifacts) {
    $Jar = Join-Path $CacheDir "$Artifact-$JavaFxVersion-win.jar"
    if (-not (Test-Path $Jar)) {
        $Url = "https://repo.maven.apache.org/maven2/org/openjfx/$Artifact/$JavaFxVersion/$Artifact-$JavaFxVersion-win.jar"
        Write-Host "Downloading $Artifact..."
        Invoke-WebRequest -Uri $Url -OutFile $Jar
    }
}

$ResolvedRoot = (Resolve-Path $ProjectRoot).Path
if (Test-Path $OutDir) {
    $ResolvedOut = (Resolve-Path $OutDir).Path
    if (-not $ResolvedOut.StartsWith($ResolvedRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
        throw "Refuse to delete output folder outside project: $ResolvedOut"
    }
    Remove-Item -LiteralPath $ResolvedOut -Recurse -Force
}

New-Item -ItemType Directory -Force -Path $OutDir | Out-Null

$ModulePath = (($Artifacts | ForEach-Object { Join-Path $CacheDir "$_-$JavaFxVersion-win.jar" }) -join ";")

Write-Host "Compiling..."
javac --release 21 `
    --module-path $ModulePath `
    --add-modules javafx.controls `
    -d $OutDir `
    src\main\java\module-info.java `
    src\main\java\id\ac\hashfi\tugas3\SalaryCalculatorApp.java

Copy-Item src\main\resources\styles.css (Join-Path $OutDir "styles.css") -Force

if ($CompileOnly) {
    Write-Host "Compile OK."
    exit 0
}

Write-Host "Launching app..."
java --module-path "$ModulePath;$OutDir" `
    --module id.ac.hashfi.payroll/id.ac.hashfi.tugas3.SalaryCalculatorApp
