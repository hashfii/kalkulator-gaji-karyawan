# Tugas 3 - Kalkulator Gaji Karyawan

## Arsitektur

JavaFX dipakai untuk tampilan desktop modern: `ComboBox` untuk golongan, `Spinner` untuk jam lembur, tombol `Hitung Gaji`, dan panel rincian hasil.

Logika inti berada di method `calculatePayroll(...)` pada `SalaryCalculatorApp.java`. Bagian ini sengaja dibuat seperti tugas dasar:

- Array gaji: `{5000000, 6500000, 9500000}`
- Array persentase lembur: `{30, 32, 34, 36, 38}`
- `if/else` memilih index gaji dari input `A/B/C`
- `if/else` memilih index persentase dari jam lembur
- Operator dasar menghitung `upah lembur` dan `total gaji`

UI hanya membaca hasil dari method tersebut dan menampilkannya.

## Run Cepat Tanpa Maven

PowerShell script ini akan download JavaFX jars otomatis, compile bytecode Java 21, lalu membuka aplikasi.

```powershell
.\run.ps1
```

Compile check tanpa membuka aplikasi:

```powershell
.\run.ps1 -CompileOnly
```

Jika PowerShell menolak script lokal:

```powershell
powershell -ExecutionPolicy Bypass -File .\run.ps1
```

## Run Dengan Maven

Pastikan Java 21 dan Maven sudah terpasang.

```powershell
mvn clean javafx:run
```

## Build EXE

Portable Windows app, tanpa Maven:

```powershell
powershell -ExecutionPolicy Bypass -File .\build-exe.ps1
```

Output:

```text
dist\Kalkulator Gaji Karyawan\Kalkulator Gaji Karyawan.exe
```

Kirim seluruh folder `dist\Kalkulator Gaji Karyawan`, bukan hanya file `.exe`, karena runtime JavaFX ikut berada di folder itu.

## Run Dari IDE

1. Buka folder ini sebagai Maven project.
2. Pastikan Project SDK memakai Java 21.
3. Jalankan class `id.ac.hashfi.tugas3.SalaryCalculatorApp`.

## Manual Tanpa Maven

Jika Maven tidak ada, download JavaFX SDK 21 dari OpenJFX/Gluon, lalu compile dengan path `lib` JavaFX SDK.

```powershell
$javafx = "C:\javafx-sdk-21\lib"
javac --release 21 --module-path $javafx --add-modules javafx.controls -d out src\main\java\module-info.java src\main\java\id\ac\hashfi\tugas3\SalaryCalculatorApp.java
Copy-Item src\main\resources\styles.css out\styles.css
java --module-path "$javafx;out" --module id.ac.hashfi.payroll/id.ac.hashfi.tugas3.SalaryCalculatorApp
```
