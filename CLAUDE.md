# Divit — geliştirme rehberi

Bu repo bir Claude Code **marketplace**'idir. Hocaların makinesinde
çalışacak eklentiyi barındırır. Burada çalışırken:

@belgeler/IHTIYAC-ANALIZI.md

## Tasarım kararları — sebepsiz değiştirme

1. **Windows ve Mac eşit.** Türkiye'de hocaların çoğu Windows kullanır.
   Hiçbir özellik tek sisteme bağlı olamaz. Hocanın makinesinde git,
   Homebrew, Python ya da yönetici hakkı **varsayılmaz.**
2. **Hoca terminal görmez.** Divit, Claude masaüstü uygulamasının **Code**
   sekmesinde çalışır. Terminal yalnızca kurulum komutu için açılır.
3. **Kurulum tek komuttur** (`kur.ps1` / `kur.sh`, repo kökünde) ve yeniden
   çalıştırmak güvenlidir: hocanın dosyalarına ve profiline dokunmaz.
4. **Dağıtım git'siz.** Pazar yeri `url` kaynağıyla (raw marketplace.json),
   eklenti `archive` kaynağıyla (zip + sha256) iner. Sürüm numarası
   yazılmaz; Claude Code sürümü zip'in özetinden hesaplar. Zip'i yalnızca
   `./yayinla.sh` üretir (belirleyici zip, doğrulama).
5. **Hook yok.** Hook komutları Mac'te bash, Windows'ta PowerShell ile
   çalışır; ortak betik yazılamaz. Skill'ler iş için önce Read, Write,
   Edit, Glob, Grep araçlarını kullanır; kabuk yalnızca pandoc, pdfcpu ve dosya
   açmak için, iki sistemin komutu yan yana yazılarak.
6. **Yedek = önceki sürüm kuralı.** Word/PDF yerinde değiştirilmez; metin
   dosyası değiştirilmeden önce `.divit/onceki-surumler/` altına kopyalanır.
7. **Hoca profili `.divit/profil/` altındadır, `.claude/` altında değil.**
   Claude Code `.claude/` yazımlarını her zaman sorar (korumalı yol);
   izin kuralları bunu değiştirmez.
8. **Divit hocayı kendisi tanır.** Önceden hoca profili ya da alan
   kılavuzu hazırlanmaz. `kurulum` skill'i özgeçmişi ister, alanı çıkarır,
   makaleleri bulur, alan kurallarını yazar. `alan/` klasöründeki
   kılavuzlar yalnızca başlangıç noktasıdır.
9. **Koruma yazıyla değil izinle.** `gelen/` ve `hakemlik/` kısıtları
   `settings.json` deny kurallarındadır (`Edit(...)`; `Write(...)` eşleşmez).
10. **Tek plugin.** Erken bölme isim uzayı borcu yaratır.
11. **Kurallar eklentide, klasörde değil.** Hocanın klasöründeki
    `CLAUDE.md` kendiliğinden güncellenmez; eklenti güncellenir. Bu yüzden
    çalışma kuralları `skills/kurallar` içindedir ve klasördeki CLAUDE.md
    yalnızca "önce kuralları yükle" satırıyla güvenlik çekirdeğini taşır.
    Kural değişikliği → `kurallar` skill'i → `SURUM.md` → develop → yayın.
12. **Geri bildirim onaylı ve anonim.** Divit `.divit/gunluk.md` ve
    `.divit/sorunlar.md` tutar; `gelistirici-paylas` bunları öğrenci bilgisi
    çıkarılmış hâlde hocaya gösterir, açık onaydan sonra e-postayı hoca
    gönderir. Oturum dökümleri kullanılmaz.

13. **Sürüm notu hocanın dilinde.** Teknik sürüm zip özetidir; hocaya
    görünen sürüm `plugins/divit/SURUM.md` en üst başlığıdır. Eklentiyi
    değiştiren her iş, notunu en üstteki `## Sıradaki` başlığına yazar;
    yayında CI bunu sürüm ve tarihle değiştirir (`yayinla.sh` denetler). Klasör ayarı, kılavuz ya
    da araç değiştiyse başlığa `· kurulum gerekir` eklenir; `guncelleme`
    skill'i hocaya bunu önerip onayla kurulumu çalıştırır.
14. **Geliştiriciye dönük komutlar `gelistirici-` önekiyle.** Hocanın
    menüsünde ayrı dursun. İç kural skill'leri (`kurallar`)
    `user-invocable: false` ile menüden gizlenir.

## Skill yazarken

- Her SKILL.md 150 satırın altında kalsın.
- `description` alanı **ne zaman kullanılacağını** hocanın kendi
  kelimeleriyle yazsın; tetikleme buna bakar.
- Yasakları başa koy, akışı sonra.
- Hocaya gösterilecek her metin sade Türkçe — teknik terim yok.

## Bilinen tuzaklar

- Plugin kuruluma **kopyalanır**; kendi dizini dışına (`../ortak`)
  referans veremez.
- Üst düzeyde `bin/` dizini koyma; `scripts/` kullan,
  `${CLAUDE_PLUGIN_ROOT}/scripts/<ad>` ile referans ver.
- `CLAUDE.md`'yi `plugins/<ad>/` altına koyma — validate uyarısı verir.
- Repo public kalsın: hocalar git'siz, kimlik bilgisiz indirir.
- Skill'lerde eklenti yolu için yalnızca `${CLAUDE_PLUGIN_ROOT}` yaz: skill
  yüklenirken metne gömülür. `$env:CLAUDE_PLUGIN_ROOT` Windows oturumunda
  boş gelir (pilotta görüldü).
- `.claude/` korumalı yoldur; Divit'in yazacağı hiçbir şey orada durmaz.

## Dallar ve yayın

- **main = hocalara giden hâl.** Kurulum betikleri, klasör şablonu, site
  (Railway) ve marketplace.json main'den okunur. main'e elle commit ve
  push **yok.**
- **develop'ta çalış.** Commit mesajı conventional commits biçiminde,
  açıklaması Türkçe: `feat: sınav sorusu`, `fix: PDF okuma`, `docs: ...`,
  `chore: ...`. Sürümü release-please bunlardan çıkarır.
- Yeni işi Mehmet denemeden yayına alma.
- **Yayın:** develop'a push → release-please "divit X yayını" PR'ını açar
  (CHANGELOG.md geliştirici içindir; hocanın notu SURUM.md). PR birleşince
  `.github/workflows/yayin.yml` `./yayinla.sh --surum X` çalıştırır ve
  develop'u main'e taşır.

```bash
claude plugin validate plugins/divit     # eklenti
bash -n kur.sh                           # Mac kurulumu
./yayinla.sh                             # deneme: özet ve hocaya gidecek not
```

Kurulumu sınamak (gerçek sistemi değiştirmeden):

```bash
HOME=/tmp/ev DIVIT_TEST=1 DIVIT_KAYNAK_ZIP=/tmp/repo.zip bash kur.sh
DIVIT_TEST=1 DIVIT_KAYNAK_ZIP=... DIVIT_HEDEF=... USERPROFILE=... pwsh -c "gc -Raw kur.ps1 | iex"
```
