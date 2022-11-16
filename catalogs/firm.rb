require 'C:\www\root\sinatra_1c_77\catalogs\catalog.rb'

class Firm < Catalog

  def get_price_type_json

    @array_items = []

    if @code == nil
      @catalog.ВыбратьЭлементы()
      while @catalog.ПолучитьЭлемент(1) == 1 do
        add_element_to_array_2
      end
    else
      if @catalog.НайтиПоКоду(@code) == 1
        add_element_to_array_2
      else
        return []
      end
    end
    @array_items.to_json
  end

end

def add_element_to_array_2

  if @catalog.ЭтоГруппа() == 1
    return
  end

  item = Hash[]
  item['Код'] =@catalog.Код == "0" ? 101 : @catalog.Код
  item['ПометкаУдаления'] = get_boolean @catalog.ПометкаУдаления()
  item['Наименование'] = @catalog.Наименование
  item['ИНН'] = @catalog.ИНН
  item['КодПоЕДРПОУ'] = @catalog.ЕДРПОУ

  @array_items.push(item)

end
