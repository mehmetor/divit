# Web of Science — kaynak doğrulamada kullanılabilir mi?

Araştırma, 2026-10-01. Kod yazılmadı. Kaynak adresleri en altta; bulunamayan
her şey "doğrulanamadı" diye yazıldı.

## Kısa cevap

**Şimdilik hayır.** Künye ve geri çekme için Crossref + OpenAlex yeterli ve
anahtarsız çalışıyor. Web of Science'ın asıl katkısı künye değil, **"dergi
WoS'ta taranıyor mu"** sorusu (doçentlik, teşvik); bunun için ücretsiz Master
Journal List (MJL) var, ama Divit onu kendi başına sorgulayamıyor.

## Bulgular

**1. API'ler.** Clarivate'in geliştirici sitesinde Starter API (künye: başlık,
yazarlar, yıl, kaynak, cilt, sayı, sayfa, DOI; Core Collection'a karşı "gerçek
zamanlı künye denetimi" için tanıtılıyor; eski Lite API'nin yerini aldı),
Expanded API (tam künye, atıflar, kurumlar; ayrıca abonelik), Researcher API,
Journals API var. Örnek uç nokta:
`https://api.clarivate.com/apis/wos-starter/v1/documents?q=DO=<doi>`.
Geri çekme bilgisini döndürdüğüne dair kaynak **doğrulanamadı**.

**2. Anahtar — Divit için belirleyici engel.** Anahtar yalnız `X-ApiKey`
**başlığıyla** gönderiliyor. Divit'in yayın kayıtlarına tek erişimi WebFetch;
WebFetch başlık gönderemez, URL parametresiyle anahtar gönderme yolu
bulunamadı. Kabuk (curl, PowerShell) Divit'te yalnız pandoc/pdfcpu/dosya açma
için açık; başlıklı istek için kabuğu açmak Windows/Mac eşitliği ve izin
tasarımı açısından yeni bir karar olur.
Planlar (geliştirici sitesi): ücretsiz deneme 1 istek/sn, günde 50; kurum
üyesi 5/sn, günde 5.000; kurum entegrasyonu 5/sn, günde 20.000. Anahtar
portalda hesap + uygulama kaydı + onayla (e-postayla, birkaç gün) veriliyor;
Gmail gibi kişisel adresler reddedilebiliyor.

**3. EKUAL (ULAKBİM).** Türkiye'deki üniversiteler WoS'a EKUAL üzerinden
erişiyor (2006'dan beri). EKUAL aboneliğinin Starter API "kurum üyesi"
planına yetip yetmediği, erişimin IP'ye bağlı olup olmadığı, kampüs dışından
(VPN/EZproxy) API kullanımı — **doğrulanamadı**; kaynaklarda yok.

**4. Kullanım koşulları.** Arama özetlerinde, ayrı bir "yapay zekâ eki" ya da
yazılı izin olmadan Clarivate verisinin üretken yapay zekâ / dil modelleriyle
kullanılmasını ve bu amaçla üçüncü taraf teknolojiye aktarılmasını yasaklayan
bir koşul metni görüldü; metnin çıktığı sayfa **doğrulanamadı**. Divit bir dil
modeli asistanı olduğu için bu, anahtar sorunu çözülse bile engel olabilir.
Hukuki görüş gerekir.

**5. Alternatifler.**
- Künye, DOI, geri çekme: Crossref (`updated-by`, Retraction Watch verisi
  dahil) ve OpenAlex (`is_retracted`) başlıksız GET ile çalışıyor; bu dalda
  `kaynak-dogrula` bunları kullanıyor. WoS ile ölçülmüş kapsam
  karşılaştırması yapılmadı.
- Dergi taranma durumu (SCI-E/SSCI/AHCI/ESCI): MJL (`mjl.clarivate.com`)
  ücretsiz, girişsiz, başlık/ISSN ile aranıyor. WebFetch ile denendiğinde
  sayfa yalnız başlığı döndürdü (içerik tarayıcıda sonradan yükleniyor
  olmalı); API'si **doğrulanamadı**.

## Öneri

1. Künye doğrulamaya WoS **eklenmesin**: başlık zorunluluğu WebFetch'le
   uyuşmuyor, kurum aboneliği ve yapay zekâ koşulu belirsiz.
2. Künye ve geri çekme için Crossref + OpenAlex (+ DergiPark sayfası) ile devam.
3. "WoS'ta taranıyor mu" sorusunda Divit dergi adını ve ISSN'i verir, hocaya
   MJL adresini gösterir, sonucu hoca söyler; Divit tahmin etmez.
4. İleride kurum anahtarı olan hoca için isteğe bağlı bağlayıcı düşünülebilir;
   önce Clarivate'ten yapay zekâ kullanımı için yazılı cevap alınmalı.
5. Tek e-postayla sorulabilir: ULAKBİM/CABİM'e "EKUAL, WoS Starter API kurum
   anahtarını kapsıyor mu, kampüs dışından kullanılabilir mi?"

## Kaynaklar

- https://developer.clarivate.com/apis
- https://developer.clarivate.com/apis/wos-starter
- https://developer.clarivate.com/content/developer-portal-faq
- https://cabim.ulakbim.gov.tr/ekual-english-home/about/
- https://clarivate.com/ai/academia/policy/ (yalnız Clarivate'in kendi araçları)
- https://mjl.clarivate.com/search-results
- MJL için ikincil: https://casrai.org/guides/web-of-science-master-journal-list
