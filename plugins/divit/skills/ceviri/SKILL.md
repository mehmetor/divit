---
name: ceviri
description: Yabancı dildeki bir metni, bölümü ya da alıntıyı kullanıcının üslubuyla Türkçeye çevirir; terimleri bir listede tutar ki kitap boyunca aynı kalsın. Kullanıcı "şunu Türkçeye çevir", "bu bölümü çevirir misin", "İngilizce metni çevir", "yabancı kitaptan aldığım kısmı çevir", "bu paragrafı Türkçeleştir" dediğinde ya da çevrilecek bir metni yapıştırdığında kullan. Var olan bir çeviriyi denetlemek için değil.
allowed-tools: Bash(sh */scripts/kitap-klasoru.sh *), PowerShell(*kitap-klasoru.ps1*)
---

# Çeviri — yabancı metinden Türkçeye

**Önce:** `divit:kurallar` bu oturumda yüklenmediyse şimdi Skill aracıyla yükle; her komut oradaki kabuk kuralına ve araç yollarına uyar (`cat`, zincir, `cd` yok).

Tür satırını `.divit/profil/kimlik.md`'den Read ile oku. Hitap ve kelimeler
rol dosyasına göre: yazara "kitabınız", "okur", "yayınevi"; akademik kelime yok.

## Yasaklar

1. **Kaynak dosyayı değiştirme.** Çeviri her zaman yeni dosyadır. `asil/`,
   `malzeme/`, `gelen/` içine hiçbir şey yazma.
2. **Künye uydurma.** Yazar, eser adı, yayınevi, yıl, sayfa yalnız
   kullanıcının verdiği ya da dosyanın kendisinde yazandır. Bilinmiyorsa
   sor; cevap yoksa ilgili yere `[DOĞRULA]` yaz.
3. **Özetleme, ekleme, "düzeltme" yok.** Metinde ne varsa o çevrilir.
   Anlaşılmayan ya da iki anlama gelen yer `[ÇEVİRİ NOTU: …]` ile işaretlenir,
   tahminle kapatılmaz. Sayı, ad, tarih aynen aktarılır.
4. Hakemlik ya da jüri için gelmiş bir metni çevirme (`kurallar`).
5. Telif konusunda hüküm verme; yalnız aşağıdaki tek cümleyi söyle.

## Başlangıç

1. **Metin.** Kullanıcı yapıştırdıysa onu kullan. Dosya verdiyse Read ile
   oku (Word ve PDF için `kurallar`'daki çeviri tablosu, çıktı `.divit/gecici/`).
   Klasör dışındaki dosya için `kurallar`'daki "dışarıdaki dosya" sırası.
2. **Künye.** Metinle birlikte verilmediyse **tek soru** sor:
   "Bu metin nereden? Yazarı, eserin adı, yılı ve sayfası — bildiğiniz kadarı
   yeter." Verilmeyen parça `[DOĞRULA]` kalır.
3. **Ad.** Dosya adı yoksa kısa bir ad öner (küçük harf, Türkçe karaktersiz,
   tireli; ör. `liderlik-bolum-3`), onay al.
4. **Üslup.** `.divit/profil/uslup.md`'yi Read ile oku. Yoksa ya da "Henüz
   doldurulmadı" diyorsa Grep ile `.divit/profil/` içinde "üslup" ya da
   "Nasıl yazar" ara. Hiçbiri yoksa sade, akıcı Türkçe; işin sonunda bir kez
   "Kendi yazdığınız bir metni verirseniz çeviriyi sizin sesinize yaklaştırırım" de.
5. **Terimler.** `.divit/profil/terimler.md`'yi Read ile oku (yoksa işin
   sonunda açılır). Oradaki karşılıklar **bağlayıcıdır**; kendi tercihin başka
   olsa da onları kullan.

## Çeviri

