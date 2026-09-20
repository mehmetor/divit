# Hoca ne istiyor? — İhtiyaç analizi

Mehmet profesör değil, hocaların ne istediğini varsayımla kuramaz.
Bu belge, varsayımları açık yazar ki pilotta yanlış çıktığında
düzeltilecek yer belli olsun. Her başlığın altında **doğrulama sorusu**
var — ilk hocayla yapılacak görüşmede bunlar sorulur.

## 0. Yöntem notu

Hocaya "AI'dan ne beklersiniz" diye sorma. Cevabı ya "her şeyi yazsın"
ya "hiçbir şeye güvenmem" olur; ikisi de kullanılamaz. Bunun yerine
**geçen haftayı** sordur: dün akşam bilgisayar başında ne yaptın, ne
kadar sürdü, hangisinde sıkıldın. `ihtiyac-gorusmesi` skill'i bu
formatta yazıldı.

## 1. Akademisyenin gerçek zaman dağılımı (varsayım)

Türkiye'de bir öğretim üyesinin haftalık yükü kabaca şöyle dağılıyor.
Yüzdeler tahmin; pilotta ölçülecek.

| İş | Pay | Bilişsel yük | Otomasyona uygunluk |
|---|---|---|---|
| Ders hazırlık / anlatım | %30 | Orta | Orta |
| İdari yazışma, kurul, form | %20 | Düşük | **Yüksek** |
| Öğrenci danışmanlığı, tez okuma | %15 | Yüksek | **Yüksek** |
| Kendi makalesini yazma | %15 | Çok yüksek | Düşük |
| Literatür takibi | %10 | Orta | **Yüksek** |
| Hakemlik | %5 | Yüksek | **Yasak** (bkz. §6) |
| Proje/bütçe (TÜBİTAK, BAP) | %5 | Orta | **Yüksek** |

**Çıkarım:** Belgedeki ilk tasarım "kitap yazma"ya odaklanmıştı; bu
listenin en küçük ve en az otomasyona uygun kutusu. Asıl kazanç
idari yazışma, tez okuma, literatür takibi ve proje başvurularında.
Ürünün ağırlığı buraya kaydırıldı.

> **Doğrulama sorusu:** "Geçen hafta bilgisayar başında en çok
> zamanını yiyen üç iş neydi?"

## 2. Alanlar arası fark — tek ürün herkese uymaz

Mehmet'in çevresinde farklı alanlardan hocalar var. Üç kaba küme:

**Sosyal bilimler / hukuk / ilahiyat / edebiyat**
Uzun metin, yoğun atıf, dipnot geleneği (APA değil, çoğu zaman
tam dipnot), arşiv/birincil kaynak. Veri analizi az. *Divit'in en
uygun olduğu küme — pilot buradan seçilmeli.*

**Fen / mühendislik / sağlık**
Kısa makale, LaTeX yaygın, şekil ve tablo ağırlıklı, veri analizi
(R/Python/SPSS) merkezde, çok yazarlı. Metin kısmı işin %30'u.
*Divit buraya yarım yarar sağlar; veri tarafına girmeden vaat verme.*

**Ziraat / tarım bilimleri** *(ilk pilotun alanı)*
Deneme temelli makale, Türkçe yayın geleneği güçlü, tez danışmanlığı
yükü ağır, TÜBİTAK/TAGEM/BAP proje ve rapor yükü büyük. Metin işin
üçte biri; gerisi deneme ve istatistik. Buna karşılık **mekanik
olarak doğrulanabilir** unsuru bol: birim dönüşümü (kg/da ↔ kg/ha),
Latince adlandırma, istatistik harflendirmesi, çizelge-metin
tutarlılığı. *Divit burada "yorumlayan" değil "denetleyen" olarak
konumlanır — güven kazanması en kolay kip budur.*
Alan kılavuzu: `plugins/divit/alan/ziraat.md`.

**Eğitim / işletme / iletişim**
Anket, ölçek, SPSS, orta uzunlukta makale, hızlı yayın baskısı.
İntihal ve AI-tespit kaygısı en yüksek küme. *En hassas kullanıcı.*

**Karar:** Çekirdek ürün alandan bağımsız (kaynak doğrulama, tez
raporu, idari yazışma, dışa aktarma). Alana özel olan her şey
`plugins/divit/alan/<alan>.md` kılavuzlarında durur ve kurulumda
hocanın `.claude/profil/alan.md` dosyasına kopyalanıp **hocayla
doğrulanır**. Koda gömülmez.

Bu, farklı alanlardan hocalara ölçeklenme mekanizmasıdır: her yeni
hoca bir kılavuz üretir, kılavuz repoya geri işlenir, aynı alandan
gelen bir sonraki hoca onu hazır bulur. Yeni alan eklemek kod
değişikliği değil, bir dosya yazmaktır (`alan/ORNEK-SABLON.md`).

> **Doğrulama sorusu:** "Son makaleni hangi programda yazdın? Word mü,
> LaTeX mi? Kaynakçayı nasıl tutuyorsun?"

## 3. Hocanın dile getirmediği ama belirleyici olan üç şey

**a) İtibar riski, verimlilikten önce gelir.**
Bir hoca zaman kazanmak için itibarını riske atmaz. Uydurma atıflı tek
bir makale, kazandırdığı 200 saati siler. Bu yüzden ürünün varsayılanı
"hızlı üret" değil, **"doğrulanabilir üret"** olmalı. Yavaşlığı kabul
edilebilir, yanlışlığı değil.

