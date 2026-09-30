---
name: kitap-derle
description: Yıllar içinde yazılmış yazılardan, konuşma ve röportaj dökümlerinden, sunumlardan yeni bir kitap çıkarır — malzeme listesi, konu haritası, içindekiler seçenekleri ve bölüm iskeletleri; yayın hakkı sorularını işaretler. Kullanıcı "yazılarımdan kitap yapalım", "bu yazıları bir araya getir", "konuşmalarımı kitaba çevir", "yeni kitap", "kitap derle" dediğinde kullan.
allowed-tools: Bash(sh */scripts/kitap-klasoru.sh *), PowerShell(*kitap-klasoru.ps1*)
---

# Kitap derleme — dağınık yazılardan yeni kitap

**Önce:** `divit:kurallar` bu oturumda yüklenmediyse şimdi Skill aracıyla yükle; her komut oradaki kabuk kuralına ve araç yollarına uyar (`cat`, zincir, `cd` yok).

Divit malzemeyi sayar, gruplar, kurgu önerir ve iskeleti kurar. Kitabın
cümleleri kullanıcınındır; Divit onları sıraya koyar, eksiği gösterir.

## Yasaklar

1. **Yeni gövde metni uydurma.** Kullanıcının cümleleri korunur. Divit'in
   yazdığı her cümle (geçiş önerisi dahil) `[TASLAK]` ile başlar.
2. **`malzeme/` ve `asil/` içine yazma**; izin de kapalıdır. Tek istisna:
   kullanıcının dosyasını betik `koy` ile bir kez yerleştirir.
3. **Olgu uydurma.** Kaynaksız sayı, tarih, kişi, alıntı → `[DOĞRULA]`.
4. **Hukuki yorum yok.** Yayın hakkı yalnız soru olarak işaretlenir.
5. **Ses ya da video dosyasını okuyabildiğini varsayma.** Okuyamazsın.
   Söyle: "Ses kaydını okuyamıyorum; yazıya dökülmüş hâlini verirseniz
   onunla çalışırım." Sunum için PDF hâlini iste.
6. Satış ya da okur sayısı vaadi verme.

## Başlangıç

Tür satırını `.divit/profil/kimlik.md`'den oku; türe özgü ekler en sondadır.
`kitaplar/<kitap-adi>/` yoksa çalışma adı sor (sonra değişebilir), adı
küçük harf, Türkçe karaktersiz, tireli yaz, onay al. Klasörü `kurallar`'daki
"Kitap klasörü" betiğiyle aç; kendin klasör açma:
- Mac: `sh ${CLAUDE_PLUGIN_ROOT}/scripts/kitap-klasoru.sh ac <kitap-adi>`
- Windows: `powershell -NoProfile -ExecutionPolicy Bypass -File "${CLAUDE_PLUGIN_ROOT}/scripts/kitap-klasoru.ps1" ac <kitap-adi>`

Sonra söyle:

> "Kitaba girebilecek yazıları, konuşma ve röportaj dökümlerini,
> sunumların PDF hâlini bu pencereye sürükleyin. Ben bunları yalnız
> okurum, hiç değiştirmem."

Gelen her dosyayı aynı betikle `koy <kitap-adi> malzeme "<dosya>"` ile
yerleştir; HATA verirse `kurallar`'daki sıraya uy. Kullanıcı dosyaları
kendisi `malzeme/`'ye koyduysa doğrudan oku.

Word ve PDF okuma `kurallar`'daki yolla, metin `.divit/gecici/` altına.
`plan.md` en üst satırı her zaman:
`Durum: <adım> · <sıradaki iş> · <YYYY-AA-GG>`.

## Yedi adım — sırayla, her adım kullanıcıya gösterilerek

Tablo ve iskelet biçimleri: `${CLAUDE_PLUGIN_ROOT}/skills/kitap-derle/sablonlar.md` — Read ile yükle.

**1. Envanter** → `kitaplar/<kitap-adi>/envanter.md`. Her parça bir
satır: dosya, başlık, tarih, tür (köşe yazısı / konuşma / röportaj /
sunum / not), yaklaşık kelime, ana fikir (tek cümle), daha önce nerede
yayımlandı, `[İZİN]`. Tarih ya da yayın yeri bilinmiyorsa boş bırak ve
sor; tahmin etme. Toplam kelimeyi yaz (kitap için yetiyor mu, söyle).

**2. Konu haritası** (`plan.md`'ye): parçaları konulara kümele. Ayrıca:
aynı fikri ya da anekdotu anlatan parçalar, birbirini tutmayan bilgiler
(yıl, sayı, ad), eskimiş olanlar `[GÜNCELLE]`, hiçbir kümeye girmeyenler.
Zaman ifadelerini ("otuz yıla yakın", "on iki yıl sonra", "geçen yıl")
parçanın tarihiyle ve öteki parçalardaki tarihlerle hesapla. Tutmuyorsa
`[DOĞRULA]`: iki parçayı alıntıyla ve hesabı yaz; doğrusunu tahmin
etme. Yalnız eskimişse `[GÜNCELLE]`.

Numaralı sorularda seçenek metni sayıyla başlamaz; ad önce, sayı
parantezde: "1) Sahada (1. bölüm), önerim". Yoksa ekranda iç içe liste
gibi görünür.

**3. İddia ve okur.** Haritadan 2-3 aday çıkar, tek soru sor:

> "Bu kitap okura tek cümleyle ne söylüyor? 1) <aday> 2) <aday>
> 3) <aday> — numarayı yazın ya da kendi cümlenizi yazın."

