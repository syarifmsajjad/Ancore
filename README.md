# Automated Endpoint Crawler for Online Resources

## Deskripsi
Alat ini adalah *Automated Endpoint Crawler for Online Resources* yang dapat membantu Anda menelusuri URL terkait dari berbagai sumber online secara otomatis. Dengan memanfaatkan beberapa API dan layanan publik seperti **VirusTotal**, **URLScan**, **OTX AlienVault**, dan **Wayback Machine**, alat ini mengumpulkan endpoint atau URL terkait untuk domain target yang ditentukan.

https://github.com/user-attachments/assets/b6a6ea64-faa2-468c-81f4-ca41a3c4b0a4

## Fitur
- **Crawl VirusTotal**: Mengambil URL terkait dari laporan VirusTotal menggunakan API domain report.
- **Crawl URLScan**: Menyediakan hasil dari URLScan berdasarkan domain target.
- **Crawl OTX AlienVault**: Mengambil URL terkait dari database AlienVault OTX.
- **Crawl Wayback Machine**: Menampilkan arsip URL dari Wayback Machine untuk domain target.

## Cara Menggunakan
Jalankan perintah berikut di terminal:

```bash
git clone 
./ancore.sh -t <target_domain> -o <output_file>
```

## API KEY
Jangan lupa mengganti nilai VIRUSTOTAL_API_KEY dengan nilai API KEY yang telah digenerate.
Pergi ke virustotal.com buat akun dan generate API KEY. Usahakan minimal 3 buah API KEY.


## Terimakasih
