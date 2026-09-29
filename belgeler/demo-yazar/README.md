*KURGUSAL ÖRNEK — bu klasördeki bütün metinler Divit demosu için
yazıldı. Kişiler, şirketler, yayın yerleri ve olaylar uydurmadır; gerçek
biriyle benzerlik rastlantıdır.*

# Yazar demosu — örnek malzeme

Akademisyen olmayan bir kitap yazarına Divit'in iki kitap işini
göstermek için: emekli bir fabrika yöneticisinin kurgusal deneyim kitabı
ve dağınık yazıları. Metinlere bilerek hatalar kondu; beklenen sonuç
`beklenen-bulgular.md`'de, satır numarasıyla.

## Dosyalar

| Dosya | Demo | Ne |
|---|---|---|
| `asil/ornek-bolum.md` | `kitap-duzenle` | Kitaptan iki bölüm (4 ve 5), yaklaşık 1.150 kelime, 15 bilerek konmuş sorun. Her paragraf tek satır. |
| `asil/ornek-bolum.docx` | `kitap-duzenle` | Aynı metnin Word hâli (`pandoc asil/ornek-bolum.md -o asil/ornek-bolum.docx`). Demoda bu verilir: yazarın elindeki gerçek dosya Word'dür. |
| `malzeme/01-kose-toplanti.md` | `kitap-derle` | Köşe yazısı, gazetede yayımlanmış (2008). Tekrar eden anekdot, yıl çelişkisi. |
| `malzeme/02-kose-cirak.md` | `kitap-derle` | Köşe yazısı, gazetede yayımlanmış (2011), yazar gazetenin düzenli yazarı. |
| `malzeme/03-kose-dijital.md` | `kitap-derle` | Kendi sitesinde yazı (2016). Eskimiş bilgi. |
| `malzeme/04-konusma-dokumu.md` | `kitap-derle` | Konuşma dökümü, konuşma diliyle. Tekrar eden anekdot. |
| `malzeme/05-roportaj.md` | `kitap-derle` | Sektör dergisine röportaj (2019). |
| `malzeme/06-not-kriz.md` | `kitap-derle` | Tarihsiz kişisel not. |
| `beklenen-bulgular.md` | ikisi | Bilerek konan sorunlar, yerleri ve beklenen işaretler. |

## Demo klasöründe yerleşim

Demo klasörü repo **dışında** kurulur (kurma adımları:
`belgeler/YAZAR-GORUSMESI.md` → "Demo hazırlığı"). Dosyalar şöyle
yerleşir:

```
<demo klasörü>/
  .divit/profil/kimlik.md                     ilk başlığın altında: Kullanıcı türü: yazar
  kitaplar/sahada-yonetmek/asil/ornek-bolum.docx
  kitaplar/dinlemek-uzerine/malzeme/01-kose-toplanti.md … 06-not-kriz.md
```

`beklenen-bulgular.md` demo klasörüne **kopyalanmaz**; Divit cevabı
önceden görmemeli.

## Beklenen sonuç, kısaca

- **kitap-duzenle:** rapor önce yapıyı (söz verilen üç dersten birinin
  eksik olması, bağlanmayan fuar anekdotu, iki bölümde aynı anekdot),
  sonra anlatımı (dolgu, jargon, uzun cümle), tutarlılığı (1987/1989,
  1996 hesabı, şirket adı, formen/şef/ustabaşı), en son yazımı gösterir.
  `[GÜNCELLE]` iki yerde, `[DOĞRULA]` yıl ve Einstein sözü için; rakip
  şirket sahibi hakkındaki ima için "yayınevi ya da hukukçuyla konuşun".
- **kitap-derle:** altı satırlık envanter, dört `[İZİN]` (iki gazete
  yazısı, röportaj, konuşma kaydı), bir tekrar eden anekdot, bir
  `[GÜNCELLE]`, bir yıl çelişkisi; iki üç içindekiler kurgusu ve
  malzemesi olmayan bölümler.
