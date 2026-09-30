# Ses kaydını yazıya dökme — araştırma

Tarih: 2026-10-01. İş: YAPILACAKLAR "ses kaydını yazıya dökme".

**Yöntem uyarısı.** Bu oturumda web arama/getirme aracı yoktu; aşağıdaki
bilgiler modelin bilgi kesimine (2026 ortası) dayanır ve **canlı kaynakla
doğrulanmadı**. `[DOĞRULA]` işaretli satırlar pilotta ya da bir tarayıcı
oturumunda denetlenmeli. Skill bu yüzden kesin menü adına bağlanmaz,
"bulamazsanız söyleyin" kapısı bırakır.

## Kısıt

- Claude Code'daki Read aracı ses dosyasını okuyamaz; Divit sesi kendisi
  yazıya dökemez.
- Hocanın makinesinde Python, Whisper, ffmpeg varsayılmaz (CLAUDE.md §1).
- Divit'in işi iki parçalı: (1) sistemdeki hazır aracı tarif etmek,
  (2) dökülmüş metni temizleyip klasöre koymak.

## Yollar

| Yol | Sistem | Türkçe | Not |
|---|---|---|---|
| Word → Dikte → **Transkribe et** (dosya yükle) | Word web (Microsoft 365); Windows masaüstü sürümünde de olabilir `[DOĞRULA]` | Dil listesinde Türkçe `[DOĞRULA]` | mp3, wav, m4a, mp4; aylık yükleme süresi sınırı (yaklaşık 300 dk) `[DOĞRULA]`. Konuşmacıları ayırır. Ses Microsoft bulutuna gider. M365 aboneliği gerekir. |
| Word → Dikte (canlı) | Windows ve Mac Word 365 | Var | Kaydı hoparlörden çalıp dinletmek mümkün ama kalitesiz; son çare. |
| Windows sesli yazma (Win+H) | Windows 10/11 | `[DOĞRULA]` | Canlı konuşma içindir. |
| Mac Notlar: ses kaydı + transkript | macOS 15 ve sonrası | İlk çıkışta yalnız İngilizce; Türkçe `[DOĞRULA]` | Hazır dosyayı yükleme sınırlı `[DOĞRULA]`. Cihaz üstü. |
| iPhone Sesli Notlar transkripti | iOS 18 ve sonrası | İlk çıkışta İngilizce; genişleme `[DOĞRULA]` | Cihaz üstü. |
| Mac/iPhone Dikte | Güncel sürümler | Var | Canlı konuşma içindir. |
| Google Kaydedici | Yalnız Pixel | `[DOĞRULA]` | Samsung Ses Kaydedici gibi diğerlerinde transkript modele göre değişir `[DOĞRULA]`. |
| Claude uygulaması (masaüstü/mobil) | — | — | Sesli giriş var; **ses dosyası eki kabul edilmiyor** `[DOĞRULA]`. |

## Gizlilik

- Görüşme, röportaj, ders kaydında konuşan herkes kişisel veri sahibidir
  (KVKK). Kayıt ve yazıya dökme **konuşanların onayıyla** yapılır.
- Word Transkribe sesi Microsoft sunucusuna gönderir; kurum hesabında
  kurum sözleşmesi geçerli. Apple'ın cihaz üstü yolları buluta göndermez
  `[DOĞRULA]`.
- Dökülmüş metin Divit'e verilince Claude'a (Anthropic) gider. Öğrenci
  görüşmesi, danışan kaydı gibi hassas metinde adlar baş harfe indirilir.

## Öneri

1. Word 365 varsa: **Word web → Dikte → Transkribe et → ses dosyası yükle**.
   En az adım, Türkçe, konuşmacı ayrımı. Birincil yol.
2. Yoksa ve kayıt iPhone/Mac'teyse: Sesli Notlar/Notlar transkripti
   (Türkçe açıksa).
3. İkisi de yoksa: telefonun kaydedicisi; o da yoksa açıkça "bu makinede
   ses yazıya dökülemiyor" denir. Python/Whisper kurdurulmaz.
4. Divit dökülmüş metni `ses` skill'iyle temizler: konuşmacı etiketi,
   `[anlaşılmadı]`, uydurma yok, isteğe bağlı iki sürüm.

## Kaynaklar

Canlı getirilmedi; pilotta açılıp tabloyla karşılaştırılmalı:

- Microsoft Destek — "Transcribe your recordings" (Word for the web).
- Microsoft Destek — "Dictate your documents in Word", desteklenen diller.
- Apple Destek — Notlar'da ses kaydı ve transkript (macOS 15+).
- Apple Destek — Sesli Notlar transkripti (iOS 18+).
- Google Pixel Yardım — Kaydedici, desteklenen diller.
- Anthropic Destek — Claude uygulamasında desteklenen dosya türleri.
- 6698 sayılı KVKK, md. 5 (açık rıza) ve md. 9 (yurt dışına aktarım).
