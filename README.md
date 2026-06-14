# Tugas 3 - Kalkulator Gaji Karyawan

## Identitas

Nama: HASHFI IHKAMUDDIN  
NIM: 052861984  
Program Studi: Sistem Informasi  
UPBJJ: Kota Bogor

## Tentang Program

Program ini saya buat untuk menghitung gaji karyawan berdasarkan golongan dan jumlah jam lembur. Tampilan program memakai JavaFX supaya lebih nyaman dilihat, tetapi bagian perhitungannya tetap dibuat sederhana sesuai materi dasar pemrograman.

Jadi, untuk logika utama saya tetap memakai:

- array
- operator aritmatika
- percabangan `if/else`

Bagian tampilan hanya dipakai untuk menerima input dan menampilkan hasil perhitungan.

## Cara Kerja Program

Pengguna memilih golongan karyawan, yaitu `A`, `B`, atau `C`. Setelah itu pengguna memasukkan jumlah jam lembur. Program akan mengambil gaji pokok dari array berdasarkan golongan yang dipilih.

Data gaji pokok yang dipakai:

```java
double[] basicSalaryArray = {5000000, 6500000, 9500000};
```

Keterangan:

- Golongan A memakai index `0`
- Golongan B memakai index `1`
- Golongan C memakai index `2`

Untuk persentase lembur, program memakai array berikut:

```java
int[] overtimePercentageArray = {30, 32, 34, 36, 38};
```

Aturan lemburnya:

- 1 jam = 30%
- 2 jam = 32%
- 3 jam = 34%
- 4 jam = 36%
- 5 jam atau lebih = 38%

Setelah persentase lembur diketahui, program menghitung upah lembur dan total gaji.

Rumus yang dipakai:

```text
Upah lembur = (persentase lembur / 100) x gaji pokok
Total gaji  = gaji pokok + upah lembur
```

## File Penting

- `src/main/java/id/ac/hashfi/tugas3/SalaryCalculatorApp.java` berisi kode utama program.
- `src/main/resources/styles.css` berisi pengaturan tampilan.
- `pom.xml` berisi pengaturan Maven dan JavaFX.
- `run.ps1` dipakai sebagai cara cadangan jika Maven belum terbaca di terminal.
- `build-exe.ps1` dipakai untuk compile dengan Maven lalu membuat file aplikasi Windows.

## Menjalankan Program Dengan Maven

Maven sudah saya pasang di laptop ini. Lokasinya ada di:

```text
C:\Users\hashfi\tools\apache-maven-3.9.16
```

Saya juga menambahkan `mvn.cmd` di folder WindowsApps user supaya perintah `mvn` bisa langsung dipakai dari PowerShell.

Untuk mengecek Maven:

```powershell
mvn -version
```

Untuk menjalankan program:

```powershell
mvn clean javafx:run
```

Kalau terminal masih belum mengenali perintah `mvn`, tutup dulu PowerShell lalu buka lagi. Biasanya PATH baru terbaca setelah terminal dibuka ulang.

## Compile Dengan Maven

Kalau hanya ingin mengecek apakah program berhasil di-compile:

```powershell
mvn clean compile
```

Perintah ini akan membuat hasil compile di folder `target`.

## Cara Cadangan Tanpa Maven

Saya juga tetap menyediakan script PowerShell supaya program masih bisa dijalankan walaupun Maven belum terbaca.

Jalankan dari folder project:

```powershell
powershell -ExecutionPolicy Bypass -File .\run.ps1
```

Kalau hanya ingin mengecek apakah kode berhasil di-compile:

```powershell
powershell -ExecutionPolicy Bypass -File .\run.ps1 -CompileOnly
```

Script ini akan mengunduh library JavaFX yang dibutuhkan, lalu melakukan compile dan menjalankan aplikasi.

## Membuat File EXE Dengan Maven

Untuk membuat file `.exe`, saya memakai Maven untuk compile program terlebih dahulu. Setelah itu, aplikasi dibuat menjadi program Windows memakai `jpackage` dari JDK.

Langkahnya dari folder project:

```powershell
mvn clean compile
```

Kalau compile berhasil, lanjutkan dengan:

```powershell
powershell -ExecutionPolicy Bypass -File .\build-exe.ps1
```

Sebenarnya script `build-exe.ps1` juga sudah menjalankan `mvn clean compile`, jadi perintah yang paling praktis adalah langsung:

```powershell
powershell -ExecutionPolicy Bypass -File .\build-exe.ps1
```

Saya tetap menuliskan `mvn clean compile` secara terpisah supaya prosesnya lebih mudah dipahami: Maven dipakai untuk compile, sedangkan `jpackage` dipakai untuk membuat aplikasi Windows.

Hasilnya ada di folder:

```text
dist\Kalkulator Gaji Karyawan
```

File yang dijalankan:

```text
dist\Kalkulator Gaji Karyawan\Kalkulator Gaji Karyawan.exe
```

Catatan: jika ingin memindahkan aplikasi ke laptop lain, folder `Kalkulator Gaji Karyawan` harus dipindahkan seluruhnya. Jangan hanya mengambil file `.exe`, karena folder `runtime` dan `app` juga dibutuhkan.

## Menjalankan Lewat IDE

Program ini juga bisa dijalankan lewat IDE seperti IntelliJ IDEA atau NetBeans.

Langkahnya:

1. Buka folder project.
2. Pastikan SDK memakai Java 21 atau versi lebih baru.
3. Jalankan class `id.ac.hashfi.tugas3.SalaryCalculatorApp`.

## Kesimpulan

Program ini memenuhi aturan tugas karena perhitungan gaji masih memakai array, operator, dan `if/else`. JavaFX hanya digunakan supaya tampilan program lebih rapi dan mudah digunakan.
