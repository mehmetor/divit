# divit.simetri.app

Derleme adımı olmayan statik site. Klasörün tamamını yayınlayın
(Cloudflare Pages, Netlify, GitHub Pages ya da herhangi bir sunucu).

- `index.html` — tanıtım sayfası
- `kilavuz.html`, `kart.html` — `hoca-paketi/Divit/` kopyaları

Kılavuz ya da kart değişince kopyaları yenileyin:

```bash
cp hoca-paketi/Divit/KILAVUZ.html apps/web/kilavuz.html
cp hoca-paketi/Divit/KART.html apps/web/kart.html
```

Yapay zekâ kurulum metninin aslı `belgeler/AJAN-KURULUM-ISTEMI.md`
dosyasındadır; değişirse `index.html` ve `README.md` içindeki kopyayı da güncelleyin.
