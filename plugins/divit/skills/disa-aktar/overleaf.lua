-- Overleaf paketi için: resimleri .tex'in yanına düz adla yazar ve yolları
-- sadeleştirir; metnin sonundaki boş "Kaynakça" başlığını atar (LaTeX
-- kaynakçayı kendi başlığıyla basar). Python gerektirmez; pandoc çalıştırır.

local kaynakca_basliklari = {
  ["kaynakça"] = true, ["kaynakca"] = true, ["kaynaklar"] = true,
  ["references"] = true, ["bibliography"] = true, ["kaynakça:"] = true,
}

local function kucuk(s)
  return pandoc.text.lower(s)
end

function Pandoc(doc)
  local hedef = pandoc.path.directory(PANDOC_STATE.output_file or ".")
  pandoc.system.make_directory(hedef, true)

  doc = pandoc.mediabag.fill(doc)
  for yol, _, icerik in pandoc.mediabag.items() do
    local f = io.open(pandoc.path.join({ hedef, pandoc.path.filename(yol) }), "wb")
    if f then
      f:write(icerik)
      f:close()
    end
  end

  doc = doc:walk({
    Image = function(img)
      img.src = pandoc.path.filename(img.src)
      return img
    end,
  })

  local son = doc.blocks[#doc.blocks]
  if son and son.t == "Header"
      and kaynakca_basliklari[kucuk(pandoc.utils.stringify(son))] then
    doc.blocks:remove(#doc.blocks)
  end
  return doc
end
