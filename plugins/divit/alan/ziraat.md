# Alan kılavuzu — Ziraat / tarım bilimleri

Bu dosya `kurulum` sırasında hocanın `.divit/profil/alan.md`
dosyasına kopyalanır ve **hocayla birlikte** düzeltilir. Buradaki
her madde bir varsayımdır; hoca "biz öyle yapmıyoruz" derse
hocanın dediği geçerlidir.

## Terminoloji

- Tablolara **Çizelge** denir, "Tablo" değil. Şekiller "Şekil".
  Metinde "Çizelge 3'te görüldüğü gibi" biçiminde atıf yapılır.
- **Tekerrür** (replication), **parsel**, **deneme deseni**,
  **uygulama/konu** (treatment) yerleşik karşılıklardır. Bunları
  İngilizceden yeniden çevirme.
- Hangi karşılığı kullandığını hocanın metinlerinden öğren ve
  metin boyunca değiştirme.

## Birimler — en sık ve en sessiz hata kaynağı

Türkiye'de tarla verileri **dekar** üzerinden, uluslararası
yayınlarda **hektar** üzerinden verilir. Dönüşüm hatası çok yaygın
ve gözden kaçar.

- 1 dekar (da) = 1000 m² · 1 hektar (ha) = 10 da
- kg/da × 10 = kg/ha · ton/ha = kg/da ÷ 100

**Kontrol edilecekler:**
- Metin, çizelge ve özet aynı birimi mi kullanıyor?
- Bir değer hem kg/da hem kg/ha olarak geçiyorsa dönüşüm doğru mu?
- İngilizce özet (abstract) Türkçe özetle aynı sayıları mı veriyor?
  *Farklı çıkması sık görülür; mutlaka karşılaştır.*
- Gübre dozları saf besin maddesi mi (N, P₂O₅, K₂O) yoksa gübre
  miktarı mı? Hangisi olduğu yazılmış mı?
- Verim, bin tane ağırlığı (g), hektolitre ağırlığı (kg/hl),
  protein (%) — birimleri yazılmış mı?

Aritmetiği **hesapla ve doğrula**, göz kararı geçme.

## Latince adlar

- Tür adı italik: *Triticum aestivum* L. Cins büyük, tür küçük harf.
- Yazar kısaltması italik değil: L., Mill., DC.
- İlk geçişten sonra cins kısaltılır: *T. aestivum*. Metin boyunca
  tutarlı mı kontrol et.
- Çeşit adı italik değil, tırnak veya `cv.` ile: cv. Bezostaja 1.
- Zararlı ve hastalık etmenlerinde de aynı kural geçerli.

**Kontrol:** Aynı türün metinde hem açık hem kısaltılmış, hem italik
hem düz geçmesi çok sık. Hepsini tara.

## İstatistik — yorumlama değil, tutarlılık denetimi

**Divit istatistik analizi yapmaz, sonuç yorumlamaz.** Yaptığı,
metnin kendi içinde tutarlı olup olmadığını denetlemektir. Bu ayrım
korunur; aşılırsa hocanın güveni haklı olarak kırılır.

Kontrol edilecekler:
- **Deneme deseni yazılmış mı?** (tesadüf blokları, tesadüf parselleri,
  bölünmüş parseller, faktöriyel...) Tekerrür sayısı verilmiş mi?
- Kullanılan test adı yazılmış mı (LSD, Duncan, Tukey) ve **metin
  boyunca aynı test mi**? Yöntemde Duncan deyip çizelgede LSD yazmak
  sık görülür.
- Önem düzeyi (P<0.05 / P<0.01) tutarlı mı? Çizelge altındaki
  yıldız açıklaması (*, **) metinle uyuşuyor mu?
- **Harflendirme:** Çizelgede aynı harfi taşıyan gruplar için metinde
  "farklı bulunmuştur" denmiş mi? Bu doğrudan bir çelişkidir, en
  üste yaz.
- Çizelgedeki sayı ile metinde anılan sayı **birebir aynı mı**?
  Her birini tek tek karşılaştır.
- Ortalamalar ve CV (%) verilmiş mi? CV alan için makul aralıkta mı
  denmez — yalnızca verilip verilmediği kontrol edilir.
- "İki yıllık ortalama" kullanılmışsa yıl × uygulama interaksiyonu
  ele alınmış mı? Önemliyse ortalama vermek yanıltıcıdır — bunu
  *soru olarak* sor, hüküm verme.
- Lokasyon ve yıl sayısı, yöntemde ve bulgularda aynı mı?

## Yapı ve yayın

- Ziraat makalelerinde yaygın düzen: Giriş → Materyal ve Yöntem →
  Bulgular ve Tartışma → Sonuç. "Materyal ve Yöntem" başlığı
  yerleşiktir.
- Materyal bölümünde bulunması beklenenler: deneme yeri ve yılı,
  toprak analizi (pH, EC, organik madde, bünye), iklim verileri
  (sıcaklık, yağış — çok yıllık ortalamayla birlikte), kullanılan
  çeşit/materyal ve kaynağı, ekim-hasat tarihleri, parsel boyutu,
  ekim normu, gübreleme ve sulama programı.
  **Bunlardan eksik olan her biri tekrarlanabilirliği bozar** —
  `tez-kontrol` raporunda ayrı madde olarak yaz.
- İklim ve toprak verisinin kaynağı belirtilmiş mi (meteoroloji
  istasyonu, analiz laboratuvarı)?
