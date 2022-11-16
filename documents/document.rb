require 'json'
require 'C:\www\root\sinatra_1c_77\db\base.rb'
require 'C:\www\root\sinatra_1c_77\catalogs\pack.rb'

class Document
  attr_accessor :doc77

  def initialize (v7, date1, date2, number = "", doc_type, update, doc_type_number)
    @V7 = v7
    @date1 = date1
    @date2 = date2
    @number = number
    @update = update
    @doc_type = doc_type
    @enum = v7.Перечисление
    @enum_pack_type = @enum.ВидыУпаковки
    @doc_type_number = doc_type_number
    @base = Base.new
  end

  def doc77
    @doc77
  end

  def get_documents_by_period
    @doc77 = @V7.CreateObject('Документ.' + @doc_type)
    puts @date1
    puts @date2
    @doc77.ВыбратьДокументы(@date1, @date2)
  end

  def get_document_by_number
    @doc77 = @V7.CreateObject('Документ.' + @doc_type)
    if @doc77.НайтиПоНомеру(@number, @date1) == 1
      @doc77.ТекущийДокумент()
    else
      @doc77 = nil
    end
  end

  def get_document_by_period_json

    if @number == 'empty'
      get_documents_by_period
    else
      get_document_by_number
    end

    documents = @doc77

    doc_array = Array.new

    if @number == 'empty'

      while documents.ПолучитьДокумент() == 1 do

        #puts "crc_active? " + @base.crc_active(documents.НомерДок, @doc_type_number, crc(documents).to_s).nil?.to_s

        if @update == 1 || @base.crc_active(documents.НомерДок, @doc_type_number, crc(documents).to_s) == nil
          get_document_array(documents, doc_array)

          # puts @doc_type + " " + documents.НомерДок + ' от ' + documents.ДатаДок.inspect.to_s
          #puts crc(documents).to_s
        end
      end

    else
      get_document_array(documents, doc_array)
      #puts @doc_type + " " + documents.НомерДок +  ' от ' + documents.ДатаДок.inspect.to_s
    end

    doc_array.to_json

  end

  def get_document_array(documents, doc_array) end

  def get_boolean (value = 0)
    value == 0 ? false : true
  end

  def crc (documents)
    value_str = doc_in_string(documents)
    expr = 'РассчитатьКРК("' + value_str + '")'
    crc_value = @V7.EvalExpr(expr)
    crc_value
  end

  def doc_in_string(documents)
    value = @V7.ЗначениеВСтрокуВнутр(documents.ТекущийДокумент())
    value_str = value.gsub('"', '""')
    value_str
  end

end
