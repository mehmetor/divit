# Sunum ve tablo — sınama

Tarih: 2026-10-01. Dal: `orc/yonetici-kitap-yazarlari-i/sunum-tablo`.
Skill'ler: `divit:sunum`, `divit:tablo` (çekirdek eklenti, iki rol).
Dayanak: `belgeler/arastirma/sunum-tablo.md` "Öneri".

## Yöntem

Geçici klasörler `/tmp/divit-sunum-sinama/{aka,aka2,yaz}` — `hoca-paketi/Divit`
kopyası; `CLAUDE.md`'de `__PANDOC__` → `~/.divit/araclar/pandoc`.
`.claude/settings.json` kaldırıldı, aynısı `settings.local.json` olarak kondu
(`extraKnownMarketplaces` çıkarıldı; stderr boş, `Ignoring` satırı yok). Ekler:

- `Read(/<worktree>/plugins/**)` — eklenti `--plugin-dir` ile worktree'den yüklendiği için.
- `Bash(open *)` allow'dan çıkarılıp deny'a kondu: sınama bu Mac'te Keynote/Numbers
  açmasın diye. Bu ret beklenendir.

Kimlik: `aka`, `aka2` → `Kullanıcı türü: akademisyen`; `yaz` → `Kullanıcı türü: yazar`.
Yeni izin eklenmedi; pandoc için `Bash(*pandoc*)` zaten var, `.csv` `Edit(./cikti/**)` altında.

```
ENABLE_CLAUDEAI_MCP_SERVERS=false claude -p "<istem>" \
  --setting-sources project,local --permission-mode acceptEdits \
  --plugin-dir <worktree>/plugins/divit [--plugin-dir <worktree>/plugins/divit-akademik] \
  --model claude-sonnet-5-5 --strict-mcp-config --mcp-config '{"mcpServers":{}}' \
  --output-format stream-json --verbose
```

## Sonuç

| # | Senaryo | Sonuç |
|---|---|---|
| 1 | Akademisyen, `.md` özetten sunum, şablonsuz | **GEÇTİ** (8 slayt) |
| 2 | Akademisyen, kurum şablonu kaydet + şablonla sunum | **GEÇTİ** (8 slayt, tema aynı) |
| 3 | Yazar, 4 satırlık tablo → `.csv` | **GEÇTİ** (EF BB BF, `;`, tırnaklama) |

## 1. Sunum, şablonsuz (akademisyen)

İstem: "yazilar/sulama-ozet.md dosyasından 10 dakikalık bir sunum hazırla,
PowerPoint olsun. İskeleti ayrıca sormana gerek yok, onaylıyorum; doğrudan dosyayı üret."

Araçlar: `Skill divit:kurallar` → `Skill divit:sunum` → Read akademisyen.md,
sulama-ozet.md → Glob → (find ×2) → `mkdir -p cikti` → Write
`cikti/damla-sulama-sunum-2026-10-01.md` → Bash
`~/.divit/araclar/pandoc "cikti/damla-sulama-sunum-2026-10-01.md" -o "cikti/damla-sulama-sunum-2026-10-01.pptx"`
→ `open` (reddedildi, beklenen) → Edit gunluk.md.

```
$ unzip -l cikti/damla-sulama-sunum-2026-10-01.pptx | grep "slides/slide[0-9]*.xml"
ppt/slides/slide1.xml … ppt/slides/slide8.xml     # başlık + 7 slayt
```

İzin reddi: `find … ( -name … -o -name … )` ve `open "cikti/…pptx"` (beklenen).

