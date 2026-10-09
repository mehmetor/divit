---
name: yazisma
description: Yazışma taslağı hazırlar — dilekçe, mektup, yayınevine ya da kuruma yazı, izin yazısı. Akademik ve idari yazışmada kurul/dekanlık yazısı, referans mektubu, hakem cevap mektubu (response to reviewers), editöre kapak mektubu, öğrenciye geri bildirim e-postası da üretir. Kullanıcı "şu yazıyı yazar mısın", "dilekçe", "hakemlere cevap", "referans mektubu", "editöre mektup", "yayınevine yazı", "izin yazısı" dediğinde kullan.
---

# Akademik ve idari yazışma

**Önce:** `divit:kurallar` bu oturumda yüklenmediyse şimdi Skill aracıyla yükle; her komut oradaki kabuk kuralına ve araç yollarına uyar (`cat`, zincir, `cd` yok).

Hocanın en çok zamanını yiyen, en az bilişsel değer taşıyan iş bu.
Risk düşük, kazanç anında görünür — ürünün güven kazandığı yer burası.

Tür yazarsa (`kurallar`) iskeletler `${CLAUDE_PLUGIN_ROOT}/skills/kurallar/yazar.md`
→ "Yazışma" bölümündedir; aşağıdaki ortak kurallar yine geçerlidir.

## Ortak kurallar

- Hocanın unvanı, bölümü, üniversitesi `.divit/profil/kimlik.md`
  dosyasından alınır. Orada yoksa **sor**, uydurma.
- Tarih, sayı, yönetmelik maddesi, madde numarası **asla uydurulmaz**.
  Bilinmiyorsa `[DOĞRULA: ...]` yaz ve orada bırak.
- Resmî yazışmanın dili kurumun ve hocanın alışkanlığına uyar.
  Üniversite yazışmasında yerleşik kalıplar ("arz ederim", "gereğini
  bilgilerinize") beklenen biçimdir; kaldırma. Hocanın önceki bir
  yazısı varsa onu örnek al.
- Taslak her zaman **hocanın gözden geçirmesi için** üretilir; asla
  "gönderilmeye hazır" diye sunma.

## Tür bazında iskelet

**Dilekçe / kurul yazısı**
Muhatap → konu (tek cümle) → gerekçe (en çok üç paragraf) → talep
(açık ve tek) → ek listesi → imza bloğu. Gerekçede duygu yok, olgu var.

**Referans / öneri mektubu**
Tanışıklığın süresi ve bağlamı → öğrencinin *somut* bir işi ve o işteki
rolü → karşılaştırmalı değerlendirme → net tavsiye. Sıfat yığmaz,
örnek verir. Hocadan öğrenciye dair en az bir somut olay iste —
yoksa mektup içi boş çıkar ve bunu söyle.

**Hakem cevap mektubu (response to reviewers)**
Her hakem için: hakeme teşekkür (tek cümle, abartısız) → her madde
ayrı başlık → *hakemin sözü aynen alıntılanır* → yapılan değişiklik →
değişen metnin yeni yeri (sayfa/satır). Katılmadığın maddede saygılı
ama net gerekçe; "ekledik" deyip eklememek en büyük hatadır.
Kabul edilmeyen her öneri için gerekçe zorunlu.

Mektuptan önce **cevap tablosu** çıkar: hakem yorumlarını madde madde
ayır, `yazilar/<makale>/hakem-cevap-tablosu.md` olarak yaz:

| # | Hakem | Yorum (aynen) | Karar (kabul / kısmen / ret) | Ne değişti | Yeni metinde yeri |
|---|---|---|---|---|---|

"Karar" ve "Ne değişti" sütunlarını **hoca doldurur** ya da onaylar;
sen öneri yazarsın. Revize metin verilmişse "Yeni metinde yeri"
sütununu metinde arayarak doldur; bulamadığını `[DOĞRULA]` bırak.
"Ne değişti" dolu ama metinde karşılığı yoksa işaretle — bu, "ekledik
deyip eklememek" hatasını yakalar. Tablo onaylanınca mektubu tablodan yaz.

**Editöre kapak mektubu**
Makalenin tek cümlelik katkısı → derginin kapsamına neden uyduğu →
etik beyanlar (çıkar çatışması, veri erişimi, AI kullanımı) → önerilen
hakemler varsa. Bir sayfayı geçme.

**Öğrenciye geri bildirim**
Önce ne işe yaradığı, sonra ne düzelmesi gerektiği, sonra somut sonraki
adım. Kişiye değil metne yönelik dil: "sen dağınık yazmışsın" değil,
"üçüncü bölümün iddiası ikinci bölümle çelişiyor".

## Çıktı

1. Glob: `yazilar/<tür>-<konu>-<tarih>*`. 2. Ad boşsa `yazilar/<tür>-<konu>-<tarih>.md`,
doluysa sıradaki `-s2`, `-s3` ile kaydet ve hocaya "önceki taslak duruyor" de — eskisi hocanın
düzelttiği hâl olabilir, üstüne yazma. Hoca var olan taslağı düzeltmeni **açıkça** isterse
`kurallar`'daki önceki sürüm kuralıyla (kopya, sonra Edit) onu değiştir. Hoca Word isterse
`disa-aktar` skill'ine geç. E-postayla gidecekse (öğrenciye, editöre)
`eposta` skill'ine geç.
