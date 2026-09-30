# Künye denetimi — ayrıntı

`SKILL.md` adım 2–4 bu dosyayı kullanır. Erişim yalnız **WebFetch** ile;
anahtar, hesap, kabuk yok. WebFetch isteminde her zaman şunu yaz:
"Dönen yanıttaki şu alanları hiç değiştirmeden, olduğu gibi yaz: …; bir alan
yoksa 'yok' yaz. Değerleri çevirme, özgün dilinde harfi harfine yaz. Özetleme,
düzeltme, tahmin etme." Dönen değeri hatırladığın
künyeyle **asla** tamamlama.

**Hata ve hız sınırı.** Crossref aynı anda gelen istekleri keser: WebFetch
çağrılarını **tek tek** yap, aynı mesajda birden çok Crossref sorgusu gönderme.
Yanıt "429", "Too Many Requests", 5xx ya da boşsa
bu okuma **okunamadı**dır, "kayıt yok" değildir. O girişi listenin sonuna
bırak, öbürlerinden sonra bir kez daha dene; yine olmazsa öteki kaynağı
(OpenAlex ↔ Crossref) ilk okuma say. Hiçbiri okunamazsa sonuç `ELLE BAK`,
notu "yayın kaydına ulaşılamadı".

## Sorgu adresleri (sırayla)

