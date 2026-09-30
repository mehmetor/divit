# Sınama — yazar araçları: `ceviri`, `sekil`, `malzeme`

Tarih: 2026-10-01 · Mac · `claude -p`, model `claude-sonnet-5-5`

## Yöntem

- Klasör: `hoca-paketi/Divit` kopyası `/tmp/divit-yazar-sinama-{1,2,3}`;
  `kimlik.md` → `Kullanıcı türü: yazar` (örnek kişi), `uslup.md` kısa örnek;
  `CLAUDE.md` araç yerleri `~/.divit/araclar/…`.
- `.claude/settings.local.json` = klasörün `settings.json`'ı,
  `extraKnownMarketplaces` çıkarılmış; ek olarak yalnız sınama için
  `Read(//<worktree>/plugins/**)` (gerçek kurulumdaki `Read(~/.claude/plugins/**)`
  karşılığı) ve kurulum gerektiren iki öneri: `Edit(./sekiller/**)`,
  `Edit(./notlar/**)` (bu senaryolar yazar türünde, kullanılmadı).
- Çağrı:
  ```
  claude -p "<istem>" --output-format json --setting-sources local
    --no-session-persistence --permission-mode acceptEdits
    --plugin-dir <worktree>/plugins/divit --model claude-sonnet-5-5
  ```
- stderr üç koşuda da boş ("Ignoring" satırı yok).

Not: ilk iki denemede eklenti dosyaları okunamadı (`Read(/Users/…)` tek
eğik çizgiyle klasöre göreli sayılır; mutlak yol `//` ister). Üçüncü
denemede düzeldi; aşağıdaki sonuçlar üçüncü denemedir.

## Senaryo 1 — çeviri (terimler.md oluşur)

İstem: "Şu İngilizce paragrafı Türkçeye çevirir misin? Kitabım 'anilar'
için. Adı 'magaza-yonetimi' olsun. Kaynak: Divit sınaması için yazılmış
örnek metin, yazarı ve yayını yok, 2026." + sınama için yazılmış 4 cümlelik
İngilizce paragraf (perakende, stok devri).

Sonuç — **GEÇTİ**, 19 tur, izin reddi yok.
- `kitaplar/anilar/ceviri/magaza-yonetimi-ceviri-2026-10-01.md` + `.html`;
  başta künye (verildiği gibi), özgün dil, telif satırı.
- `.divit/profil/terimler.md` oluştu, 6 terim; kararsız olanda "seçim sizin".
- Kitap klasörü betikle açıldı (`asil/`, `malzeme/` var).
- Kapanışta telif hatırlatması tek cümle; günlük satırı yazıldı.

Çeviri:
> İyi bir mağaza müdürü, stok devrini müşterilerle yapılan bir sohbet olarak
> görür. Raflar yavaş boşalıyorsa, mağaza size ürün çeşidi hakkında bir şey
> söylüyordur. Pek çok perakendeci indirime gider; ama indirim yalnızca bir
> yamadır. Asıl çare alım planındadır. Tedarik zincirindeki paydaşlar
> (stakeholder) her hafta aynı satış gerçekleşme (sell-through) rakamlarını
> görmelidir; yoksa her bölüm kendi ölçütünün peşine düşer.

## Senaryo 2 — 5 değerli sütun grafik + Word'e gömme

İstem: "Kitabım 'anilar' için sütun grafik çiz. Başlık: Dükkânın yıllık
müşteri sayısı. Kaynak: dükkânın kendi kayıt defterleri. Veri: 2019 1.240;
2020 860; 2021 1.105; 2022 1.480; 2023 1.725. Word'e de koy."

Sonuç — **GEÇTİ**, 16 tur, izin reddi yok.
- `kitaplar/anilar/sekiller/musteri-sayisi-2019-2023.{svg,html,md}`,
  `cikti/musteri-sayisi-2019-2023-sekil-2026-10-01.docx`.
- Ölçek üst sınırı 2.000; sütun yükseklikleri elle denetlendi
  (1240/2000×290 = 179,8 … 1725 → 250,1), hepsi doğru. Değer etiketleri
  Türkçe binlik noktalı. Çizim: `yazar-araclari/musteri-sayisi-2019-2023.svg`.
- docx içinde `word/media/rId9.svg` ve `svgBlip` var: **pandoc 3.11 SVG'yi
  doğrudan gömüyor**, PNG yedeği yok (`rsvg-convert` bulunamadı uyarısı
  `--quiet` ile gizlendi). Word 2016 ve sonrası gerekir; SKILL.md'de iç not.
- Kaynak satırı şeklin altında.

## Senaryo 3 — el yazısı sayfa fotoğrafından metin

Görsel: `yazar-araclari/defter-sayfa.svg` (sınama için yazılmış kurmaca
not, el yazısı yazı tipi, bir kelimenin yerinde karalama), macOS
`qlmanage -t -s 900` ile PNG'ye çevrilip `kitaplar/anilar/malzeme/defter-sayfa-1.png`
olarak kondu (betiğin `koy` işinin yaptığı yer).

İstem: "kitaplar/anilar/malzeme içindeki defter-sayfa-1.png fotoğrafını
metne çevir. Bu benim kendi el yazım."

Sonuç — **GEÇTİ**, 15 tur, izin reddi yok.
- `kitaplar/anilar/notlar/malzeme-metin/defter-sayfa-1-metin-2026-10-01.md`;
  `malzeme/` içinde yalnız fotoğraf (yeni dosya yok).
- Başlık: `Kaynak türü: kendi el yazım`, künye "—", okunamayan yer 1, türe
  göre "Divit için" uyarı satırı.
- Metin birebir; karalama `Sonra [okunamadı] gelirdi.` — tahmin yok.
  (Önceki denemede `[çizim: dalgalı çizgi]` yazılmıştı; SKILL.md'ye
  "kelimenin yerindeki karalama çizim değildir" satırı eklendi.)

## İzin reddi

Üç senaryoda da izin reddi yok (`permission_denials: []`).

## Sınanmayanlar

- Windows (PowerShell pandoc komutu, HEIC tarifi).
- HEIC fotoğraf (Read'in açamadığı durum) — tarif metni yalnız yazılı.
- Akademisyen türünde `sekiller/` ve `notlar/malzeme-metin/` yazımı.
- Başka kitaptan alıntı türü ve künye sorusu (etkileşim gerektirir).
- Pasta, çizgi, akış şeması, zaman çizelgesi kalıpları.