**b) Sahiplik duygusu.**
Hoca metnin kendi metni olduğunu hissetmezse kullanmaz — kullansa da
söylemez. Bu yüzden Divit tam metin üretmez; **yapı, itiraz, eksik
tespiti, dil denetimi** üretir. "Senin yerine yazan" değil, "seni
sıkıştıran" bir araç daha çok benimsenir ve etik olarak da temiz.

**c) Kayıp korkusu.**
En büyük korku uydurma atıf değil, üç haftalık yazının bozulması.
Her oturum otomatik yedeklenir, `/divit:geri-al` ile tek cümleyle
geri dönülür. Hoca git'i hiç görmez.

## 4. Sekiz somut iş — ürünün kapsamı

Öncelik sırasıyla. 1–4 pilotta var, 5–8 pilot sonrası.

1. **Tez/ödev değerlendirme raporu** — öğrenci dosyasına dokunmadan
   yapılandırılmış rapor. En ölçülebilir, en düşük riskli, en çok
   zaman kazandıran iş. *Pilotun amiral işi.*
2. **Kaynak doğrulama** — metindeki her atıfı yerel PDF'e ve birebir
   pasaja bağlar. Uydurma atıf ve yanlış atfetmeyi birlikte yakalar.
3. **İdari yazışma** — dilekçe, kurul yazısı, öneri mektubu, hakem
   cevap mektubu. Düşük risk, anında görünür kazanç, güven inşa eder.
4. **Dışa aktarma** — markdown → docx/pdf, dergi CSL'i ile.
   Word'e dönmeden iş bitsin diye.
5. Literatür notu çıkarma (yerel PDF yığınından)
6. Makale/bölüm taslak iskeleti (`bolum-yaz`)
7. Proje başvurusu (TÜBİTAK/BAP) yapı denetimi
8. Ders materyali / sınav sorusu üretimi

> **Doğrulama sorusu:** "Bu sekizin hangisini yarın kullanırdın?"

## 5. Kabul kriterleri — ürün ne zaman iyi sayılır

Beğeni sorulmaz, davranış ölçülür. Vault git reposu olduğu için
ilk üçü hocaya hiçbir şey sormadan diff'ten okunur.

| Ölçüt | Eşik |
|---|---|
| Kurulumu yardımsız tamamlama | 3 hocadan 3'ü |
| 2. haftada kendiliğinden açma | 3 hocadan 2'si |
| Üretilen rapordan hocanın sildiği oran | < %40 |
| Doğrulanamayan atıf | **0** (tolerans yok) |
| Word'e geri dönülen iş | Kayıt altına alınır, azalması beklenir |

## 6. Sınırlar — ürünün yapmayacağı şeyler

- **Hakemlik yok.** Değerlendirilen makale üçüncü tarafın gizli fikrî
  mülkiyeti; yayıncıların çoğu (COPE çizgisi) bunu açıkça yasaklıyor.
  Hocanın *kendi yazdığı* rapor metninin dil denetimi yapılabilir,
  makalenin kendisi okunmaz. Bu kural yazıyla değil izinle uygulanır.
- **İntihal kararı verilmez.** Üslup kopması işaretlenir, hüküm hocaya
  bırakılır. AI-tespit iddiası hiç üretilmez — bu araçlar güvenilmez
  ve öğrenciye haksızlık üretir.
- **Not/puan verilmez.** Rapor bulgu listesidir, karar hocanındır.
- **Veri analizi yapılmaz.** İstatistik yorumu ayrı bir uzmanlık;
  yanlış yapıldığında geri dönüşü yok.
- **Künye üretilmez.** `kaynaklar.bib` dışında atıf yok.

## 7. Etik ve mevzuat — çözülmeden yayılmaz

- **KVKK:** Yayınlanmamış tez ve öğrenci kimlik bilgileri API'ye
  gidiyor. Pilot yakın çevreyle sınırlıyken kabul edilebilir; 30 kişiye
  çıkmadan üniversitenin BT/etik birimiyle netleşmeli.
  `tez-kontrol` akışı öğrenci adını rapor dosya adında kısaltır.
- **Öğrenciye şeffaflık:** Varsayılan **açık beyandır**. Rapor
  şablonunun altında "bu rapor yapay zekâ destekli bir ön okumadan
  geçmiştir, nihai değerlendirme danışmana aittir" satırı hazır gelir.
  Hoca silebilir, ama sessizce yok sayamaz.
- **Dergi beyanı:** `disa-aktar` çıktısında AI kullanım beyanı taslağı
  üretir; hoca derginin politikasına göre düzenler.

## 8. Bilinçli olarak ertelenen kararlar

- Üniversite sistemleri (AVESİS/OBS/ÜBYS) entegrasyonu — API varlığı
  belirsiz, tarayıcı otomasyonu kırılgan. Pilot sonrası.
- Zotero zorunluluğu — kullanmayan hoca için `kaynaklar/` klasörüne
  PDF atma yolu da destekleniyor, `kaynak-dogrula` her ikisiyle çalışır.
- Çok yazarlı / tracked-changes akışı — Word döngüsü kırılıyor,
  bilinen sınır. Pilotta "ilk taslak tezgâhı" olarak konumlanıyor.
