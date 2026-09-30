# Telefondan yükleme — araştırma

Soru: Kullanıcı (akademisyen ya da yazar) telefonda çektiği fotoğrafı
(el yazısı, kitap sayfası, tahta, form) Divit'in çalıştığı bilgisayardaki
klasöre, özellikle `kitaplar/<kitap>/malzeme/`ye nasıl ulaştırır?

Tarih: 2026-10-01 · Bu Mac'te Claude Code 2.1.286.

## Kısa cevap

**Evet, doğrudan yol var: Uzaktan Kontrol (Remote Control).** Claude
masaüstü uygulamasının Code sekmesinde açık bir oturum, telefondaki Claude
uygulamasının Code sekmesinden sürülebilir. Telefonda eklenen fotoğraf
bilgisayardaki oturuma ulaşır, Claude onu mesajın parçası olarak görür ve
bilgisayarda `~/.claude/uploads/` altına kaydeder. Divit bu dosyayı
`kitap-klasoru` betiğinin `koy` işiyle `malzeme/`ye yerleştirebilir
(ölçüldü, aşağıda).

Koşullar ve sınırlar:

- Bilgisayar açık, Claude uygulaması çalışır durumda olmalı.
- Oturum Uzaktan Kontrol'e bağlanmalı: Code sekmesinde `/remote-control`
  (kısaltması `/rc`) yazılır ya da **Ayarlar → Claude Code → Connect new
  sessions to Remote Control** bir kez açılır.
- Pro, Max, Team, Enterprise planları; Team/Enterprise'da kurum
  yöneticisinin açması gerekir. API anahtarıyla çalışmaz.
- Telefondan bu oturumda izin kipi olarak **Otomatik seçilemez**
  (yalnız Manuel, Düzenlemeleri kabul et, Plan).
- Fotoğraf dışı dosyalar (PDF vb.) belgeye göre gidiyor; Nisan 2026'da
  yalnız fotoğraf gönderilebiliyordu (issue #42156), Mayıs 2026'da
  Windows'ta fotoğrafın sessizce düştüğü bir hata bildirildi (#62031,
  kopya diye kapandı). **Pilotta hem Mac hem Windows'ta denenmeli.**

## Ne ölçüldü

1. `~/.claude/uploads/` gerçekten var ve oturum başına alt klasör tutuyor
   (bu Mac'te: `~/.claude/uploads/<oturum-kimliği>/327434a4-image.jpg`,
   yanında `…-geri-bildirim-….md`). Yani eklenen dosyalar
   `<kısa-kimlik>-<ad>` biçiminde duruyor; telefon fotoğrafı `…-image.jpg`
   adını alıyor. (Gözlem: `.md` eki muhtemelen masaüstünden eklenmişti;
   masaüstünde sürükle-bırak eklerinin de buraya düştüğü belgede yazmıyor,
   pilotta bakılmalı.)
2. `koy` işi klasör dışındaki mutlak yolu kabul ediyor:

   ```
   $ cd <geçici>/Divit      # içinde .divit/ var
   $ sh plugins/divit/scripts/kitap-klasoru.sh koy deneme-kitap malzeme "<geçici>/uploads/abc/327434a4-image.jpg"
   KOPYALANDI kitaplar/deneme-kitap/malzeme/327434a4-image.jpg
   cikis=0
   ```

   Klasör kurallarında `Bash(sh */scripts/kitap-klasoru.sh *)` ve
   `PowerShell(*kitap-klasoru.ps1*)` zaten izinli; `malzeme/`ye Divit'in
   doğrudan yazması yasak kalır, yalnız betik kopyalar.

## Doğrudan yol yoksa ya da tutmazsa: en kolay yollar

| Telefon → Bilgisayar | Nasıl | Not |
|---|---|---|
| iPhone → Mac | **AirDrop**: Fotoğraflar'da Paylaş → AirDrop → kendi Mac'i. Dosya İndirilenler'e düşer. | Kurulum yok, en hızlı yol. |
| iPhone → Mac | **iCloud Drive**: Dosyalar uygulamasında iCloud Drive'da bir "Divit malzeme" klasörü; Mac'te Finder'da aynı klasör görünür. | Kitabın `malzeme/` klasörü doğrudan iCloud'a taşınmamalı (bkz. risk). |
| Android/iPhone → Windows | **OneDrive**: telefondaki OneDrive uygulamasında "Kamera yükleme" açılır; fotoğraflar bilgisayardaki OneDrive klasöründe `Resimler/Film Rulosu` altında belirir. | Windows'ta Belgeler çoğu zaman zaten OneDrive'dadır. Kamera yüklemesi tek yönlüdür, telefondaki fotoğrafı silmez. |
| Android/iPhone → Windows/Mac | **Google Drive masaüstü**: bilgisayarda Google Drive uygulaması, Drive'daki bir klasör bilgisayarda klasör olarak görünür; telefondan o klasöre yüklenir. | Google hesabı olan hocalar için. |
| Android → Windows | **Telefon Bağlantısı (Phone Link)**: telefondaki son fotoğraflar bilgisayarda görünür, sürükleyip bırakılır. | iPhone'da desteği sınırlı (son birkaç görüntü). |
| Her telefon | Fotoğrafı **kendine e-posta** atıp bilgisayarda indirmek. | Yedek yol; herkes bilir. |