Bulunan pürüzler (skill'de düzeltildi, 2. koşu sonrası sürüm):
- Boş Glob sonucuna güvenmeyip `find` denedi → "boş sonuç yok demektir; başka
  komutla bakma, klasörü Write kendisi açar" satırı eklendi.
- Gereksiz `mkdir -p cikti` → aynı satır.
- Kaynakta yazan `8100,5`'e `[DOĞRULA]` koydu → "kaynaktaki sayıyı aynen al;
  `[DOĞRULA]` yalnız kaynakta olmayan bilgi için".

## 2. Kurum şablonu (akademisyen, düzeltilmiş skill)

Klasör köküne `kurum-sablonu.pptx` (pandoc'un varsayılan şablonu) kondu. İstem:
"Kurumumuzun sunum şablonu klasördeki kurum-sablonu.pptx. Bunu şablonum olarak
kaydet, sonra yazilar/sulama-ozet.md dosyasından 10 dakikalık PowerPoint sunumu
bu şablonla hazırla. İskeleti onaylıyorum, ayrıca sorma."

Araçlar: kurallar → sunum → Read ×3 → Glob `**/*.pptx` → find → Write
`.divit/gecici/bos-sunum-2026-10-01.md` → find → Bash
`~/.divit/araclar/pandoc ".divit/gecici/bos-sunum-2026-10-01.md" --reference-doc "kurum-sablonu.pptx" -o ".divit/profil/sunum-sablonu.pptx"`
→ Write `cikti/sulama-ozet-sunum-2026-10-01.md` → Bash pandoc … `--reference-doc ".divit/profil/sunum-sablonu.pptx"` …
→ `open` (reddedildi, beklenen) → Edit gunluk.md.

```
$ cmp <(unzip -p kurum-sablonu.pptx ppt/theme/theme1.xml) <(unzip -p .divit/profil/sunum-sablonu.pptx ppt/theme/theme1.xml)
tema-ayni
$ unzip -l .divit/profil/sunum-sablonu.pptx | grep -c "slides/slide"
0                                   # şablon kopyasında slayt yok, yalnız düzen ve tema
$ unzip -l cikti/sulama-ozet-sunum-2026-10-01.pptx | grep -c "slides/slide[0-9]*.xml"
8
```

İzin reddi: yalnız `open "cikti/sulama-ozet-sunum-2026-10-01.pptx"` (beklenen).
Not: `find` iki kez yine çalıştı (izinsiz geçti, Mac'te salt okuma). Windows'ta
karşılığı izin sorusu çıkarabilir; bkz. kalan riskler.

## 3. Tablo → CSV (yazar)

İstem (tablo sohbette): "Şu tabloyu Excel'e aktar, Excel'de açılır olsun. Ekranda
gösterdiğin hâli onaylıyorum, ayrıca sorma:" + 4 satır; içinde `650.0`, `8100,5`,
`7650.25`, `Çiğdem, Şule`, `İğdır; ölçüm`, `"ara" ölçüm`.

Araçlar: kurallar → tablo → Read yazar.md, dosya-duzeni.md → `ls cikti` → Write
`cikti/verim-karsilastirma-2026-10-01.csv` → Read (denetim) → `open` (reddedildi,
beklenen) → Edit gunluk.md.

```
$ xxd cikti/verim-karsilastirma-2026-10-01.csv | head -1
00000000: efbb bf59 c3b6 6e74 656d 3b53 7520 286d  ...Y..ntem;Su (m
$ cat cikti/verim-karsilastirma-2026-10-01.csv
﻿Yöntem;Su (m³/da);Verim (kg/da);Not
Karık;650;7200;"Çiğdem, Şule"
Damla;450;8100,5;"İğdır; ölçüm"
Yağmurlama;560;7650,25;"""ara"" ölçüm"
Kontrol;700;6900;-
```

- İlk baytlar `EF BB BF` (UTF-8 işareti), ayırıcı `;`.
- Ondalık virgül: `8100,5` korundu, `7650.25` → `7650,25`, `650.0` → `650`.
  Ondalık virgüllü sayı **tırnaksız** (tırnaklanırsa Excel metin sayar).
- `;` içeren hücre `"İğdır; ölçüm"` ve virgüllü metin `"Çiğdem, Şule"` tırnakta;
  içteki tırnak ikilendi: `"""ara"" ölçüm"`.
- Cevapta akademik kelime yok (yazar).

İzin reddi: yalnız `open "cikti/verim-karsilastirma-2026-10-01.csv"` (beklenen).

## Ölçülmeyenler

- Türkçe Windows Excel'de çift tıkla açılış (bu Mac'te Excel yok).
- Türkçe yerleşim adlı gerçek bir kurum şablonu.
- Gelen `.xlsx`/`.pptx` okuma skill üzerinden koşulmadı; pandoc komutu
  araştırmada ölçüldü (`belgeler/arastirma/sunum-tablo.md` §4).
