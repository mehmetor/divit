# Kaynak doğrulama sınama seti — beklenen sonuç

`klasor/yazilar/makale.md` metni ve `klasor/kaynaklar/kaynaklar.bib` kaynakçası
bilerek konmuş **12 hata** ve **5 tuzak** (doğru kaynak) içerir. `calistir.sh`
skill'in yazdığı kanıt dosyasındaki özet tablodan her anahtarın `Sonuç`
sütununu ve alan sütunlarını okur, aşağıdaki tabloyla karşılaştırır.

Karşılaştırma kuralları:

- **Kaçırma** — hatalı bir anahtar `DOĞRULANDI` ya da tabloda yok → KALDI.
- **Yanlış teşhis** — hatalı anahtarın sonucu "Kabul" sütununda değil ya da
  "Şart" sütunundaki `Sütun=değer` tutmuyor (değer, özet tablodaki hücrenin
  başında aranır; birden çok şart `;` ile) → KALDI.
- **Fazla alan** — "Şart"ta olmayan bir alan (Yazar, Yıl, Cilt, Sayfa, Başlık,
  Dergi) `farklı` yazılmışsa UYARI (sonucu bozmaz, ama yanlış bilgi verir).
- **Yanlış alarm** — doğru anahtar `FARKLI`, `BULUNAMADI`, `GERİ ÇEKİLMİŞ` → KALDI.
  `ELLE BAK` yalnız "Kabul" sütununda yazıyorsa geçer, UYARI olarak sayılır.

Sonuç sözcükleri (skill'deki öncelik sırasıyla): `GERİ ÇEKİLMİŞ`,
`KAYNAKÇADA YOK`, `BULUNAMADI`, `FARKLI`, `ELLE BAK`, `METİNDE YOK`, `DOĞRULANDI`.

## Tablo (betik bu tabloyu okur; sütun sırasını bozma)

| Anahtar | Tür | Kabul | Şart | Açıklama |
|---|---|---|---|---|
| yildiz2019 | hata | BULUNAMADI, FARKLI | — | Uydurma DOI `10.1016/j.scienta.2019.108799`: Crossref, OpenAlex ve doi.org 404 (2026-10-01) |
| karaboga2021 | hata | BULUNAMADI, FARKLI, ELLE BAK | — | Var olmayan makale, DOI yok; başlık araması benzer ama farklı makaleler döndürür |
| ozturk2020 | hata | KAYNAKÇADA YOK | Kaynakçada=hayır | Metinde atıf var, kaynakçada yok |
| giovannoni2004 | hata | METİNDE YOK, ELLE BAK | Metinde=hayır | Kaynakçada var, metinde atıf yok (künyesi doğru) |
| watkins2006 | hata | FARKLI | Yıl=farklı | Yıl 2008 yazıldı; kayıt 2006 |
| munns2008 | hata | FARKLI | Cilt=farklı | Cilt 57 yazıldı; kayıt 59 |
| lee2005 | hata | FARKLI | Sayfa=farklı | Sayfa 1169–1178 yazıldı; kayıt 1269–1278 |
| kader2008 | hata | FARKLI | Yazar=farklı | Soyadı "Kadir" yazıldı; kayıt "Kader" |
| singleton1965 | hata | FARKLI | Başlık=farklı | "total phenolics" yerine "total flavonoids" |
| hodges1999 | hata | FARKLI | Dergi=farklı | Dergi "Plant Physiology" yazıldı; kayıt "Planta" |
| klee2012 | hata | FARKLI | Başlık=farklı; Yazar=farklı | DOI başka makalenin (domates genomu, konsorsiyum); başlık ve yazar tutmaz |
| seralini2012 | hata | GERİ ÇEKİLMİŞ | Geri çekme=geri çekilmiş | Crossref `updated-by[].type == retraction` (10.1016/j.fct.2013.11.047), OpenAlex `is_retracted: true`; künye alanları doğru |
| tilman2002 | tuzak | DOĞRULANDI | — | Doğru |
| foley2011 | tuzak | DOĞRULANDI | — | Doğru; 21 yazarlı, kaynakçada ilk 5 + "others" |
| thaipong2006 | tuzak | DOĞRULANDI | — | Doğru |
| cetinbas2011 | tuzak | DOĞRULANDI, ELLE BAK | — | Doğru; Crossref ve OpenAlex'te yazar alanı bozuk ("ÇETİNBAŞ Melike; KOYUNCU" tek yazar) — kayıt bozuk, künye değil |
| cetinbas2013 | tuzak | DOĞRULANDI, ELLE BAK | — | Doğru; DOI yok, Crossref'te yok, DergiPark sayfasında ve OpenAlex'te (DOI'siz) var |

## Kaynakların doğrulanması (sınama setini hazırlarken)

Her gerçek kayıt 2026-10-01'de API ile çekildi:

- `https://api.crossref.org/works?filter=doi:10.1016/j.fct.2012.08.005&select=DOI,title,updated-by`
  → başlık "RETRACTED: Long term toxicity …", `updated-by`: `{type: retraction,
  source: retraction-watch, DOI: 10.1016/j.fct.2013.11.047}` ve
  `{type: retraction, source: publisher}`.
- `https://api.openalex.org/works/doi:10.1016/j.fct.2012.08.005` → `is_retracted: true`.
- `https://api.crossref.org/works/10.1016/j.scienta.2019.108799` → 404;
  `https://api.openalex.org/works/doi:10.1016/j.scienta.2019.108799` → 404.
- `https://dergipark.org.tr/tr/pub/akdenizfderg/article/19372` → `citation_author`
  M. Çetinbaş, F. Koyuncu; cilt 26, sayı 2, s. 73–80, 2013; `citation_doi` yok.
  Crossref `query.bibliographic` (Türkçe ve İngilizce başlık) bu makaleyi döndürmez.
  DergiPark **arama** sayfası bot doğrulamasına yönlendirir; makale sayfası açılır.
- Diğer DOI'ler Crossref'te: künye alanları "Açıklama" sütunundaki farklar dışında
  kaynakçayla birebir aynı.
