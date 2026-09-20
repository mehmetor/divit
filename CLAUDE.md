# Divit — geliştirme rehberi

Bu repo bir Claude Code **marketplace**'idir. Hocaların makinesinde
çalışacak eklentiyi barındırır. Burada çalışırken:

@belgeler/IHTIYAC-ANALIZI.md

## Tasarım kararları — sebepsiz değiştirme

1. **Tek plugin.** `divit-tez`, `divit-kitap` diye bölme. Hangi
   kuralların çakıştığı ilk hoca iki hafta kullanmadan görülmez;
   erken bölme yalnızca isim uzayı borcu yaratır.
2. **`version` yazılmaz** — ne `plugin.json`'da ne marketplace
   girdisinde. İkisine birden yazmak da yasak: `plugin.json` sessizce
   kazanır. Commit SHA'sı sürüm sayılır.
3. **Hocanın klasörü ile plugin ayrıdır.** Plugin merkezî ve push'la
   güncellenir; `~/Divit` kişiseldir ve asla üzerine yazılmaz.
   `kur.sh` var olan kuruluma dokunmayı reddeder.
4. **Koruma yazıyla değil izinle.** CLAUDE.md bağlamdır, zorunlu
   yapılandırma değil. `gelen/` ve `hakemlik/` kısıtları
   `settings.json` içindedir.
5. **Yedekleme sessizdir.** `.divit-vault` işaretçisi olan klasörde
   çalışır, başka hiçbir projeye dokunmaz.

6. **Alan bilgisi koda değil kılavuza.** `plugins/divit/alan/<alan>.md`
   dosyaları veridir; skill'ler onları okur. Yeni alan eklemek bir
   dosya yazmaktır, kod değiştirmek değil (`alan/ORNEK-SABLON.md`).
   Kılavuz hocanın kendi makalelerinden çıkarılır, hafızadan değil;
   kurulumda hocayla doğrulanır ve düzeltmeler repoya geri işlenir.

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
- Özel repo + arka plan güncelleme HTTPS'te kimlik doğrulayamaz.
  Repo public kalsın (hassas içerik yok).

## Doğrulama

```bash
claude plugin validate .
python3 -c "import json,glob;[json.load(open(f)) for f in glob.glob('**/*.json',recursive=True)]"
bash -n hoca-paketi/kur.sh plugins/divit/scripts/*.sh
```
