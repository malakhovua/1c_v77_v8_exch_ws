require 'C:\www\root\sinatra_1c_77\documents\document.rb'

class Contract < Document

  def get_document_array(documents, doc_array)

    doc_array.push({ "date" => documents.ДатаДок.strftime("%s"), "owner" => documents.Контрагент.Код,
                   "number" => documents.НомерДок, "name" => documents.НазваниеДоговора,
                   "date_start" => documents.ДатаНачала.strftime("%s"), "date_end" => documents.ДатаОкончания.strftime("%s"),
                   "del_mark" => get_boolean(documents.ПометкаУдаления()), "note" => documents.Примечание })

      @base.insert_crc(Time.now.inspect, documents.ДатаДок.inspect, 0, doc_in_string(documents), crc(documents), documents.НомерДок, @doc_type, @doc_type_number)

  end

end

