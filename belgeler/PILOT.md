# Pilot planı

## İlke

Beğeni sorulmaz, davranış ölçülür. Divit her işi hocanın klasöründeki
`.divit/gunluk.md` dosyasına yazdığı için ölçümlerin çoğu hiçbir şey
sormadan, hiçbir metin dışarı çıkmadan günlükten okunur (hocanın izniyle).

## Aşama 1 — Tek hoca (2 hafta)

**Kim:** Ziraat / tarım bilimleri, branş CV ile netleşecek.
Hazırlık ve oturum akışı: `ILK-OTURUM.md`.

İlk planda sosyal bilimler önerilmişti; ziraat o gerekçenin
dışında kalıyor. Tez danışmanlığı yükü ağır, Türkçe yayın geleneği
güçlü, proje raporu yükü büyük — üçü de Divit'in güçlü olduğu
yerler. Ayrıca ziraat metinlerinde **mekanik olarak doğrulanabilir**
çok şey var (birim dönüşümü, Latince adlandırma, çizelge-metin
tutarlılığı); bunlar yorum değil denetim oldukları için hocanın
güvenmesi kolay.

**Bu alandaki risk:** makalenin özü deneme sonucu ve istatistiktir,
metin işin belki üçte biridir. `bolum-yaz` burada zayıf kalır.
Vaat dar tutulur: Divit analiz yapmaz, tutarlılık denetler.

**Tek iş:** `tez-kontrol`. Kitap yazımını pilotta açma; aylara
yayılır, sinyal gelmez.

Hocanın elinde okunmayı bekleyen öğrenci metni **yoksa** pilot işi
`yazisma`ya çevrilir (proje raporu / idari yazışma). Malzemesiz
`tez-kontrol` pilotu ölçüm vermez.

**Yapılacak:** İlk iki oturumda yanında otur ve izle. Not al, müdahale
etme. Bu iki oturum, buradaki bütün tasarım tartışmalarından daha
fazla şey öğretir.

### Ölçüt

| Ölçüt | Nasıl ölçülür | Eşik |
|---|---|---|
| Kurulumu yardımsız tamamlama | Gözlem | Evet |
| 2. haftada kendiliğinden açma | `gunluk.md` tarihleri | Evet |
| Rapordan silinen oran | Hocayla raporu birlikte okuma | < %40 |
| Doğrulanamayan atıf | `kaynaklar/dogrulama.md` | **0** |
| Word'e dönülen iş | Görüşme notu | Kayıt altına alınır |

Doğrulanamayan atıf toleransı yoktur. Bir tane çıkarsa aşama 2
başlamaz; sebebi bulunur ve mimariyle kapatılır.

## Aşama 2 — Üç hoca, farklı alanlar (4 hafta)

Aşama 1 eşikleri tutarsa. `yazisma` ve `kaynak-dogrula` açılır.
Her hocayla `gelistirici-ihtiyac-gorusmesi` yapılır; notlar birleştirilip
`IHTIYAC-ANALIZI.md` §2'deki alan varsayımları güncellenir.

**Bu aşamadan önce yapılacak teknik iş:**
- `stable` dalı kurulur, marketplace onu gösterir. Bozuk bir commit
  aynı anda herkesi düşürmesin.
- Yedekleme betiği 3 farklı makinede sınanır.

## Aşama 3 — Yaygınlaştırma öncesi kapı

30 kişiye çıkmadan önce **çözülmesi zorunlu** olanlar:

- **KVKK.** Yayınlanmamış tez ve öğrenci bilgisi API'ye gidiyor.
  Üniversitenin BT/etik birimiyle yazılı netleşme.
- **Öğrenciye şeffaflık.** Rapor şablonundaki beyan satırının
  fiilen kalıp kalmadığı ölçülür.
- **Bakım.** Tek kişilik bakım 30 kullanıcıda sürmez. Ya kapsam
  dondurulur ya ikinci bir bakımcı bulunur.
- **Maliyet.** Şimdilik konuşulmuyor; 30 kişide konuşulması zorunlu.

## Ertelenmiş kararlar

- Divit ↔ chimera-ai ilişkisi → pilot sonrası. Şimdilik Divit'e
  asıl ürünmüş gibi davran, ama marka başvurusuna para harcama.
- TÜRKPATENT sorgusu → ücretsiz, 15 dakika, pilotla paralel yapılabilir.
- AVESİS/OBS entegrasyonu → API varlığı doğrulanmadan planlanmaz.
- Çok yazarlı / tracked-changes akışı → bilinen sınır, pilotta
  "ilk taslak tezgâhı" olarak açıkça söyleniyor.
