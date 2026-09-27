---
description: Devam eden isi yeni bir Claude oturumuna devret; cocuk bitince ayni sohbete rapor doner.
argument-hint: [--lane handoff|review|merge-pr|issue|docs|research] <ne yapilacak>
---

# /session — Oturum Devri

Bu oturumdan cikmadan yeni bir Claude Code oturumu acar, isi ona devreder ve
**bağlantıyı kurar**: çocuk sonucu `orc report` ile kaydeder. Pano sunucusu
raporu yönetilen ana oturuma iletir; sen çalışmaya devam edebilirsin.

Kullanim: `/session --lane review "PR 175'i incele"` · `/session HMX-155`

## Ne zaman

Elindeki isi birakmadan **ayri uzmanlik** gerektiginde: kodu yazarken review,
issue biterken merge, uzun bir arastirma dallanirken kesif. Devir isi
hizlandirmak icindir, bolmek icin degil — ayni dosyada paralel iki yazici
istemiyorsan devretme.

**Ayri bir oturum acmanin tek yolu budur.** `claude --bg`, `claude -p` ya da
baska bir yolla dogrudan oturum acma: o oturum orc'ta kosu olarak kaydedilmez,
panoda yalniz "ayni dizinde" satiri olarak gorunur, raporu kaydedilmez, butce
tavani onu durduramaz ve kesilirse yeniden acilamaz (2026-09-13'te HMX-288'in
actigi "Gorusme formu" oturumunda boyle oldu). Ayni oturumun icinde kalan
`Agent` alt ajanlari bu kuralin disindadir.

Devretme: iki dakikalik is (kendin yap), kullanicinin cevabini bekleyen karar
(devir onu gizler), ve **sana reddedilmis herhangi bir is**.

## Kirmizi cizgi — izin aklama

Bu oturumda reddedilmis, engellenmis ya da izin ayarlarinin durduracagi bir isi
cocuga yaptirma. Izin sinirlari oturum basinadir; devir onlarin etrafindan
dolasmanin yolu degildir. Reddedilen isi kullaniciya geri goturursun.

Ayni sebeple **devir zinciri tek kademe**: devredilmis bir oturum tekrar
devredemez. `orc` bunu ayrica kendi tarafinda reddeder.

## Adimlar

### 0. On kontrol — devir altyapisi ayakta mi

```bash
orc doctor
```

Ciktidaki **her `✗` satirini oku** — sadece ilkini degil. Ikisi devri durdurur:

- `orc: command not found` → orc PATH'te degil. Kullaniciya soyle:
  `ln -s <orc-repo>/bin/orc ~/.local/bin/orc`.
- **`proje: bu agacta .orc/config.json yok`** → bu projede orc kurulu degil,
  devir calismaz. `orc init --yes` bunu kurar **ama ayni zamanda projenin
  `.claude/settings.local.json`'ina PreToolUse/Stop hook'lari yazar** — yani o
  projede acilan HER oturum bundan sonra orc'un kapisindan ve butce defterinden
  gecer. Bu kullanicinin karari; **kendin kurma, sor.**

`hook kurulu degil` devri durdurmaz ama **kapiyi kaldirir**: cocuk geri
donulmez bir komuta gelince onay istemez, dogrudan yapar. Devretmeden once
kullaniciya bir satirla soyle.

### 1. Kendi adresini ve zincirdeki yerini ogren

`ListAgents` cagir. Ilk satir bu oturumun adresidir:
`This session is humindx-8d [7c46b4]` → adres `humindx-8d`.

Sonra `orc whoami`. Ciktida **"tekrar devredemez"** yaziyorsa dur ve kullaniciya
soyle: bu oturum zaten devralinmis, devri baslatan oturuma rapor et.

### 2. Seridi SEN sec — `orc route`'a sorma

Serit bir siniflandirma degil, bir **prompt sablonudur**: cogu serit senin
metnini alip basina bir slash komutu koyar (`/issue`, `/analiz`, `/merge-pr`,
`/feature`, `/code-review`). Yani yanlis serit, cocuga yanlis ritueli baslatir.
Sen ne devrettigini zaten biliyorsun; tahmine ihtiyac yok.

**Varsayilan `handoff`.** Serbest is icin bu: ritual yok, prompt'un aynen
gider, devredenin calisma agacinda kosar, yazabilir.

Yalnizca **o ritueli** devrediyorsan baska serit sec:

| Devredilen is | Serit |
|---|---|
| Serbest is — "sunu yap", olcum, kurulum, arastirma-ve-duzelt | `handoff` (varsayilan) |
| Var olan bir issue'yu bastan sona yurutmek | `issue` (ref gerekir: `HMX-155`) |
| Acik bir PR'i kapatmak | `merge-pr` |
| Degisiklikleri incelemek (salt okunur) | `review` |
| Ogrenci/oturum vaka incelemesi | `analiz` |
| Sirf okuma, hicbir sey yazmayacak | `research` |

