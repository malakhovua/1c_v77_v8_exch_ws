require 'sinatra'
require 'base64'
require 'stringio'
require 'date'
require 'time'
require 'securerandom'
require 'C:\www\root\sinatra_1c_77\com\1c_obj.rb'
require 'C:\www\root\sinatra_1c_77\documents\document_sales_invoice.rb'
require 'C:\www\root\sinatra_1c_77\documents\document_return_invoice.rb'
require 'C:\www\root\sinatra_1c_77\documents\document_prices.rb'
require 'C:\www\root\sinatra_1c_77\documents\document_prices_recalculation.rb'
require 'C:\www\root\sinatra_1c_77\documents\contract.rb'
require 'C:\www\root\sinatra_1c_77\documents\inventory.rb'
require 'zip'
require 'C:\www\root\sinatra_1c_77\catalogs\firm.rb'
require 'C:\www\root\sinatra_1c_77\catalogs\price_type.rb'
require 'C:\www\root\sinatra_1c_77\catalogs\nomenclature_clients.rb'
require 'C:\www\root\sinatra_1c_77\convert\convert.rb'
require 'C:\www\root\sinatra_1c_77\db\base.rb'
require 'sinatra/base'
require 'waitutil'
require 'fileutils'
require 'logger'

#log in file ?
=begin
puts "Output logs to a file? Enter (y/n)."
answer= gets
answer.chomp!
=end

LOG_IN_FILE = true #answer == "y" ?  true : false

::Logger.class_eval { alias :write :'<<' }
access_log = ::File.join(::File.dirname(::File.expand_path(__FILE__)),'.','log','access.log')
access_logger = ::Logger.new(access_log)
error_logger = ::File.new(::File.join(::File.dirname(::File.expand_path(__FILE__)),'.','log','error.log'),"a+")
error_logger.sync = true

log = File.new("log/sinatra.log", "a+")

if LOG_IN_FILE == true

  p 'Starting server. Logs will be saved in file  - log/sinatra.log.'

  $stdout.reopen(log)
  $stderr.reopen(log)

  $stderr.sync = true
  $stdout.sync = true
end

configure do
  set :server, "puma"
  # set       :port => 3000
  use ::Rack::CommonLogger, access_logger
end

before {
  env["rack.errors"] =  error_logger
}

use Rack::Auth::Basic do |username, password|
  username == 'admin' && password == '@fdkj7Uyt@F'
end

get '/work/documents_sales_invoice/:data1/:data2/:number/:update/:status' do

  if params['status'] == 'success'
    base = Base.new
    base.update_crc_records(1)
    return '[]'
  end

  puts "#{Time.now} Загрузка.. Расходные накладные "

  data1 = params['data1']
  data2 = params['data2']
  number = params['number']
  update = params['update'].to_i
  get_connect
  docs = DocumentSalesInvoice.new(@V7, data1, data2, number, 'РасходнаяНакладная', update, 1)
  puts Time.now
  return docs.get_document_by_period_json
end

get '/work/documents_prices/:data1/:data2/:number/:update/:status' do

  if params['status'] == 'success'
    base = Base.new
    base.update_crc_records(2)
    return '[]'
  end

  puts "#{Time.now} Загрузка.. Установка Цен ТМЦ "

  data1 = params['data1']
  data2 = params['data2']
  number = params['number']
  update = params['update'].to_i
  get_connect
  docs = DocumentPrices.new(@V7, data1, data2, number, 'УстановкаЦенТМЦ', update, 2)
  puts Time.now
  return docs.get_document_by_period_json
end

get '/work/documents_prices_recalculation/:data1/:data2/:number/:update/:status' do

  if params['status'] == 'success'
    base = Base.new
    base.update_crc_records(3)
    return '[]'
  end

  puts "#{Time.now} Загрузка.. Расчет по схемам цен ТМЦ "

  data1 = params['data1']
  data2 = params['data2']
  number = params['number']
  update = params['update'].to_i
  get_connect
  docs = DocumentPricesRecalculation.new(@V7, data1, data2, number, 'УМК_РасчетПоСхемамЦенТМЦ', update, 3)
  puts Time.now
  return docs.get_document_by_period_json
end

get '/work/documents_contracts/:data1/:data2/:number/:update/:status' do

  if params['status'] == 'success'
    base = Base.new
    base.update_crc_records(4)
    return '[]'
  end

  puts "#{Time.now} Загрузка.. Договора "

  data1 = params['data1']
  data2 = params['data2']
  number = params['number']
  update = params['update'].to_i
  get_connect
  docs = Contract.new(@V7, data1, data2, number, 'Договор', update, 4)
  puts Time.now
  return docs.get_document_by_period_json
end

get '/work/documents_return_invoice/:data1/:data2/:number/:update/:status' do

  if params['status'] == 'success'
    base = Base.new
    base.update_crc_records(5)
    return '[]'
  end

  puts "#{Time.now} Загрузка.. Возвратные накладные "

  data1 = params['data1']
  data2 = params['data2']
  number = params['number']
  update = params['update'].to_i
  get_connect
  docs = DocumentReturnInvoice.new(@V7, data1, data2, number, 'ВозвратнаяНакладная', update, 5)
  puts Time.now
  return docs.get_document_by_period_json