- Türkçe ve İngilizce özet birbirinin çevirisi mi, sayılar tutuyor mu?
- Anahtar kelimeler iki dilde de var mı?

## Alt alan: bahçe bitkileri — sık görülen ölçümler ve tuzaklar

Hocanın alt alanına göre ilgili öbekleri tut, gerisini `alan.md`'den sil.

**Hasat sonrası / muhafaza**
- Ağırlık kaybı (%), sertlik (N veya kg-kuvvet — hangisi olduğu
  yazılmış mı), SÇKM (°Brix), titre edilebilir asitlik (hangi asit
  cinsinden: sitrik/malik), renk (L*, a*, b*, hue°, kroma).
- Muhafaza koşulları eksiksiz mi: sıcaklık (°C), bağıl nem (%),
  süre, ölçüm aralıkları. MAP/KA'da gaz bileşimi (% O₂, % CO₂).
- 1-MCP dozu birimi karışır: ppb, µL L⁻¹, nL L⁻¹. Metin boyunca tek
  birim mi, dönüşüm doğru mu?
- Vazo ömrü / raf ömrü: "ömrün bittiği" ölçüt tanımlanmış mı?

**Sulama**
- Kısıntılı sulamada seviyeler neye göre (% ETc, % tava kapasitesi,
  kap buharlaşması)? Tanım yöntemde var mı?
- Su kullanım etkinliği birimi: kg m⁻³ mü, kg da⁻¹ mm⁻¹ mi?
  Farklı çalışmalarla karşılaştırılıyorsa aynı birim mi?
- Uygulanan toplam su (mm veya m³ da⁻¹) ile verim birlikte verilmiş mi?

**Ağır metal / kalıntı**
- **Taze ağırlık mı kuru ağırlık mı?** mg kg⁻¹ değerinin hangisine
  göre olduğu yazılmamışsa mevzuat sınırıyla karşılaştırma anlamsız
  olur. En ciddi ve en sık kaçan tutarsızlık budur.
- Karşılaştırılan yasal sınırın kaynağı ve yılı (Türk Gıda Kodeksi,
  AB tüzüğü) verilmiş mi? Sınır değerini **uydurma** — `[DOĞRULA]`.
- Analiz yöntemi (ICP-OES, AAS), tespit limiti (LOD) verilmiş mi?

**Biyolojik mücadele / yaşam tablosu**
- Parametre adları ve birimleri tutarlı mı (r, λ, R₀, T; gün⁻¹).
- Sıcaklık, nem, fotoperiyot koşulları verilmiş mi?

**Doku kültürü / ıslah**
- Ortam bileşimi ve bitki büyüme düzenleyici dozları (mg L⁻¹),
  sterilizasyon, inkübasyon koşulları, başarı oranının paydası
  (kültüre alınan anter sayısı mı, embriyo mu?) açık mı?

**Aşılama**
- Anaç ve kalem adları çeşit adlandırma kuralına uygun mu, metin
  boyunca aynı yazılıyor mu?

## Türkçe → İngilizce çeviri tuzakları

Ziraat makaleleri çoğu zaman Türkçe yazılıp çevriliyor. Aşağıdakiler
çeviride sessizce anlam değiştirir; `yayin-oncesi` bunları arar.

| Türkçe | Yanlış çeviri | Doğrusu |
|---|---|---|
| yaş ağırlık | age weight | fresh weight (FW) |
| kuru ağırlık | – | dry weight (DW) |
| YA / KA (çizelgede) | çevrilmeden kalır | FW / DW |
| lekesiz fide | non-spotless | spotless / disease-free |
| suda çözünür kuru madde (SÇKM) | water-soluble dry matter | soluble solids content (SSC, °Brix) |
| titre edilebilir asitlik | titratable acid content | titratable acidity (TA) |
| tekerrür | repetition | replication |
| uygulama (deneme konusu) | application | treatment |
| deneme deseni | trial pattern | experimental design |
| tesadüf blokları | random blocks | randomized complete block design |
| çeşit | variety / species | cultivar (cv.) |
| ülkemiz | our country | Türkiye |
| dekar | decare | 0.1 ha — uluslararası metinde ha kullan |

Ayrıca: ondalık virgül (90,40) → nokta (90.40); "Anonim" → "Anonymous".

## Proje ve rapor işleri

Ziraat fakültelerinde makale dışı yazım yükü ağırdır. `yazisma`
skill'i bunları da kapsar:
- TÜBİTAK, TAGEM, BAP proje başvuruları ve gelişme/sonuç raporları
- AB ortaklı projeler (Horizon, ERA.NET, PRIMA): İngilizce ara
  raporlar, iş paketi (WP) ve çıktı (deliverable) takibi
- Çeşit tescil ve denemelerine ilişkin raporlar
- Çiftçi/sektör bilgilendirme metinleri, yaygın etki bölümleri

Bu metinlerde de kural aynı: **sayı, tarih, doz, bütçe kalemi
uydurulmaz.** Bilinmiyorsa `[DOĞRULA]`.

## Bu alanda Divit'in sınırı

Makalenin özü deneme sonucudur; metin işin belki üçte biridir.
Divit veri analizine girmez, sonuç yorumlamaz, çizelge üretmez.
Güçlü olduğu yerler: tez okuma, tutarlılık denetimi, birim ve
adlandırma kontrolü, yazışma, proje raporu yapısı, dışa aktarma.

Hocaya bunu baştan söyle. Yapamayacağı şeyi vaat etmek, yapabildiğini
de değersizleştirir.
