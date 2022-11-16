require 'C:\www\root\sinatra_1c_77\catalogs\catalog.rb'

class PriceType < Catalog

  def get_price_type_json

    @array_items = []

    if @code == nil
      @catalog.ВыбратьЭлементы()
      while @catalog.ПолучитьЭлемент(1) == 1 do
       add_element_to_array_
      end
    else
      if @catalog.НайтиПоКоду(@code) == 1
        add_element_to_array_
      else
        return []
      end
    end
    @array_items.to_json
  end

end

def add_element_to_array_

  if @catalog.ЭтоГруппа() == 1
    return
  end

  item = Hash[]
  item['code'] = @catalog.Код
  item['del_mark'] = get_boolean @catalog.ПометкаУдаления()
  item['name'] = @catalog.Наименование
  item['not_auto'] = get_boolean(@catalog.НеРассчитыватьАвтомат)
  item['profit'] = @catalog.ТорговаяНаценка

  @array_items.push(item)

end
