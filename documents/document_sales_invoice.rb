require 'C:\www\root\sinatra_1c_77\documents\document.rb'

class DocumentSalesInvoice < Document

  def get_document_array(documents, doc_array)

    if documents.nil?
      return []
    end

    header = Hash[]
    items = []

    header["Дата"] = documents.ДатаДок.strftime("%s")
    header["Номер"] = documents.НомерДок
    header["ПометкаУдаления"] = get_boolean(documents.ПометкаУдаления())
    header["ФиксироватьСхему"] = get_boolean(documents.ФлРучногоИзмСхемыРБ)
    header["СтруктураСхема"] ={'Дата'=>documents.СхемаРБ.ДатаДок,'Номер'=>documents.СхемаРБ.НомерДок}
    header["Проведен"] = get_boolean (documents.Проведен())
    header["Комментарий"] = documents.Примечание;
    header["Курс"] = 1
    header["Кратность"] = 1
    header["СуммаВключаетНДС"] = true
    header["КонтрагентКод"] = documents.Контрагент.Код
    header["СтруктураСклад"] = {'Код' => documents.МестоХранения.Код, 'Наименование' => documents.МестоХранения.Наименование }
    header["ВидЦен"] = documents.КатегорияЦен.Наименование
    header["Ф1"] = get_boolean(documents.ф1)
    header["ВидДокументОснование"] = map_type_doc[documents.ДокументОснование.Вид()]
    unless header["ВидДокументОснование"].nil?
     header["ДокументОснование"] = { 'Номер' => documents.ДокументОснование.НомерДок, 'Дата' => documents.ДокументОснование.ДатаДок.strftime("%s") }
    end
    header["crc"] = crc (documents)
    while documents.ПолучитьСтроку() == 1 do
      item = Hash[]
      item["НоменклатураКод"] = documents.ТМЦ.Код
      item["Количество"] = documents.Кво
      item["Цена"] = documents.ЦенаСНДС
      item["Сумма"] = documents.СуммаСНДС
      item["СуммаНДС"] = documents.НДС
      item["СтавкаНДС"] = documents.ВидНДС.Код
      item["ЕдНаимен"] = documents.Ед.Наименование
      item["ЦенаБезНДС"] = documents.ЦенаБезНДС
      item["СуммаБезНДС"] = documents.СуммаБезНДС
      item["СуммаНДС"] = documents.НДС
      item["Сумма"] = documents.СуммаСНДС
      item["ЦенаБезНДС"] = documents.ЦенаБезНДС
      item["ЦенаБезСкидки"] = documents.ЦенаБезСкидки
      item["СкидкаВес"] = documents.свес
      item["КоличествоУМК"] = documents.кол
      item["ВесУпаковки"] = documents.ВесУп
      item["ДопКоличество"] = documents.ДопКво
      item["ВидУпаковкиКод"] = ""
      item["ЦенаУпаковки"] = documents.ЦенаУпаковки
      item["СуммаУпаковки"] = documents.СуммаУпаковки

      if documents.ВидУпаковки.Выбран() == 1 && documents.ВидУпаковки.Идентификатор() != @enum_pack_type.Нет.Идентификатор()
        owner = documents.ТМЦ
        pack = Pack.new(@V7, owner)
        if pack.ref.НайтиПоРеквизиту("ВидУпаковки", documents.ВидУпаковки, 0) == 1
          item["ВидУпаковкиКод"] = pack.ref.ВидУпаковки.код
        end
      end
      items.push(item)
    end
    doc = Hash[header: header, items: items]
    doc_array.push(doc)
    doc_str = doc_in_string(documents)

    @base.insert_crc(Time.now.inspect, documents.ДатаДок.inspect, 0, doc_str, header["crc"], header["Номер"], @doc_type, @doc_type_number)

  end

  def map_type_doc
    types = { 'УМК_ЗаказКлиента' => 'ЗаказПокупателя', 'РасходнаяНакладная' => 'РасходнаяНакладная' }
    types
  end

end
