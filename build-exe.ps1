$ErrorActionPreference = "Stop"

$ProjectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $ProjectRoot

$JavaFxVersion = "21.0.6"
$AppName = "Kalkulator Gaji Karyawan"
$ModuleName = "id.ac.hashfi.payroll"
$MainClass = "id.ac.hashfi.tugas3.SalaryCalculatorApp"
$CacheDir = Join-Path $ProjectRoot ".javafx-cache"
$ClassesDir = Join-Path $ProjectRoot "target\classes"
$DistDir = Join-Path $ProjectRoot "dist"
$Artifacts = @("javafx-base", "javafx-graphics", "javafx-controls")

$UserMavenHome = [Environment]::GetEnvironmentVariable("MAVEN_HOME", "User")
if (-not [string]::IsNullOrWhiteSpace($UserMavenHome)) {
    $env:MAVEN_HOME = $UserMavenHome
    $env:M2_HOME = $UserMavenHome
}

$MachinePath = [Environment]::GetEnvironmentVariable("Path", "Machine")
$UserPath = [Environment]::GetEnvironmentVariable("Path", "User")
$env:Path = "$MachinePath;$UserPath;$env:Path"

if (-not (Get-Command mvn -ErrorAction SilentlyContinue)) {
    throw "mvn tidak ditemukan. Tutup PowerShell, buka lagi, lalu jalankan ulang script ini."
}

if (-not (Get-Command jpackage -ErrorAction SilentlyContinue)) {
    throw "jpackage tidak ditemukan. Pastikan yang dipasang adalah JDK lengkap, bukan hanya JRE."
}

$ResolvedRoot = (Resolve-Path $ProjectRoot).Path

function Remove-ProjectFolder($Path) {
    if (Test-Path $Path) {
        $ResolvedPath = (Resolve-Path $Path).Path
        if (-not $ResolvedPath.StartsWith($ResolvedRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
            throw "Folder berada di luar project, jadi proses dihentikan: $ResolvedPath"
        }
        Remove-Item -LiteralPath $ResolvedPath -Recurse -Force
    }
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

Remove-ProjectFolder $DistDir
New-Item -ItemType Directory -Force -Path $DistDir | Out-Null

$JavaFxModulePath = (($Artifacts | ForEach-Object { Join-Path $CacheDir "$_-$JavaFxVersion-win.jar" }) -join ";")

Write-Host "Meng-compile program dengan Maven..."
mvn clean compile

Write-Host "Membuat aplikasi Windows..."
jpackage `
    --type app-image `
    --name $AppName `
    --dest $DistDir `
    --module-path "$JavaFxModulePath;$ClassesDir" `
    --module "$ModuleName/$MainClass" `
    --app-version "1.0.0" `
    --vendor "HASHFI IHKAMUDDIN"

$ExePath = Join-Path $DistDir "$AppName\$AppName.exe"
Write-Host "Build berhasil."
Write-Host "EXE: $ExePath"