Sonra okuru sor (numaralı seçenek: ör. 1) yeni yöneticiler 2) aynı
sektörde çalışanlar 3) genel okur). İkisi `plan.md`'ye.

**4. İçindekiler — 2-3 kurgu.** Kronolojik, konuya göre, ders ya da ilke
sırasıyla. Her kurguda her bölüm için: beslenen parçalar ve malzemesi
olmayan yer ("bu bölüm için sizin anlatmanız gerekir"). Kurguların güçlü
ve zayıf yanını birer cümleyle yaz; kullanıcı seçer. Seçilen `plan.md`'ye.

**5. Bölüm iskeletleri** → `taslak/<bolum-no>-<kisa-ad>.md`, yalnız
onaylı kurgu için. Önce sor: "Hangi bölümle başlayalım? 1) Sahada
(1. bölüm), önerim 2) <ad> (2. bölüm) — numarayı yazın." Parçalar kullanıcının cümleleriyle, sırayla; her
parçanın kaynağı başlık altında. Aralarda eksik geçiş
`[BAĞLANTI: <ne gerekiyor>]`. Aynı anekdot iki parçadaysa tek yerde
kalır; hangisi, kullanıcıya sor. Konuşma dilinden yazı diline geçiş
önerileri iskelete işlenmez; `duzenleme/oneriler-<bolum-no>.md`'de
"Önce → Sonra → Neden" olarak ayrı sunulur, onaylananlar sonra işlenir.
Var olan iskeleti değiştirmeden önce önceki sürüm kopyası al
(`.divit/onceki-surumler/<YYYY-AA-GG_SSDD>/<aynı yol>`).

**6. Yayın hakkı soruları.** Her `[İZİN]` parçası için ilgili soruyu sor,
cevabı envantere yaz. Soru sorulur, hüküm verilmez:

| Parça | Sorulacak |
|---|---|
| Gazete ya da dergide yayımlanmış yazı | "Bu yazıyı orada maaşlı çalışırken mi yazdınız? Sözleşmenizde yazıların haklarının devri var mı?" |
| Röportaj | "Soruları soran ve röportajı yayımlayan taraf kim? Metnin kitapta kullanılmasına izin vermesi gerekebilir." |
| Konuşma kaydı | "Kaydı kim yaptı, düzenleyici kurum mu? Dökümün kullanımı için izinleri var mı?" |
| Başkasının alıntısı, fotoğrafı, çizelgesi | "Bu parça kimin? Kitapta kullanmak için izin gerekebilir." |

Neden sorulur (kullanıcıya kanun yorumu olarak söyleme): 5846 sayılı
FSEK 18/2'ye göre, aksi sözleşmeden ya da işin mahiyetinden
anlaşılmadıkça çalışanın işini görürken meydana getirdiği eserde mali
hakları işveren kullanır; köşe yazıları bu kapsama girebilir.

Her `[İZİN]` için tek öneri:

> "Bunu yayınevi ya da bir hukukçuyla netleştirin. İzin yazısı
> gerekirse taslağını birlikte hazırlayabiliriz."

İzin yazısı istenirse `yazisma`.

**7. Uzun iş.** Her oturum sonunda `plan.md` durum satırı; sonraki
oturum oradan devam eder. Word çıktısı `disa-aktar` →
`cikti/<kitap-adi>-divit-<YYYY-AA-GG>.docx`; `[TASLAK]`, `[BAĞLANTI: …]`,
`[İZİN]` gibi işaretler kaldıysa önce listele, sor. Derlenen metin
sonra `kitap-duzenle` ile editör okumasından geçebilir.

## Kullanıcıya özet

Her adımın sonunda üç cümle: ne çıktı, en önemli karar, sıradaki soru.
Dosyayı `kurallar`'daki "Rapor gösterme" kuralıyla ver; tabloyu ekrana basma.

## Tür akademisyense

Kendi yayınlarından kitap aynı akışla; akademik kelimeler serbest.
Atıflar ve kaynakça korunur, silinmez; Word'den önce
`divit-akademik:kaynak-dogrula`. Tek bölümün argümanı üzerinde
çalışmak → `divit-akademik:bolum-yaz`. Başka yazarların bölümlerinden
oluşan editörlü kitap bu sürümde yok; istenirse açıkça söyle.
Tür yazarsa bu skill'leri anma; kelime kuralları `kurallar`'da.

## Bitirirken

`.divit/gunluk.md`'ye tek satır: `YYYY-AA-GG SS:DD · kitap-derle ·
<kitap-adi> · <adım ve tek cümle sonuç>`.
