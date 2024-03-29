require 'date'
require 'json'
require "net/http"
require "uri"
require './path'

class Convert

  attr_accessor :data_file

  def initialize (v7, rule, date1=Date.today, date2=Date.today, period=Date.today, update=false, code)

    @v7 = v7
    @rule = rule
    @date1 = date1
    @date2 = date2
    @period = period
    @update = update == "update_" ? 1 : 0
    @code = code =="empty" ? '': code.to_s

  end

  def upload_data_file

    path = 'C:\www\root\sinatra_1c_77\convert\V77Imp.ert';
    nameCommand = 'Загрузить'
    parameterList = @v7.CreateObject('СписокЗначений')
    parameterList.ДобавитьЗначение(@data_file,'ИмяФайлаДанных')
    parameterList.ДобавитьЗначение(nameCommand,'ИмяКоманды')

    @v7.ОткрытьФормуМодально('Отчет',parameterList, path)

  end

  def get_documents_list_json
    file = File.read(@data_file)
    data = JSON.parse(file)

    data.each { |e|
      date = e['date']
      doc = @v7.CreateObject('Документ.' +e['doc_type'])
      if doc.НайтиПоНомеру(e['number'], date) == 1
        e['number77'] = doc.НомерДок
        e['date77'] = doc.ДатаДок
        e['post77'] = doc.Проведен() == 1 ? true : false
      end
    }
     data.to_json
  end

  def send_data_v8(data, method_name='')

    path = Path.new

    uri = URI("http://#{path.v8_path[:host]}:#{path.v8_path[:port]}/unf_dev/hs/v77-api/data_v7/#{method_name}/")

    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri)
    request.body = data
    p data
    request.basic_auth path.v8_path[:usr], path.v8_path[:pw]

    # Send the request
    res = http.request(request)
    p "send data to server 1cV8, status response #{res.code} "
  end

end
