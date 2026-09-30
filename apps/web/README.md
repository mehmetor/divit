# divit.simetri.app

Derleme adımı olmayan statik site. Klasörün tamamını yayınlayın
(Cloudflare Pages, Netlify, GitHub Pages ya da herhangi bir sunucu).

- `index.html` — tanıtım sayfası (akademisyen; sonda "Kitap yazıyorsanız" bölümü)
- `kilavuz.html`, `kart.html` — `hoca-paketi/Divit/` kopyaları
- `kilavuz-yazar.html`, `kart-yazar.html` — yazar kılavuzu ve kartı, aynı yerin kopyaları

Kılavuz ya da kart değişince kopyaları yenileyin (`diff` boş çıkmalı):

```bash
cp hoca-paketi/Divit/KILAVUZ.html apps/web/kilavuz.html
cp hoca-paketi/Divit/KART.html apps/web/kart.html
cp hoca-paketi/Divit/KILAVUZ-YAZAR.html apps/web/kilavuz-yazar.html
cp hoca-paketi/Divit/KART-YAZAR.html apps/web/kart-yazar.html
```

Yapay zekâ kurulum metninin aslı `belgeler/AJAN-KURULUM-ISTEMI.md`
dosyasındadır; değişirse `index.html` ve `README.md` içindeki kopyayı da güncelleyin.

## Kısa kurulum adresi

`_redirects` (Cloudflare Pages, Netlify) ve `vercel.json` (Vercel),
`divit.simetri.app/kur.ps1` ve `/kur.sh` adreslerini GitHub'daki
betiklere yönlendirir. Başka bir sunucu kullanılırsa aynı iki 302
yönlendirmesini orada tanımlayın. Yayından sonra deneyin:

```bash
curl -sI divit.simetri.app/kur.sh | head -3    # 302 ve Location görünmeli
```