end

get '/work/documents_inventory/:data1/:data2/:number/:update/:status' do

  if params['status'] == 'success'
    base = Base.new
    base.update_crc_records(6)
    return '[]'
  end

  puts "#{Time.now} Загрузка.. Инвентаризация"

  data1 = params['data1']
  data2 = params['data2']
  number = params['number']
  update = params['update'].to_i
  get_connect
  docs = DocumentInventory.new(@V7, data1, data2, number, 'Инвентаризация', update, 6)
  puts Time.now
  return docs.get_document_by_period_json
end

get '/work/catalog_nomenclature_clients/:code/:update/:status' do

  puts "#{Time.now} Загрузка.. Номенклатура контрагентов "

  code = params['code']
  update = params['update']
  status = params['status']
  get_connect
  nomen_clients = NomenclatureClients.new(@V7, "КонтрагентыПродукции")

  return nomen_clients.get_catalog_array_to_json

end

get '/work/packs_price/:code/:update/:status' do

  puts "#{Time.now} Загрузка.. Цены упаковок "

  code = params['code'] == 'nil' ? nil : params['code']
  update = params['update']
  status = params['status']
  get_connect
  nomen = Nomenclature.new(@V7, "ТМЦ", nil, code)

  return nomen.get_pack_prices_json

end

get '/work/price_type/' do

  puts "#{Time.now} Загрузка.. Типы цен номенклатуры "

  get_connect

  price_type = PriceType.new(@V7, "КатегорииЦен", nil, nil)

  return price_type.get_price_type_json

end

get '/work/firm/' do

  puts "#{Time.now} Загрузка.. Организации "

  get_connect

  firms = Firm.new(@V7, "Фирмы", nil, nil)

  return firms.get_price_type_json

end

#=====================convert=========================================================
# ====================================================================================

#get '/work/convert/:rule/:data1/:data2/:period/:update/:code/'  do
get /\/work\/convert\/(.*)\/(.*)\/(.*)\/(.*)\/(.*)\/(.*)\/(.*)\// do

  id_session = params['captures'][0]
  rule = params['captures'][1]
  date1 = params['captures'][2]
  date2 = params['captures'][3]
  period =params['captures'][4]
  update = params['captures'][5]
  code = params['captures'][6]

  dir_path = 'C:/www/root/sinatra_1c_77/convert/data/'
  main_pid = $PID

  data_file =  dir_path + SecureRandom.uuid.to_s + '.xml'
  exe_file = "C:/www/root/sinatra_1c_77/convert/execute_1c77.rb"
  p "MAIN APPLICATION PID - #{main_pid}"

  puts "#{Time.now} Конвертация загрузка #{rule} за период от #{date1} до #{date2} . Период: #{period} . Код: #{code} "

  begin

    pid = spawn("ruby #{exe_file}  '#{rule}' '#{date1}' '#{date2}' '#{period}' '#{update}' '#{code}' '#{data_file}'")
    p "current process PID - #{pid}"

  rescue => e
    p "=============================================================================================================="
    p "ERROR spawn PID - #{pid}"
    p "=============================================================================================================="

    p "APPLICATION PID - #{$PID}"

    p "class pid - #{pid.class}"

    p e.message

    msg = e.message

    return msg.to_s

  end


  WaitUtil.wait_for_condition('file exist',
                              :timeout_sec => 7200,
                              :delay_sec => 5) do
    File.exist?(data_file)
  end

  result = File.read(data_file)

  begin
     if File.exist?(data_file)
       File.delete(data_file)
     end
  rescue => e
    p e.message
    return e.message
  end

  p "detach process pid - #{pid}"

  Process.detach pid

  return result

end

post '/work/data_file' do

  data = request.body
  dir_path = 'C:/www/root/sinatra_1c_77/convert/data_upload/'
  data_file =  dir_path + SecureRandom.uuid.to_s + '.xml'

  File.open(data_file, 'w') do |f|
    f.puts(data.read)
  end

  p("begin upload #{Time.now}")
  get_connect

  convert = Convert.new(@V7,'','')
  convert.data_file = data_file
  convert.upload_data_file

  File.delete(data_file) if File.exist?(data_file)

  p("end upload #{Time.now}")

end

post '/work/data_documents/' do

  data = request.body

  dir_path = 'C:/www/root/sinatra_1c_77/convert/data_upload/'
  data_file =  dir_path + SecureRandom.uuid.to_s + '.json'

  File.open(data_file, 'w') do |f|
    f.puts(data.read)
  end

  p("begin upload #{Time.now}")

  get_connect

  convert = Convert.new(@V7,'','')
  convert.data_file = data_file
  data = convert.get_documents_list_json

  File.delete(data_file) if File.exist?(data_file)

  p("end upload #{Time.now}")

  begin
    convert.send_data_v8(data, "documents_data")
  rescue => e
    p e.message
  end

end

def get_connect
  conn = Application_v7.new
  conn.create
  conn.connect
  @V7 = conn.v7
end