**1. Crossref, DOI ile** (DOI varsa önce bu):
`https://api.crossref.org/works?filter=doi:<DOI>&select=DOI,title,author,issued,published-print,published-online,volume,issue,page,container-title,short-container-title,updated-by,type`
İstenen alanlar: DOI, title, author (family ve given), issued, published-print,
published-online, volume, issue, page, container-title, updated-by (her birinin
type ve DOI'si). `total-results: 0` → Crossref'te yok.

**2. OpenAlex, DOI ile** (Crossref'te yoksa, ya da ikinci okuma için):
`https://api.openalex.org/works/doi:<DOI>?select=id,doi,title,publication_year,biblio,authorships,primary_location,is_retracted`
İstenen alanlar: title, publication_year, biblio (volume, issue, first_page,
last_page), authorships içindeki her `raw_author_name`, primary_location.source.display_name,
is_retracted. "404" / "not found" → OpenAlex'te yok.

**3. DOI yoksa ya da DOI hiçbir yerde yoksa — başlıkla arama:**
- Crossref: `https://api.crossref.org/works?query.bibliographic=<başlık>+<ilk yazar soyadı>+<yıl>&rows=5&select=DOI,title,author,issued,volume,page,container-title,updated-by`
- OpenAlex: `https://api.openalex.org/works?search=<başlığın ilk 8-10 kelimesi>&select=id,doi,title,publication_year,biblio,is_retracted&per-page=5`
  (bulduğun kaydın yazarları için `https://api.openalex.org/works/<W…>?select=title,authorships`).
- Başlık araması **eşleşme** sayılır yalnızca başlık aşağıdaki "Başlık"
  kuralına göre eşleşiyorsa. "Benzer" bir makale eşleşme değildir; o kaydı
  kanıt dosyasına "benzer, farklı makale" diye yaz, künyeyi ona göre karşılaştırma.

**4. DergiPark** (Türkçe dergi, Crossref'te yoksa):
- `.bib` girişinde `dergipark.org.tr/…/article/<numara>` adresi varsa önce
  yayın kaydını oku (künye sayfanın görünen metninde eksik kalabilir):
  `https://dergipark.org.tr/api/public/oai/?verb=GetRecord&metadataPrefix=oai_mods&identifier=oai:dergipark.org.tr:article/<numara>`
  İstenen alanlar: her `title` (iki dilde), her yazar (`namePart`), `dateIssued`,
  cilt ve sayı (`detail` içindeki `number`), sayfa (`start`, `end`), dergi adı,
  DOI. Kayıt boşsa makale sayfasını oku (`citation_…` alanları).
- DergiPark DOI'si (`10.xxxxx/…`) Crossref'te yoksa: `https://dergipark.org.tr/tr/doi/<DOI>`.
- DergiPark'ın arama sayfası bot doğrulamasına yönlenir (2026-10); **deneme**.
  Adres yoksa OpenAlex başlık araması DergiPark makalelerinin çoğunu bulur.

## Geri çekme ve düzeltme

- Crossref `updated-by` içinde `type` = `retraction`, `withdrawal` ya da
  `removal` → **geri çekilmiş**. `expression_of_concern` → **kuşku bildirimi**.
  `correction`, `erratum`, `corrigendum` → **düzeltme var** (sonucu tek başına
  değiştirmez, raporda söylenir).
- `updated-by` içindeki DOI **bildirimin kendisidir** (geri çekme notu), yeni
  bir yayın değildir; "yeniden yayımlanmış" deme. Tarih olarak bildirimin
  `updated` tarihini ver.
- Başlık "RETRACTED:" / "WITHDRAWN:" ile başlıyorsa → geri çekilmiş.
- OpenAlex `is_retracted: true` → geri çekilmiş.
- Crossref'te bulunan her kayıtta, geri çekme yoksa bile, OpenAlex
  `is_retracted`'ı ikinci okumada ayrıca sor.

## Alan alan karşılaştırma

Her alan için tek değer yaz: `eşleşti`, `farklı`, `belirsiz`, `bulunamadı`
(kayıtta alan yok), `—` (hiç kayıt yok). **Benzerlik yetmez; eşitlik aranır.**

- **Yazar** — `.bib`'deki her soyadı, aynı sırayla kayıtta olmalı ("others",
  "vd." kısaltmaya izin verir). Bileşik soyadında (Hawkins Byrne, de Vendômois,
  Cisneros-Zevallos) kayıt adı öbür parçayı ön ad ya da baş harf olarak
  taşıyorsa ("David H. Byrne") eşleşti; yalnız son parça bile tutmuyorsa farklı. Büyük/küçük harf ve şapka/çengel (ç-c, ş-s,
  ı-i, é-e) fark sayılmaz; **bir harf farkı fark sayılır** (Kader ≠ Kadir).
- **Yıl** — `.bib` yılı = `issued` yılı. Tutmazsa `published-print` ya da
  `published-online` yılına bak; biri tutarsa eşleşti (not düş).
- **Cilt** — birebir aynı.
- **Sayfa** — ilk ve son sayfa birebir aynı (`--` ile `-` aynı). Kayıtta yalnız
  ilk sayfa ya da makale numarası varsa onu karşılaştır.
- **Başlık** — büyük/küçük harf, noktalama, tırnak, sondaki nokta ve
  "RETRACTED:" öneki atıldıktan sonra kelime kelime aynı olmalı. Tek kelime
  farkı (phenolics → flavonoids) `farklı`dır. Kayıtta başlığın öteki dildeki
  hâli varsa onunla da karşılaştır.
- **Dergi** — büyük/küçük harf, "The", "&"/"and" atılır; kısa ad
  (`short-container-title`) da kabul. Biri ötekini içeriyorsa (The Plant Cell /
  The Plant Cell Online) eşleşti. OpenAlex'in `source` adı bir platformsa
(DergiPark, Zenodo, SSRN, ResearchGate) dergi adı değildir: dergi `bulunamadı`,
uyuşmazlık değil. Türkçe dergi adı kayıtta İngilizce geldiyse
  DergiPark sayfasının öteki dildeki hâlini oku (`/tr/pub/…` ↔ `/en/pub/…`);
  iki addan biri tutuyorsa eşleşti. Eski ad olabilecekse `belirsiz`.

**Her alan bağımsızdır.** Bir alanın farklı çıkması öbür alanı etkilemez
(dergi yanlış ama cilt kayıtla aynıysa cilt `eşleşti`). Tablodaki hücre,
ayrıntıdaki karşılaştırma satırıyla aynı olmalı. "RETRACTED:" öneki başlık
farkı değildir; başlık `eşleşti`, geri çekme sütunu `geri çekilmiş`.

**Kayıt bozuk olabilir.** Türkçe dergilerin kayıtlarında yazar alanı sık
bozuktur (iki yazar tek alanda, ad ve soyadı yer değiştirmiş). Değer açıkça
okunamıyorsa `farklı` deme: ikinci kaynağa (OpenAlex, DergiPark) bak. İkinci
kaynak temiz ve eşleşiyorsa `eşleşti` (kanıta "Crossref kaydı bozuk" yaz);
değilse `belirsiz`. **`farklı` ancak kayıttaki değer açıkça okunuyor ve
`.bib`'den ayrılıyorsa yazılır.**

DOI bir kayda gidiyor ama başlık ve yazar birlikte tutmuyorsa: `farklı`, notuna
"DOI başka bir makaleye ait görünüyor" yaz.

## Sonuç (öncelik sırası; ilk uyan yazılır)

1. `GERİ ÇEKİLMİŞ` — geri çekilmiş.
2. `KAYNAKÇADA YOK` — metinde atıf var, `.bib`'de giriş yok.
3. `BULUNAMADI` — DOI hiçbir yerde yok ve başlık araması eşleşme vermedi.
4. `FARKLI` — en az bir alan `farklı`.
5. `ELLE BAK` — en az bir alan `belirsiz`, ya da ikinci okuma ayrıştı, ya da
   kuşku bildirimi var.
6. `METİNDE YOK` — `.bib`'de var, metinde atıf yok (künye temiz).
7. `DOĞRULANDI` — kayıt bulundu, bütün alanlar eşleşti, ikinci okuma aynı.

## Kanıt dosyası

`.divit/dogrulama/<YYYY-AA-GG>-<metin dosyasının adı>.md`. Aynı gün ikinci kez
yazılacaksa sonuna `-2`, `-3` ekle. Biçim (tablo başlığını değiştirme):

```markdown
# Kaynak doğrulama kanıtı — <metin> · <tarih>

Metin: <yol> · Kaynakça: <yol>

## Eşleştirme
- `anahtar` — metinde: evet (satır 12, 30) · kaynakçada: evet
  (atıf ve kaynakça girişlerinin tamamı, tek tek)

## Özet
| Anahtar | Metinde | Kaynakçada | Kayıt | Yazar | Yıl | Cilt | Sayfa | Başlık | Dergi | Geri çekme | İkinci okuma | Sonuç |
|---|---|---|---|---|---|---|---|---|---|---|---|---|

## Ayrıntı
### anahtar
- Sorgu: <tam adres — kısaltma, "…" yok; tıklanınca aynı yanıt gelmeli>
- Dönen: başlık "…"; yazarlar …; yıl …; cilt …; sayfa …; dergi …; updated-by …
- Karşılaştırma: Yıl — kaynakça 2008, kayıt 2006 → farklı
- İkinci okuma: <tam adres> → aynı / ayrıştı (hangi alan)
```

`Kayıt` sütunu: Crossref, OpenAlex, DergiPark ya da `yok`. `Geri çekme`:
`yok`, `geri çekilmiş`, `kuşku bildirimi`, `düzeltme var`. `İkinci okuma`:
`aynı`, `ayrıştı`, `—`.

## İkinci bağımsız okuma

İlk tablo bitince `DOĞRULANDI` ve `METİNDE YOK` olan her giriş için **Agent**
aracıyla bir alt görev başlat. Alt göreve **yalnız** `.bib` girişlerini ver
(anahtar ve alanlar); ilk okumanın sonucunu verme. İstem:

> Bu kaynakça girişlerinin her birini WebFetch ile yayın kaydında denetle.
> Her giriş için ilk okumada kullanılmamış kaynağı kullan: <anahtar → adres
> listesi>. Adresin döndürdüğü başlık, yazar soyadları, yıl, cilt, sayfa,
> dergi ve geri çekme bilgisini özgün dilinde, çevirmeden aynen yaz (yazarlardan yalnız ilk <n>
> tanesini; n = kaynakçadaki yazar sayısı); sonra her alan için eşleşti /
> farklı / belirsiz / okunamadı de. 429 ya da boş yanıtta aynı adresi bir kez
> daha dene. Hafızandan hiçbir değer ekleme. Dosya yazma.

İlk okuma Crossref'se ikinci OpenAlex; ilk okuma OpenAlex ya da DergiPark'sa
ikinci öteki ya da Crossref başlık araması. Alt görevin herhangi bir alan
değeri ilk okumayla, yukarıdaki "Alan alan karşılaştırma" kurallarına göre
(bileşik soyadı, dergi kısa adı, platform adı dahil) **uyuşmazsa** sonuç `ELLE BAK` olur. İkinci okumada
**okunamayan** alan uyuşmazlık değildir: ilk yazar, yıl, cilt, sayfa ve başlık
ikinci okumada okunup tuttuysa `DOĞRULANDI` kalır, kanıta "ikinci okumada
okunamadı: <alan>" yazılır; bu beş alandan biri okunamadıysa `ELLE BAK`. Agent aracı yoksa aynı
sorguyu kendin, ilk okumaya bakmadan, öteki kaynaktan yap.
