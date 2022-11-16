require 'C:\www\root\sinatra_1c_77\catalogs\catalog.rb'
require 'C:\www\root\sinatra_1c_77\catalogs\nomenclature.rb'

class NomenclatureClients < Catalog

  def get_catalog_array_to_json

    nomen_obj = Nomenclature.new(@V7, 'ТМЦ')
    nomen = nomen_obj.ref
    array = []
    nomen.ВыбратьЭлементы()

    while nomen.ПолучитьЭлемент(1) == 1 do

      if nomen.ЭтоГруппа() == 1
        next
      end

      @owner = nomen
      nom_client = @catalog
      use_owner

      header = Hash[]
      items = []
      header['nomenclature_code'] = @owner.Код

      nom_client.ВыбратьЭлементы()

      while nom_client.ПолучитьЭлемент() == 1 do
        item = { 'client_code' => nom_client.Контрагент.Код }
        items.push(item)
      end
      header['items'] = items
      unless items.count == 0
        array.push(header)
      end
    end

    return array.to_json

  end

end
