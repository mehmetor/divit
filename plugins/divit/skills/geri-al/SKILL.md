---
name: geri-al
description: Bozulan veya istenmeyen bir değişikliği geri alır, bir dosyanın önceki hâlini getirir; istenirse ayrıntılı geçmiş tutar. Kullanıcı "geri al", "bozuldu", "eski hâline döndür", "az önce ne değişti", "kaybettim", "dünkü hâline dön", "geçmişe bak", "bu hâlini kaydet", "ayrıntılı geçmişi aç" dediğinde kullan.
allowed-tools: Bash(xcode-select -p), Bash(git --version), PowerShell(git --version), Bash(git -C . init), PowerShell(git -C . init), Bash(git -C * log *), PowerShell(git -C * log *), Bash(git -C * show *), PowerShell(git -C * show *), Bash(git -C * cat-file -s *), PowerShell(git -C * cat-file -s *), Bash(git -C * add -- *), PowerShell(git -C * add -- *), Bash(git -C * commit -m *), PowerShell(git -C * commit -m *), Bash(git -C * archive --format=zip -o *), PowerShell(git -C * archive --format=zip -o *)
---

# Geri alma

Hocanın en büyük korkusu çalışmasını kaybetmek. Divit bu korkuyu iki
kuralla karşılar (bkz. `CLAUDE.md` → Önceki sürüm kuralı):

1. Word ve PDF dosyaları hiç yerinde değiştirilmez. Divit her değişikliği
   yeni bir dosyaya yazar. Özgün dosya hep yerindedir.
2. Metin dosyaları değiştirilmeden önce `.divit/onceki-surumler/` altına
   kopyalanır.

Hocaya teknik kelime kullanma: "önceki sürüm", "özgün dosya" yeter.

**Ayrıntılı geçmiş (isteğe bağlı).** Önce `.git/HEAD`'i Read ile dene. Varsa,
ya da kullanıcı "kaydet", "geçmişe bak", "dünkü hâli", "ayrıntılı geçmiş"
diyorsa `${CLAUDE_PLUGIN_ROOT}/skills/geri-al/gecmis.md`'yi Read ile yükle ve
ona uy. Yoksa ve kullanıcı bunları demiyorsa ayrıntılı geçmişi anma.

## Akış

1. **Önce göster, sonra dokun.** Ne değiştiğini bul:
   - `.divit/onceki-surumler/` altındaki klasörleri Glob ile listele.
     Klasör adları tarih ve saattir (`2026-09-27_1430`).
   - Divit'in yazdığı yeni dosyaları bul: `*-divit-*` adlı dosyalar ve `cikti/` altındakiler.
   - Ayrıntılı geçmiş açıksa onun kayıtlarını da tarihle listele.
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
  Tahminle "kurtardım" deme. Sonra `gecmis.md`'deki "Kullanıcıya ne zaman
  önerilir" bölümüne bak (araç yoksa hiçbir şey önerme).
