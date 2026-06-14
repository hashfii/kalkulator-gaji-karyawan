$ErrorActionPreference = "Stop"

$ProjectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $ProjectRoot

$JavaFxVersion = "21.0.6"
$AppName = "Kalkulator Gaji Karyawan"
$ModuleName = "id.ac.hashfi.payroll"
$MainClass = "id.ac.hashfi.tugas3.SalaryCalculatorApp"
$CacheDir = Join-Path $ProjectRoot ".javafx-cache"
$OutDir = Join-Path $ProjectRoot "out"
$DistDir = Join-Path $ProjectRoot "dist"
$Artifacts = @("javafx-base", "javafx-graphics", "javafx-controls")

if (-not (Get-Command javac -ErrorAction SilentlyContinue)) {
    throw "javac not found. Install JDK 21 or newer."
}

if (-not (Get-Command jpackage -ErrorAction SilentlyContinue)) {
    throw "jpackage not found. Install full JDK 21 or newer, not JRE."
}

$ResolvedRoot = (Resolve-Path $ProjectRoot).Path

function Remove-ProjectFolder($Path) {
    if (Test-Path $Path) {
        $ResolvedPath = (Resolve-Path $Path).Path
        if (-not $ResolvedPath.StartsWith($ResolvedRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
            throw "Refuse to delete folder outside project: $ResolvedPath"
        }
        Remove-Item -LiteralPath $ResolvedPath -Recurse -Force
    }
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

Remove-ProjectFolder $OutDir
Remove-ProjectFolder $DistDir
New-Item -ItemType Directory -Force -Path $OutDir | Out-Null
New-Item -ItemType Directory -Force -Path $DistDir | Out-Null

$JavaFxModulePath = (($Artifacts | ForEach-Object { Join-Path $CacheDir "$_-$JavaFxVersion-win.jar" }) -join ";")

Write-Host "Compiling Java 21 bytecode..."
javac --release 21 `
    --module-path $JavaFxModulePath `
    --add-modules javafx.controls `
    -d $OutDir `
    src\main\java\module-info.java `
    src\main\java\id\ac\hashfi\tugas3\SalaryCalculatorApp.java

Copy-Item src\main\resources\styles.css (Join-Path $OutDir "styles.css") -Force

Write-Host "Packaging portable Windows app..."
jpackage `
    --type app-image `
    --name $AppName `
    --dest $DistDir `
    --module-path "$JavaFxModulePath;$OutDir" `
    --module "$ModuleName/$MainClass" `
    --app-version "1.0.0" `
    --vendor "HASHFI IHKAMUDDIN"

$ExePath = Join-Path $DistDir "$AppName\$AppName.exe"
Write-Host "Build OK."
Write-Host "EXE: $ExePath"