Bilgisayara indikten sonra ortak adım: kullanıcı fotoğrafı Code sekmesindeki
mesaj kutusuna **sürükler** ya da "İndirilenler'deki son fotoğrafı malzemeye
koy" der; Divit `koy` ile yerleştirir.

Eşitlenen klasörü doğrudan `malzeme/` yapmak (Divit klasörünü iCloud/OneDrive
içine koymak) önerilmez: eşitleme programı dosyayı yer tutucuya çevirebilir
("yalnız çevrimiçi"), Divit okuyamaz; ayrıca `.divit/` ve `.claude/`
klasörleri de buluta gider.

## Öneri

1. **Birinci yol Uzaktan Kontrol olsun**, ama pilotta iki sistemde de
   denenmeden kılavuza yazılmasın. Kullanıcıya tek sefer: "Ayarlar → Claude
   Code → Connect new sessions to Remote Control'u açın; sonra telefonda
   Claude uygulamasında Code'a dokunup bu oturumu seçin."
2. **İkinci yol sisteme göre:** Mac + iPhone → AirDrop; Windows → OneDrive
   kamera yüklemesi ya da Telefon Bağlantısı. Kılavuzda iki satır.
3. `malzeme` akışında (bugün `kurallar/yazar.md` ve `kitap-duzenle`)
   Divit, mesajda fotoğraf gördüğünde yolunu `~/.claude/uploads/` altında
   arar ve `koy` ile yerleştirir; yeni ad verme isteğe bağlı.
4. **Kod önerisi (bu parçada yapılmadı):**
   - Klasör `settings.json` allow'a `Read(~/.claude/uploads/**)` —
     yüklenen dosyayı `koy`'dan önce görmek için; yoksa her seferinde izin
     sorar.
   - `koy` işine isteğe bağlı yeni ad (`koy <kitap> malzeme <dosya> [yeni-ad]`)
     ki `327434a4-image.jpg` yerine `el-yazisi-01.jpg` gibi anlamlı ad
     kalsın. `.sh` ve `.ps1` birlikte.

### `malzeme` skill'ine eklenecek iki satırlık tarif (öneri)

> Telefondan fotoğraf: Claude uygulamasında Code sekmesinde bu oturumu açıp
> fotoğrafı ekleyin; ben malzemeye koyarım. Olmazsa fotoğrafı bilgisayara
> atın (iPhone'da AirDrop, Windows'ta OneDrive) ve buraya sürükleyin.

## Kalan riskler

- Windows'ta telefondan gelen fotoğrafın oturuma ulaşmaması (#62031 türü).
- Team/Enterprise'da Uzaktan Kontrol kurumca kapalı olabilir.
- `~/.claude/uploads/` yolunun Windows karşılığı (`%USERPROFILE%\.claude\uploads\`)
  belgede açık yazmıyor; pilotta bakılmalı.

## Kaynaklar

- Claude Code on mobile — ekler: https://code.claude.com/docs/en/mobile
- Remote Control — gereksinimler, masaüstünde `/remote-control`, sınırlar:
  https://code.claude.com/docs/en/remote-control
- Desktop — ek dosya ve sürükle-bırak, izin kipleri:
  https://code.claude.com/docs/en/desktop
- İzin kipleri — Uzaktan Kontrol'de seçilebilen kipler:
  https://code.claude.com/docs/en/permission-modes
- Issue #42156 (yalnız fotoğraf, Nisan 2026):
  https://github.com/anthropics/claude-code/issues/42156
- Issue #62031 (Windows'ta fotoğraf düşüyor, Mayıs 2026):
  https://claudeissues.com/issue/62031-claude-code-mobile-remote-control-silently-drops-image-attachments-received-on-p
- OneDrive kamera yükleme (iOS):
  https://support.microsoft.com/office/74d406bb-71d0-47c0-8ab8-98679fa1b72e
- Google Drive masaüstü: https://support.google.com/drive/answer/7329379
- Telefon Bağlantısı: https://en.wikipedia.org/wiki/Phone_Link
