require 'C:\www\root\sinatra_1c_77\documents\document.rb'

class DocumentInventory < Document

  def get_document_array(documents, doc_array)

    if documents.nil?
      return []
    end

    header = Hash[]
    items = []
    header["Дата"] = documents.ДатаДок.strftime("%s")
    header["Номер"] = documents.НомерДок
    header["ОрганизацияКод"] = documents.Фирма.Код == "0" ? 101 : documents.Фирма.Код
    header["ПометкаУдаления"] = get_boolean(documents.ПометкаУдаления())
    header["Проведен"] = get_boolean (documents.Проведен())
    header["Комментарий"] = documents.Примечание
    header["СтруктурнаяЕдиница"] = {"СтруктурнаяЕдиницаКод" => documents.МестоХранения.Код, "Наименование" =>documents.МестоХранения.Наименование}
    header["crc"] = crc (documents)
    while documents.ПолучитьСтроку() == 1 do
      item = Hash[]
      item["НоменклатураКод"] = documents.ТМЦ.Код
      item["ВидУпаковкиКод"] = documents.ВидУпаковки.код
      item["ЕдНаимен"] = documents.Ед.Наименование
      item["Количество"] = documents.КвоПоФакту
      item["КоличествоУчет"] = documents.КвоПоУчету
      item["Отклонение"] = documents.Разница
      item["Цена"] = documents.ЦенаБезНДС
      item["Сумма"] = documents.СуммаПоФакту
      item["СуммаУчет"] = documents.СуммаПоУчету
      items.push(item)
    end

    doc = Hash[header: header, items: items]
    doc_array.push(doc)
    doc_str = doc_in_string(documents)

    @base.insert_crc(Time.now.inspect, documents.ДатаДок.inspect, 0, doc_str, header["crc"], header["Номер"], @doc_type, @doc_type_number)

  end

end