`orc route` ile serit **tahmin ettirme**. Uzun metinde anahtar kelime
esleşmesi kanit degil: olculdu — 5036 karakterlik bir devir sekiz seridin
altisina carpti, altisinin dordu baska kelimelerin icindeki parcalardi
("kol" ← "kollu"), ve kazanan serit prompt'a `/analiz` ekliyordu. `orc` artik
400 karakteri gecen metinde seritsiz dispatch'i reddediyor.

### 3. Once kuru calistir, gonderilecek prompt'u GOR

```bash
orc dispatch --lane <serit> --dry-run \
  --parent "<1. adimdaki adres>" --parent-run "${ORC_RUN:-}" --cwd "$(pwd)" \
  "<is metni>"
```

Ciktidaki `prompt:` satirinin ilk karakterine bak. **`/` ile basliyorsa** bir
ritual baslatmak uzeresin — bunu bilerek yapmiyorsan serit yanlis.
Kosu id'sini de burada gorursun; sonraki her komut onu ister.

Bayraklarin tamami: `orc dispatch --help`.

### 4. Devret

Ayni komutu `--dry-run` olmadan calistir.

- `--parent` cocuga raporu nereye gonderecegini soyler; `orc` bunu prompt'un
  sonuna sozlesme olarak ekler (rapor bicimi, izin aklama yasagi, tek kademe
  kurali ve "metin isin tamami, baska ritual baslatma" maddesi dahil).
- `--parent-run` zincir derinligini denetler. Bu oturum bir orc kosusu degilse
  `ORC_RUN` bos gelir, sorun degil.
- `--cwd "$(pwd)"` **review, merge ve yerel stack'e dokunan her is icin
  sarttir**: cocuk senin commit'lenmemis isini, `.env`'ini ve ayakta duran
  stack'ini ancak ayni calisma agacinda gorur. Bagimsiz bir is devrediyorsan
  (arastirma, ayri bir issue) `--cwd` verme, kendi worktree'sini acsin.

**Is metnini yazarken:** cocuk bu metni bir insan talimati gibi okur. Bildigin
tuzaklari yaz (nereye bakmasin, hangi uc yaniltici), kapsam disini acikca soyle
(deploy yok, main yok, push yok). Sohbet dokumu yapistirma — devrettigin is
ne ise o. Metin uzun olabilir; uzunluk sorun degil, **belirsizlik** sorun.

### 5. Kullaniciya bir satirla soyle, calismaya devam et

Ne devrettigini, hangi seride dustugunu, butcesini ve **rapor bekledigini** yaz.
Sonra kendi isine don — cocugu **bekleme**, `orc ps` dongusune girme, "bitti mi"
diye mesaj atma. Rapor kendiliginden gelir.

### 6. Kosuyu nerede bulacaksin

**`orc ps`.** Orc'un kendi defteri budur ve kosu id'si degismez.

Claude'un oturum listesine (`ListAgents`, `claude agents`) **bakma**: arka plan
oturumlari orada hem ad degistirir — Claude Code ilk turdan sonra `-n` ile
verdigin adin uzerine kendi baslığını yazar, `sub-...` adi kaybolur — hem de
`ListAgents`'in akran listesinde arka plan oturumlari hic gorunmez. Cocuga
mesaj gonderemezsin; ona bakmanin yolu `orc logs <kosu id>`.

### 7. Rapor geldiginde

Çocuğun raporu orc tarafından yeni bir mesaj olarak iletilir.
Yapilacak:

1. **Iddiayi dogrula.** Rapor kanit degil. "Testler gecti" diyorsa cikti nerede,
   "PR acildi" diyorsa numarasi ne. Ikinci elden gelen sonucu olcmeden aktarma.
2. **Kullaniciya ozetle.** Ham raporu yapistirma; ne degisti ve simdi ne karar
   gerekiyor, onu yaz.
3. **Kosuyu kapat:** `orc kill <kosu id>` — worktree actiysa `--clean` ekle.

Çocuk raporu `orc report` ile kaydeder; `orc runner` çalışırken yönetilen ana
oturuma teslim edilir. Aynı raporu `SendMessage` ile tekrar gönderme. Orc dışında
bir ana oturum varsa ve araç kullanılabiliyorsa `SendMessage` ile bir kez ilet.
Mesaj düşmediyse rapor panoda koşunun detayında "Rapor"
bolumunde durur, satirda "rapor verildi" yazar. Satirda "rapor yok" yaziyorsa
cocugun turu bitmis ama rapor birakmamistir — ona mesaj gonderip raporu iste.

Rapor hic gelmezse: `orc ps` bir kez bak. `running` ise `orc logs <kosu id>` ile
nerede takildigina bak. `over-budget` ise tavana carpmistir; `orc budget raise`
kullaniciya sorulacak bir karardir, kendin yukseltme.

## Kapsam disi

Deploy, `main`'e dokunan is, ve devralinan oturumdan yeni devir. Bunlar
devredilmez — kullanicinin kendi oturumunda kalir.

**Serit uydurma.** Hicbir serit uymuyorsa dur ve kullaniciya soyle; `.orc/config.json`'a
devir sirasinda serit ekleme. Bir devir isteği, proje yapilandirmasini
degistirmenin gerekcesi degildir.
