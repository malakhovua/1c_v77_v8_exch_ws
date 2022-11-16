require 'C:\www\root\sinatra_1c_77\catalogs\catalog.rb'

class Nomenclature < Catalog

  def get_pack_prices_json

    @array_items = []

    if @code == nil
      @catalog.ВыбратьЭлементы()
      while @catalog.ПолучитьЭлемент(1) == 1 do
        add_element_to_array
      end
    else
      if @catalog.НайтиПоКоду(@code) == 1
        add_element_to_array
      else
        return []
      end
    end
    @array_items.to_json
  end

end

def add_element_to_array

  if @catalog.ЭтоГруппа() == 1
    return
  end

  header = Hash[]
  header['nomenclature_code'] = @catalog.Код

  items = []

  packs = Pack.new(@V7, @catalog).ref

  packs.ВыбратьЭлементы()

  while packs.ПолучитьЭлемент() == 1 do

    prices = []

    periods77 = @V7.CreateObject("Периодический")
    periods77.ИспользоватьОбъект("Цена", packs.ТекущийЭлемент())
    periods77.ВыбратьЗначения()

    while periods77.ПолучитьЗначение() == 1 do
      prices.push({ "date" => periods77.ДатаЗнач.strftime("%s"), "price" => periods77.Значение })
    end
    items.push({ "pack_type_code" => packs.ВидУпаковки.Код, "prices" => prices })
  end

  header['items'] = items
  @array_items.push(header)

end