- Anlamı ve tonu çevir, sözcükleri değil. İngilizce cümle yapısını taşıma
  (edilgen yığılması, uzun ad tamlamaları, "-ki" zinciri).
- Kullanıcının üslubu genel kuraldan önce gelir (cümle uzunluğu, "siz/sen",
  deyim, benzetme).
- **Yazım: Türk Dil Kurumu Yazım Kılavuzu.** Özellikle: bağlaç "de/da", "ki",
  soru eki "mi" ayrı; özel adlara gelen ek kesmeyle (Drucker'ın); yabancı özel
  ad aslıyla; kurum adı büyük harfle; sayılar rakamla, binlik nokta, ondalık
  virgül (3.500; 2,5); yüzde işareti önde (%40); tırnak içi alıntı “…”.
- Bölüm başlığı, dipnot, liste yapısı korunur.
- Yabancı kavramın yerleşik bir Türkçe karşılığı yoksa ilk geçtiği yerde
  Türkçesi ve ayraç içinde aslı: "paydaş (stakeholder)". Sonrasında yalnız Türkçesi.

## Dosya

Yer: metin bir kitaba aitse `kitaplar/<kitap-adi>/ceviri/<ad>-ceviri-<YYYY-AA-GG>.md`;
değilse `yazilar/<ad>-ceviri-<YYYY-AA-GG>.md`. Aynı adlı dosya varsa sonuna
`-2` ekle; var olanın üstüne yazma. Kitap klasörü yoksa önce `kurallar`'daki
betikle `ac <kitap-adi>`. Biçim:

```
# <Türkçe başlık>

Kaynak: <kullanıcının verdiği künye; eksik parça [DOĞRULA]>
Özgün dil: <dil> · Çeviri: Divit, <YYYY-AA-GG> · Kaynak dosya: <yol ya da "sohbete yapıştırıldı">

> Bu bir çeviridir. Kitapta ya da başka bir yayında kullanılırsa kaynak
> gösterilmelidir; uzun alıntı için hak sahibinden izin gerekebilir.

<çeviri metni>
```

Sonra sayfa hâlini üret (`kurallar` › "Rapor gösterme"), iki dosyayı tam
yoluyla ver.

## Terim listesi

Metinde geçen, kitap boyunca aynı çevrilmesi gereken her kavram (meslek
terimi, kavram adı, tekrar eden deyim) `.divit/profil/terimler.md`'ye girer.
Dosya yoksa bu başlıkla aç:

```
# Terimler

Divit çevirilerde bu karşılıkları kullanır. Değiştirmek isterseniz söyleyin.

| Özgün | Türkçe | Not |
|---|---|---|
```

Var olan satırı değiştirme, yalnız yenisini sona ekle; aynı terim zaten
varsa ekleme. Not sütununa ilk geçtiği dosyanın adını yaz. Karar vermekte
zorlandığın terimin notuna "seçim sizin" yaz.

## Kapanış

Kullanıcıya en fazla dört kısa satır:
1. Çevirinin dosyası (tam yolla, yukarıdaki gibi).
2. Terim listesine eklenen yeni terimler ve seçilen karşılıkları, virgülle.
   "Başka bir karşılık isterseniz söyleyin, listeyi ve çeviriyi birlikte düzeltirim."
3. `[ÇEVİRİ NOTU]` ya da `[DOĞRULA]` kaldıysa sayısı.
4. Tek cümle hatırlatma: "Bu metni yayımlamak isterseniz kaynağını gösterin;
   uzun alıntı ya da çeviri için hak sahibinden izin gerekebilir."

Kullanıcı bir terimi değiştirirse: `terimler.md`'deki satırı güncelle
(`.divit/` altında olduğu için önceki sürüm gerekmez), çeviri dosyasının
önceki sürümünü `kurallar`'a göre al, terimi dosyanın her yerinde değiştir.

Günlüğe: `YYYY-AA-GG SS:DD · çeviri · <ad> · <kaç paragraf, kaç yeni terim>`.
