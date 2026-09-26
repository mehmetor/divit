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
   yazılmaz; Claude Code sürümü zip'in özetinden hesaplar. Yayın
   yalnızca `./yayinla.sh` ile yapılır (belirleyici zip, doğrulama).
5. **Hook yok.** Hook komutları Mac'te bash, Windows'ta PowerShell ile
   çalışır; ortak betik yazılamaz. Skill'ler iş için önce Read, Write,
   Edit, Glob, Grep araçlarını kullanır; kabuk yalnızca pandoc ve dosya
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
- `.claude/` korumalı yoldur; Divit'in yazacağı hiçbir şey orada durmaz.

## Doğrulama ve yayın

```bash
claude plugin validate plugins/divit     # eklenti
bash -n kur.sh                           # Mac kurulumu
./yayinla.sh                             # zip + marketplace.json + commit
./yayinla.sh --gonder                    # ayrıca GitHub'a gönder
```

Kurulumu sınamak (gerçek sistemi değiştirmeden):

```bash
HOME=/tmp/ev DIVIT_TEST=1 DIVIT_KAYNAK_ZIP=/tmp/repo.zip bash kur.sh
DIVIT_TEST=1 DIVIT_KAYNAK_ZIP=... DIVIT_HEDEF=... USERPROFILE=... pwsh -c "gc -Raw kur.ps1 | iex"
```
