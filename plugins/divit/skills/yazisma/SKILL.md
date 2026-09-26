---
name: yazisma
description: Akademik ve idari yazışma taslağı üretir — dilekçe, kurul/dekanlık yazısı, referans mektubu, hakem cevap mektubu (response to reviewers), editöre kapak mektubu, öğrenciye geri bildirim e-postası. Hoca "şu yazıyı yazar mısın", "dilekçe", "hakemlere cevap", "referans mektubu", "editöre mektup" dediğinde kullan.
---

# Akademik ve idari yazışma

Hocanın en çok zamanını yiyen, en az bilişsel değer taşıyan iş bu.
Risk düşük, kazanç anında görünür — ürünün güven kazandığı yer burası.

## Ortak kurallar

- Hocanın unvanı, bölümü, üniversitesi `.claude/profil/kimlik.md`
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

**Editöre kapak mektubu**
Makalenin tek cümlelik katkısı → derginin kapsamına neden uyduğu →
etik beyanlar (çıkar çatışması, veri erişimi, AI kullanımı) → önerilen
hakemler varsa. Bir sayfayı geçme.

**Öğrenciye geri bildirim**
Önce ne işe yaradığı, sonra ne düzelmesi gerektiği, sonra somut sonraki
adım. Kişiye değil metne yönelik dil: "sen dağınık yazmışsın" değil,
"üçüncü bölümün iddiası ikinci bölümle çelişiyor".

## Çıktı

`yazilar/<tür>-<konu>-<tarih>.md` olarak kaydet. Hoca Word isterse
`disa-aktar` skill'ine geç.
