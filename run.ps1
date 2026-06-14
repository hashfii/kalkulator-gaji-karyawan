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
    throw "java tidak ditemukan. Pastikan JDK 21 atau versi lebih baru sudah terpasang."
}

if (-not (Get-Command javac -ErrorAction SilentlyContinue)) {
    throw "javac tidak ditemukan. Pastikan yang dipasang adalah JDK, bukan hanya JRE."
}

New-Item -ItemType Directory -Force -Path $CacheDir | Out-Null

foreach ($Artifact in $Artifacts) {
    $Jar = Join-Path $CacheDir "$Artifact-$JavaFxVersion-win.jar"
    if (-not (Test-Path $Jar)) {
        $Url = "https://repo.maven.apache.org/maven2/org/openjfx/$Artifact/$JavaFxVersion/$Artifact-$JavaFxVersion-win.jar"
        Write-Host "Mengunduh $Artifact..."
        Invoke-WebRequest -Uri $Url -OutFile $Jar
    }
}

$ResolvedRoot = (Resolve-Path $ProjectRoot).Path
if (Test-Path $OutDir) {
    $ResolvedOut = (Resolve-Path $OutDir).Path
    if (-not $ResolvedOut.StartsWith($ResolvedRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
        throw "Folder output berada di luar project, jadi proses dihentikan: $ResolvedOut"
    }
    Remove-Item -LiteralPath $ResolvedOut -Recurse -Force
}

New-Item -ItemType Directory -Force -Path $OutDir | Out-Null

$ModulePath = (($Artifacts | ForEach-Object { Join-Path $CacheDir "$_-$JavaFxVersion-win.jar" }) -join ";")

Write-Host "Meng-compile program..."
javac --release 21 `
    --module-path $ModulePath `
    --add-modules javafx.controls `
    -d $OutDir `
    src\main\java\module-info.java `
    src\main\java\id\ac\hashfi\tugas3\SalaryCalculatorApp.java

Copy-Item src\main\resources\styles.css (Join-Path $OutDir "styles.css") -Force

if ($CompileOnly) {
    Write-Host "Compile berhasil."
    exit 0
}

Write-Host "Membuka aplikasi..."
java --module-path "$ModulePath;$OutDir" `
    --module id.ac.hashfi.payroll/id.ac.hashfi.tugas3.SalaryCalculatorApp
