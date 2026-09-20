# İlk tasarımdan sapmalar

Başlangıç belgesi (claude.ai üzerinde yazılan "Proje Devir Belgesi")
dağıtım mimarisi açısından doğruydu ve büyük ölçüde korundu:
marketplace yapısı, `version` yazmama kararı, `${CLAUDE_PLUGIN_ROOT}`,
`permissions.deny`, `bin/` tuzağı, CLAUDE.md katmanları.

Aşağıdakiler bilinçli olarak değiştirildi. Gerekçeleri burada duruyor
ki sonradan geri alınmak istenirse neyin feda edileceği bilinsin.

| İlk tasarım | Şimdi | Gerekçe |
|---|---|---|
| Üç plugin (çekirdek/tez/kitap) | Tek plugin | Belgenin kendi §8'i "ikinci iş türünü iki hafta beklemeden ekleme" diyordu; §3 üçünü birden kuruyordu. Erken bölme isim uzayı borcu yaratır. |
| Ağırlık kitap yazımında | Ağırlık tez değerlendirme + yazışma | Kitap, hocanın zaman dağılımındaki en küçük ve otomasyona en kapalı kutu. Sinyal aylarca gelmez. |
| `hakemlik/` klasörü var | Yok, ayrıca izinle kapalı | Değerlendirilen makale üçüncü tarafın gizli fikrî mülkiyeti; COPE çizgisindeki yayıncılar açıkça yasaklıyor. |
| Atıf kuralı: `.bib` dışı künye yok | + iddiayı destekleyen birebir pasaj zorunlu | Asıl tehlike künye uydurma değil, gerçek kaynağı yanlış iddiaya bağlamak. Biçimsel her kontrolden geçer, hakem elinde patlar. |
| Yedekleme yok | Vault git reposu + oturum başı/sonu otomatik kayıt | Hocanın en büyük korkusu uydurma atıf değil, çalışmasını kaybetmek. Aynı mekanizma pilot ölçümünü de bedava veriyor. |
| `uslup.md` taslak üretiminde | Yalnız cilalama aşamasında | Kendi sesiyle gelen metni insan daha az denetler. Otomasyon yanlılığı, hata oranından daha belirleyici. |
| Hoca terminal görmüyor (varsayım) | `BASLA.command` ile çift tıklama | İlk belge "terminal bilmiyor" diyor ama ürünü CLI üzerine kuruyordu; boşluk kapatıldı. |
| İzin listesi yalnız `deny` | `allow` listesi de var | İzin yorgunluğu: 40. onaydan sonra hoca ya bırakır ya kör onay verir. Okuma ve kendi klasörlerine yazma ön izinli. |
| Word'e dönüş bir ölçüt | Bilinen sınır olarak açıkça söyleniyor | Ortak yazarlıkta tracked-changes döngüsü markdown'a temiz dönmüyor. Üçüncü haftada sürpriz olmasın diye `disa-aktar` bunu baştan söylüyor. |
| 2-3 hocayla pilot | Önce tek hoca, tek iş | Üç hocadan gelen üç farklı sinyal hangi kuralın tutmadığını göstermez. |

## Korunan ama izlenmesi gereken

- **`version` yazmama.** Aktif geliştirmede doğru; pilot üç kişiyi
  aştığında `stable` dalına geçilmeli (bkz. `PILOT.md` aşama 2).
  Bozuk bir commit şu an aynı anda herkesi düşürür.
- **Ad: Divit.** Konumlanma gerekçesi güçlü, korundu. Marka başvurusu
  pilot sonrasına; TÜRKPATENT sorgusu ücretsiz, şimdi yapılabilir.
