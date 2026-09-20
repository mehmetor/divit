# Pilot planı

## İlke

Beğeni sorulmaz, davranış ölçülür. Hocanın klasörü git reposu olduğu
için ölçümlerin çoğu hiçbir şey sormadan, hiçbir metin dışarı
çıkmadan diff'ten okunur.

## Aşama 1 — Tek hoca (2 hafta)

**Kim:** Sosyal bilimler / hukuk / ilahiyat / edebiyat alanından,
tez danışmanlığı olan, Zotero kullanan (ya da kullanmaya istekli)
bir hoca. Fen/mühendislik pilotu ilk tur için seçme — orada işin
%70'i veri, Divit oraya girmiyor.

**Tek iş:** `tez-kontrol`. Kitap yazımını pilotta açma; aylara
yayılır, sinyal gelmez.

**Yapılacak:** İlk iki oturumda yanında otur ve izle. Not al, müdahale
etme. Bu iki oturum, buradaki bütün tasarım tartışmalarından daha
fazla şey öğretir.

### Ölçüt

| Ölçüt | Nasıl ölçülür | Eşik |
|---|---|---|
| Kurulumu yardımsız tamamlama | Gözlem | Evet |
| 2. haftada kendiliğinden açma | Commit tarihleri | Evet |
| Rapordan silinen oran | `git diff` | < %40 |
| Doğrulanamayan atıf | `kaynaklar/dogrulama.md` | **0** |
| Word'e dönülen iş | Görüşme notu | Kayıt altına alınır |

Doğrulanamayan atıf toleransı yoktur. Bir tane çıkarsa aşama 2
başlamaz; sebebi bulunur ve mimariyle kapatılır.

## Aşama 2 — Üç hoca, farklı alanlar (4 hafta)

Aşama 1 eşikleri tutarsa. `yazisma` ve `kaynak-dogrula` açılır.
Her hocayla `ihtiyac-gorusmesi` yapılır; notlar birleştirilip
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
