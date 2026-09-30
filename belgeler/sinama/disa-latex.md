# LaTeX / Overleaf dışa aktarma sınaması

Tarih: 2026-10-01 · Claude Code 2.1.286 · model `claude-sonnet-5-5`

**Sonuç:** İki senaryo da GEÇTİ. Doğrulanmamış atıfla paket hazırlanmadı,
soru soruldu; doğrulanmış atıfla `.tex` + `.bib` + resim tek zip'e girdi,
`.tex`'te `\citep`/`\citet` var. İzin reddi yok. **Derleme sınanmadı**
(bu Mac'te `tectonic`/`pdflatex` yok).

## Düzen

- Klasör: `/tmp/divit-latex-sinama`, `hoca-paketi/Divit` kopyası.
- `kimlik.md`: `Kullanıcı türü: akademisyen`.
- `yazilar/sulama.md`: iki atıf (`[@yilmaz2023, s. 44]`, `[-@kaya2021]`,
  `@kaya2021`, `[@yilmaz2023; @kaya2021]`), bir resim (`resimler/tarla.png`),
  sonda boş `# Kaynakça` başlığı.
- `kaynaklar/kaynaklar.bib`: iki giriş.
- `.claude/settings.local.json` = klasör ayarı + `Bash(zip *)`,
  `PowerShell(Compress-Archive *)` (**kurulum gerekir** — klasör ayarına
  henüz eklenmedi). `settings.json` kopyasından `allow` ve
  `extraKnownMarketplaces` çıkarıldı (güvenilmeyen klasörde allow yok
  sayılıyordu; stderr'de "Ignoring" satırı kalmadı).
- Komut (klasörde):
  `claude -p "yazilar/sulama.md makalemi Overleaf'e yükleyeceğim, hazırlar mısın? Derginin şablonu yok." --setting-sources project,local --permission-mode acceptEdits --plugin-dir <worktree>/plugins/divit --plugin-dir <worktree>/plugins/divit-akademik --add-dir <worktree>/plugins --model claude-sonnet-5-5`
  (`--add-dir`, gerçekte `Read(~/.claude/plugins/**)` izninin karşılığı;
  ilk denemede o olmadan `latex.md` okunamadı.)

## A — `kaynaklar/dogrulama.md` yok

Çıktı:

> Makaledeki iki atıf da `kaynaklar.bib`'de var. Ama `kaynaklar/dogrulama.md`
> yok, yani bu atıflar henüz doğrulanmamış. Paketi hazırlamadım.
>
> Bu metindeki 2 atıf (`yilmaz2023`, `kaya2021`) henüz doğrulanmadı.
> Overleaf'e göndermeden önce kontrol edeyim mi?

- `cikti/` boş kaldı. permission_denials: `[]` — izin reddi yok.

## B — iki atıf `dogrulama.md`'de ✅

Araç çağrıları: `divit:kurallar` → `divit:disa-aktar` → `latex.md` Read →
taslak, `dogrulama.md`, `.bib` Read → `.bib` Write → pandoc → Grep `\\cite` →
zip → `open` → günlük.

```
~/.divit/araclar/pandoc "yazilar/sulama.md" -t latex -s --natbib --bibliography kaynaklar.bib -M lang=tr --resource-path="yazilar" --lua-filter="<worktree>/plugins/divit/skills/disa-aktar/overleaf.lua" -o "cikti/sulama-overleaf-2026-10-01/sulama.tex"
zip -j -r "cikti/sulama-overleaf-2026-10-01.zip" "cikti/sulama-overleaf-2026-10-01"
```

Zip içeriği (hepsi en üst düzeyde):

```
kaynaklar.bib   tarla.png   sulama.tex
```

`sulama.tex`'ten:

```
\usepackage[bidi=basic,shorthands=off]{babel}      % Türkçe
\bibliographystyle{plainnat}
... verimi artırır \citep[s. 44]{yilmaz2023}. Kaya ve Demir \citeyearpar{kaya2021} ...
    \citet{kaya2021} su tasarrufunu da ölçer.
\pandocbounded{\includegraphics[keepaspectratio,alt={Deneme alanı}]{tarla.png}}
Bulgular önceki çalışmalarla uyumludur \citep{yilmaz2023, kaya2021}.
\bibliography{kaynaklar.bib}
```

Sondaki boş `# Kaynakça` başlığı filtreyle atıldı (LaTeX kendi başlığını basar).

Hocaya giden cevap:

> Overleaf dosyanız hazır: `/private/tmp/divit-latex-sinama/cikti/sulama-overleaf-2026-10-01.zip`
>
> Overleaf'te **New Project → Upload Project** ile bu zip'i seçin. Metin,
> kaynakça ve resim birlikte açılır. […] Bu bilgisayarda deneme derlemesi
> yapılmıyor. İlk derleme Overleaf'te olacak. […] Metni Overleaf'te
> düzenlerseniz Divit'teki `yazilar/sulama.md` ile ayrışır. Hangisi asıl olacak?

Günlük: `2026-10-01 00:00 · Overleaf paketi · yazilar/sulama.md · Şablonsuz standart biçimle zip hazırlandı (2 atıf önceden doğrulanmıştı).`

permission_denials: `[]` — izin reddi yok.

## Gözlem

- Model bir kez `ls -R` çalıştırdı (kurallar'daki kabuk kuralına aykırı,
  ama salt okunur olduğu için izin sorulmadı). `kurallar`'ın konusu.
- Windows yolu (`Compress-Archive`, `& "<pandoc>"`) sınanmadı.
- Derleme sınanmadı: `tectonic`/`pdflatex` yok. Türkçe `babel` ve `plainnat`
  ile Overleaf'teki pdfLaTeX'te derlenmesi beklenir; ilk hocada bakılmalı.
