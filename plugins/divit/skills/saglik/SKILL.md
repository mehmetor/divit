---
name: saglik
description: Divit'in bu bilgisayarda düzgün çalışıp çalışmadığını sessizce dener — Word okuma, dosya yazma, izinler, profil. Hoca "Divit çalışıyor mu", "bir sorun var", "Word'ü okuyamıyorsun", "kontrol et kendini" dediğinde, kurulumun sonunda ya da bir dosya işlemi beklenmedik biçimde başarısız olduğunda kullan.
---

# Sağlık denetimi

Amaç: bir sorun hocanın işinin ortasında değil, önceden görünsün.

## Yasaklar

- Hocanın dosyalarına dokunma. Denemeleri yalnızca `.divit/gecici/`
  içinde yap.
- Hiçbir şeyi silme. Deneme dosyaları `.divit/gecici/` altında kalır.
- Hocaya teknik ayrıntı gösterme. Sonuç tek paragraftır.
- İzin sorusu çıkaracak bir deneme yapma. Aşağıdaki komutlar klasörün
  izin listesindedir; başka komut ekleme.

## Denemeler — sırayla, sessizce

1. **Yazma:** `.divit/gecici/saglik.md` dosyasına bugünün tarihiyle
   `# deneme` yaz (Write), sonra oku (Read).
2. **Word:** pandoc ile bu dosyayı Word'e, sonra geri metne çevir:
   - Mac: `"$DIVIT_PANDOC" ".divit/gecici/saglik.md" -o ".divit/gecici/saglik.docx"`
     ve `"$DIVIT_PANDOC" ".divit/gecici/saglik.docx" -t gfm -o ".divit/gecici/saglik-geri.md"`
   - Windows: `& $env:DIVIT_PANDOC ".divit/gecici/saglik.md" -o ".divit/gecici/saglik.docx"`
     ve `& $env:DIVIT_PANDOC ".divit/gecici/saglik.docx" -t gfm -o ".divit/gecici/saglik-geri.md"`
   Geri gelen metinde "deneme" var mı, bak.
3. **Profil:** `.divit/profil/` dosyaları var mı, `kimlik.md` doldurulmuş mu.
4. **Klasörler:** `tez-kontrol/`, `yazilar/`, `kaynaklar/`, `cikti/` var mı.
   Eksik olanı `gorevler.md`'ye bakmadan oluşturma; yalnızca not et.
5. **Kural yükü:** klasördeki `CLAUDE.md` "divit:kurallar" satırını
   içeriyor mu.
6. **Hatırlatma durumu:** `.divit/hatirlatma.md`'de `son-bakim` 60
   günden eski mi.

## Sonuç

Her şey yolundaysa:
> "Kontrol ettim; her şey çalışıyor. Word dosyalarınızı okuyup
> yazabiliyorum."

Sorun varsa yalnızca hocayı ilgilendiren sonucu ve tek adımı söyle:

| Bulgu | Hocaya |
|---|---|
| pandoc çalışmıyor | "Word dosyalarını şu an okuyamıyorum. Kurulum komutunu bir kez daha çalıştırmak düzeltir; yardım gerekirse Mehmet Bey'e yazın. O zamana kadar PDF verebilirsiniz." |
| profil boş | `kurulum` skill'ine geç. |
| CLAUDE.md'de kural satırı yok | "Klasör ayarlarımdan biri eksik. Kurulum komutunu yeniden çalıştırmak düzeltir." |
| klasör eksik | "Şu klasör yok: … Açayım mı?" Onayla oluştur. |
| bakım gecikmiş | `bakim` skill'inin bakım önerisini yap. |

Her sorunu `.divit/sorunlar.md`'ye iş türü "sağlık denetimi" ile kaydet.
`gunluk.md`'ye tek satır: `… · sağlık denetimi · — · <sonuç>`.
