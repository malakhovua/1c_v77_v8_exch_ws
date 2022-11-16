require 'C:\www\root\sinatra_1c_77\documents\document.rb'

class DocumentPrices < Document

  def get_document_array (documents, doc_array)
    if documents.nil?
      return []
    end

    header = Hash[]
    items = []

    header["Дата"] = documents.ДатаДок.strftime("%s")
    header["Номер"] = documents.НомерДок[0...2] + documents.НомерДок[-7..-1]
    header["ПометкаУдаления"] = get_boolean(documents.ПометкаУдаления())
    header["Проведен"] = get_boolean (documents.Проведен())
    header["Комментарий"] = documents.Примечание
    header["КатегорияЦенНаименование"] = documents.Категория.Наименование
    header["КатегорияЦенКод"] = documents.Категория.Код
    while documents.ПолучитьСтроку() == 1 do
      item = Hash[]
      item["НоменклатураКод"] = documents.ТМЦ.Код
        item["СхемаРасчетаЦенСтруктура"] = {'Наименование' => documents.СхемаЦенообразованияСтр.Наименование, 'Код' => documents.СхемаЦенообразованияСтр.Код}
        item["Цена"] = documents.Цена
        item["БазовыйВидЦеныНаименование"] = documents.БазоваяКатегорияЦен.Наименование
        item["БазовыйВидЦеныКод"] = documents.БазоваяКатегорияЦен.Код
        item["Примечание"] = documents.ПримечаниеСтр
      items.push(item)
    end
    doc = Hash[header: header, items: items]
    doc_array.push(doc)
    doc_str = doc_in_string(documents)

    @base.insert_crc(Time.now.inspect, documents.ДатаДок.inspect, 0, doc_str, crc(documents), documents.НомерДок, @doc_type, @doc_type_number)
  end

end
