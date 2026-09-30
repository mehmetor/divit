# Sınama — belirsiz istek ve dosya düzeni (kurallar-duzen)

Tarih: 2026-10-01 · Model: `claude-sonnet-5-5` · Mac

## Kurulum

- Klasör: `hoca-paketi/Divit` kopyası, `/tmp/divit-kd-s1`, `-s2`, `-s3`.
- Profil: `Kullanıcı türü: akademisyen`, sınama adı, alan/üslup dolu.
- `yazilar/` altında üç dosya: `dilekce-izin.md` ("düzenlencek" yazım hatası),
  `ders-notu-bag.md`, `kongre-ozet.md` (her birinde yazım hatası).
- `.claude/settings.json` → `settings.local.json` kopyası; `settings.json`'dan
  `allow` çıkarıldı (stderr'de "Ignoring" satırı kalmasın diye). Yalnız sınama
  için `settings.local.json`'a eklenti yolu okuma izni eklendi:
  `Read(//<worktree>/plugins/**)`. Gerçek kurulumda eklenti
  `~/.claude/plugins/` altındadır ve mevcut `Read(~/.claude/plugins/**)` kuralı yeter.
- Komut (klasörün içinden):
  `claude -p "<istek>" --output-format json --setting-sources project,local --permission-mode acceptEdits --plugin-dir <worktree>/plugins/divit --plugin-dir <worktree>/plugins/divit-akademik --model claude-sonnet-5-5`
- stderr: iki koşuda da boş.

İlk denemede eklenti yolu izinde olmadığı için rol dosyası ve `dosya-duzeni.md`
okunamadı (3 `Read` reddi); bu sınama düzeneğinin eksiğiydi, yukarıdaki izinle
giderildi.

## Senaryo 1 — belirsiz istek: "şunu düzelt"

Beklenen: işe başlamadan "Anladığım: … Doğru mu?", tek soru, numaralı seçenek,
hiçbir dosya değişmez.

Çıktı (1. koşu):

```
Birden çok aday var (üç yazı dosyası), hangisi ve neyin düzeltileceği belli değil.

Anladığım: `yazilar/` altındaki bir dosyada bir şeyi düzeltmemi istiyorsunuz. Hangisi?
1) ders-notu-bag.md
2) kongre-ozet.md
3) dilekce-izin.md

Düzeltilecek yeri de kısaca yazarsanız (ör. "yazım hataları", "şu cümle") oradan başlarım.
```

`permission_denials`: izin reddi yok. Dosya değişmedi, günlüğe satır yazılmadı.

Başa gerekçe ve sona ikinci istek eklendiği için `istek.md`'ye "cevabın tamamı
bu soru olsun" maddesi eklendi. 2. koşu (`/tmp/divit-kd-s3`):

```
Klasörde üç yazı var ve hangisini kastettiğiniz belli değil.

Anladığım: `yazilar/` altındaki dosyalardan birini düzeltmemi istiyorsunuz. Hangisi?
1) ders-notu-bag.md
2) kongre-ozet.md
3) dilekce-izin.md
```

`permission_denials`: izin reddi yok. İkinci istek kalktı; baştaki tek satırlık
gerekçe Sonnet'te hâlâ var (sade Türkçe, teknik değil). **Sonuç: geçti**, küçük
üslup kusuru var.

## Senaryo 2 — açık istek, sorusuz başlama

İstek: "yazilar/dilekce-izin.md dosyasındaki yazım hatalarını düzelt, başka bir şeye dokunma"

Beklenen: soru yok, önceki sürüm kopyası, düzeltme, günlük satırı.

Çıktı:

```
Hocam, dilekçede tek yazım hatası vardı: "düzenlencek" yerine "düzenlenecek" yazdım. Başka hiçbir şeye dokunmadım.

Eski hâli `.divit/onceki-surumler/2026-10-01_0045/yazilar/dilekce-izin.md` altında duruyor.
```

- Yeni dosyalar: `.divit/onceki-surumler/2026-10-01_0045/yazilar/dilekce-izin.md`.
- `gunluk.md`: `2026-10-01 00:45 · yazım düzeltme · yazilar/dilekce-izin.md · "düzenlencek" düzeltildi, başka değişiklik yok.`
- Öteki iki dosyaya dokunulmadı; `.divit/ipuclari.md` oluşmadı (ipucu gerekmedi).
- `permission_denials`: izin reddi yok.

**Sonuç: geçti.**

## Senaryo 3 — bakım düzen denetimi

Klasöre konanlar: `.divit/gecici/tez-ay-2026-08-01.md` (61 gün), `tez-ay-2026-09-25.md`
(6 gün), `saglik.md` (tarihsiz); kullanıcının `yazilar/Benim Notlarım.md`'si;
günlükte Divit'in yazdığı geçen `cikti/rapor-son.md`.
İstek: "bakım yap, onaylıyorum başla; sonunda önerilerini göster, uygulamadan dur"

Çıktıdan (özet): 61 günlük ara dosya listelendi, "onaylarsanız klasörü açarım,
silmeye siz karar verirsiniz"; `saglik.md` "tarihi belli olmayan" diye ayrı;
6 günlük dosya "kalsın"; `cikti/rapor-son.md` kural dışı ad, "yeniden adlandırma
önermiyorum, bundan sonrakiler yeni düzende"; `yazilar/` altındaki kullanıcı
dosyası "dokunmadım, listeye de almadım". Hiçbir dosya değişmedi.
`permission_denials`: izin reddi yok. **Sonuç: geçti.**

Yan bulgu: bakım, `tez-kontrol/CLAUDE.md`'deki eski rapor yolunu
(`rapor/<bashar>-<tarih>.md`) yeni düzenle çelişkili buldu ve düzeltmeyi önerdi.
O dosya klasör şablonundadır, bu parçanın değil.

## Sınanmayanlar

- Parça mesajlar ve Shift + Enter ipucu: `claude -p` tek mesaj gönderir; masaüstü
  uygulamasında elle denenmeli.
- "Onu demedim" düzeltmesinin `sorunlar.md`'ye "yanlış anlama" diye yazılması:
  çok turlu konuşma gerekir.
- `bakim` düzen denetimi: 30 günden eski ara dosya için elle tarihli dosya
  konup denenmeli.
