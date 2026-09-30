# divit.simetri.app

Derleme adımı olmayan statik site. Klasörün tamamını yayınlayın
(Cloudflare Pages, Netlify, GitHub Pages ya da herhangi bir sunucu).

- `index.html` — tanıtım sayfası; başta rol sekmesi (Akademisyen | Kitap
  yazarı), `#yazar` yazar sekmesini açar
- `kilavuz.html` — `hoca-paketi/Divit/KILAVUZ.html` kopyası; tek kılavuz,
  iki sekme (`#akademisyen`, `#yazar`)
- Eski adresler için yönlendirme sayfaları: eski yazar kılavuzu ve iki kart
  sayfası `kilavuz.html`'e gider (Railway `_redirects`'i uygulamadığı için
  sayfa olarak duruyorlar; `_redirects` ve `vercel.json`'da da aynı kurallar var)

Kılavuz değişince kopyayı yenileyin (`diff` boş çıkmalı):

```bash
cp hoca-paketi/Divit/KILAVUZ.html apps/web/kilavuz.html
```

Kılavuzun sekmesi sırasıyla şuna bakar: adresteki `#yazar` / `#akademisyen`,
kök etiketteki `data-rol` (şablonda boş; kurulum doldurur), tarayıcının
hatırladığı son seçim, yoksa akademisyen.

Yapay zekâ kurulum metninin aslı `belgeler/AJAN-KURULUM-ISTEMI.md`
dosyasındadır; değişirse `index.html` ve `README.md` içindeki kopyayı da güncelleyin.

## Kısa kurulum adresi

Site Railway'de yayında (yanıt başlığında `x-railway-request-id`); Railway
`_redirects`'i uygulamıyor, `/kur.sh` betik dosyasının kendisini verir.
`_redirects` (Cloudflare Pages, Netlify) ve `vercel.json` (Vercel),
`divit.simetri.app/kur.ps1` ve `/kur.sh` adreslerini GitHub'daki
betiklere yönlendirir. Başka bir sunucu kullanılırsa aynı iki 302
yönlendirmesini orada tanımlayın. Yayından sonra deneyin:

```bash
curl -sI divit.simetri.app/kur.sh | head -3    # 302 ve Location görünmeli
```
