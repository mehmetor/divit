---
name: geri-al
description: Bozulan veya istenmeyen bir değişikliği geri alır, bir dosyanın önceki hâlini getirir. Kullanıcı "geri al", "bozuldu", "eski hâline döndür", "az önce ne değişti", "kaybettim" dediğinde kullan.
---

# Geri alma

Hocanın en büyük korkusu çalışmasını kaybetmek. Divit bu korkuyu iki
kuralla karşılar (bkz. `CLAUDE.md` → Önceki sürüm kuralı):

1. Word ve PDF dosyaları hiç yerinde değiştirilmez. Divit her değişikliği
   yeni bir dosyaya yazar. Özgün dosya hep yerindedir.
2. Metin dosyaları değiştirilmeden önce `.divit/onceki-surumler/` altına
   kopyalanır.

Hocaya teknik kelime kullanma: "önceki sürüm", "özgün dosya" yeter.

## Akış

1. **Önce göster, sonra dokun.** Ne değiştiğini bul:
   - `.divit/onceki-surumler/` altındaki klasörleri Glob ile listele.
     Klasör adları tarih ve saattir (`2026-09-27_1430`).
   - Divit'in yazdığı yeni dosyaları bul: `*-divit-*` adlı dosyalar.
2. Sade dille anlat: "Bugün 14:30'da üçüncü bölümün önceki sürümünü
   sakladım. Ondan sonra şu değişti: …"
3. Hangi sürüme dönüleceğini sor. Tarih ve saatle seçtir.
4. **Dönmeden önce şimdiki hâlin de kopyasını al** — geri almanın kendisi
   de bir kayıp olabilir. Yeni bir tarih klasörüne kopyala.
5. Seçilen sürümü Read ile oku, özgün yola Write ile yaz. İşletim
   sistemi komutu kullanma; Read ve Write her iki sistemde aynı çalışır.
6. Tek cümleyle bitir: "Üçüncü bölüm dün 14:30'daki hâline döndü.
   Diğer dosyalarınız olduğu gibi duruyor."

## Word dosyası için

Word dosyaları yerinde değişmediği için "geri alma" gerekmez:

- Özgün dosya zaten yerindedir. Hocaya yerini göster.
- Divit'in ürettiği `*-divit-*` dosyasını istemiyorsa `arsiv/` klasörüne
  taşımayı öner. **Silme.**

## Kurtaramadıkların — dürüst ol

- Hocanın Divit dışında, kendi eliyle değiştirdiği ya da sildiği dosyalar
  Divit'in önceki sürümlerinde yoktur. Bunu açıkça söyle.
- Windows'ta: Belgeler klasörü OneDrive ile eşitleniyorsa, OneDrive'ın
  "Sürüm geçmişi" özelliği dosyayı kurtarabilir. Dosyaya sağ tıklayıp
  **Sürüm geçmişi**'ni seçmesini söyle.
- Mac'te: Time Machine açıksa oradan dönülebilir.
- Hiçbiri yoksa: "Bu dosyanın önceki bir sürümü bende yok" de.
  Tahminle "kurtardım" deme.
