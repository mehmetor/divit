Divit'i bu bilgisayara kurmanı istiyorum. Divit, Claude için akademik yazım eklentisidir: https://github.com/mehmetor/divit

Ben teknik biri değilim. Lütfen şöyle ilerle:

1. Bilgisayarın Windows mu Mac mi olduğunu anla.
2. Kurulum betiğini indir ve oku (Windows: https://raw.githubusercontent.com/mehmetor/divit/main/kur.ps1 — Mac: https://raw.githubusercontent.com/mehmetor/divit/main/kur.sh). Ne yapacağını bana sade Türkçeyle, en çok beş maddede anlat. Onayımı bekle.
3. Onaylarsam betiği çalıştır:
   - Windows: powershell -NoProfile -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/mehmetor/divit/main/kur.ps1 | iex"
   - Mac: curl -fsSL https://raw.githubusercontent.com/mehmetor/divit/main/kur.sh | bash
   Kurulum birkaç dakika sürebilir; bitmesini bekle.
4. Sonucu denetle: "claude plugin list" çıktısında "divit@divit" ve "divit-akademik@divit" görünmeli, Belgeler klasöründe "Divit" klasörü oluşmuş olmalı. Hata varsa çıktının son satırlarını oku ve düzeltmeyi dene. Çözemezsen bana ne olduğunu tek cümleyle söyle.
5. Bitince bana şunu söyle: Claude uygulamasında "Code" sekmesine geç, "Select folder" ile Belgeler → Divit klasörünü seç, "merhaba" yaz.

Bilgisayarımda başka hiçbir şeyi değiştirme, hiçbir dosyayı silme.
