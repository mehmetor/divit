# Word'de değişiklik izleme ile öneri

Kullanıcı onayladığı önerileri kendi Word'ünde "Kabul Et / Reddet" ile
görmek isterse. Kullanıcıya Word'deki adıyla anlat: **"Değişiklikleri
İzle"** (Gözden Geçir sekmesi). "Track changes", "span", "pandoc" deme.

## Yasaklar

1. Asıl dosyaya (`asil/`) dokunma. Çıktı her zaman yeni dosyadır:
   `cikti/<kitap-adi>-divit-oneriler-<YYYY-AA-GG>.docx`.
   Aynı gün ikinci kez: sona `-s2`, `-s3`.
2. Yalnız "Durum: onaylandı" olan öneriler işlenir. Onaysız öneri
   izlenen değişiklik olarak da girmez.
3. Önerinin "Sonra"sını değiştirme; onaylanan neyse o.

## Önce söyle (tek cümle)

> "Yeni Word dosyası asıl dosyanızın sayfa düzenini, yazı tiplerini ve
> resimlerini tam taşımayabilir; yayınevinin ya da kurumunuzun Word
> şablonu varsa verin, onunla hazırlayayım."

Şablon verilirse betikle `koy <kitap-adi> malzeme "<şablon>"` ile yerleştir
ve dönüşümde `--reference-doc` ile kullan (komut SKILL.md'de).

## Akış

1. Çalışma kopyası: asıl Word'ü pandoc'un kendi biçimine çevir
   (`-t markdown`, gfm değil; gfm izleme işaretlerini taşımaz):
   `.divit/gecici/<ad>-izleme-<YYYY-AA-GG>.md`. Asıl dosyada zaten
   izlenen değişiklik varsa `--track-changes=all` ile oku ki kaybolmasın.
2. Her onaylı öneri için çalışma kopyasında "Önce" metnini Grep ile bul,
   Edit ile şu hâle getir (yalnız değişen kelimeler, bütün cümle değil):
   - Değiştirme: `[eski]{.deletion author="Divit" date="<YYYY-AA-GG>T00:00:00Z"}[yeni]{.insertion author="Divit" date="<YYYY-AA-GG>T00:00:00Z"}`
   - Silme: yalnız `.deletion` span'ı.
   - Ekleme: yalnız `.insertion` span'ı.
   "Önce" metni birden çok yerde geçiyorsa ya da bulunamıyorsa işleme;
   listede "bulunamadı" diye kullanıcıya söyle.
   Span içinde `[` `]` varsa `\[` `\]` yaz.
3. Word'e çevir (komut SKILL.md'de), sonra dosyayı aç.
4. Say ve söyle: "N öneri işlendi, M bulunamadı." Öneri dosyasındaki
   "Durum" sütununa `Word'e işlendi` yaz.

## Kullanıcıya anlatım

> "Yeni dosyada önerilerim renkli görünüyor. Word'de Gözden Geçir
> sekmesinde her birini Kabul Et ya da Reddet ile tek tek
> geçebilirsiniz. Asıl dosyanız olduğu gibi duruyor."

Değişiklikleri kendi Word'ünde toplu görmek isteyen için: Gözden Geçir
→ Değişiklikleri İzle → "Tüm İşaretlemeler".
