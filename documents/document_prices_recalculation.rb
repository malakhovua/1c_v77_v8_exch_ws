require 'C:\www\root\sinatra_1c_77\documents\document.rb'

class DocumentPricesRecalculation < Document

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
    while documents.ПолучитьСтроку() == 1 do
      item = Hash[]
      item["НоменклатураКод"] = documents.ТМЦ.Код
      item["ЦенаТекущая"] = documents.ЦенаБыло
      item["Цена"] = documents.ЦенаСтало
      item["ЦенаБазовая"] = documents.БазоваяЦена
      item["БазовыйВидЦеныНаименование"] = documents.БазоваяКатегоряЦен.Наименование
      item["БазовыйВидЦеныКод"] = documents.БазоваяКатегоряЦен.Код
      item["ВидЦеныКод"] = documents.Категория.Код
      item["ВидЦеныНаименование"] = documents.Категория.Наименование
      items.push(item)
    end
    doc = Hash[header: header, items: items]
    doc_array.push(doc)
    doc_str = doc_in_string(documents)

    @base.insert_crc(Time.now.inspect, documents.ДатаДок.inspect, 0, doc_str, crc(documents), documents.НомерДок, @doc_type, @doc_type_number)
  end

end
