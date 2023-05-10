require 'sinatra'
require 'base64'
require 'stringio'
require 'date'
require 'time'
require 'securerandom'
require 'C:\www\root\sinatra_1c_77\com\1c_obj.rb'
require 'zip'
require 'C:\www\root\sinatra_1c_77\convert\convert.rb'
require 'C:\www\root\sinatra_1c_77\reports\report.rb'
require 'C:\www\root\sinatra_1c_77\db\base.rb'
require 'sinatra/base'
require 'waitutil'
require 'fileutils'
require 'logger'

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


#=====================convert=========================================================

# ===================GET DATA=========================================================
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

# ===================END GET DATA=========================================================

# ===================PUT DATA=============================================================
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
# ===================END PUT DATA=========================================================

# ===================GET REPORTS=============================================================

get '/work/reports/:report/:date1/:date2/:params' do

  get_connect

  period1 = @V7.StringToDate(params[:date1][0...10])
  period2 = @V7.StringToDate(params[:date2][0...10])

  param = JSON.parse(params[:params])

  begin
    report = Report.new(@V7, period1, period2, param)
    result = report.public_send(params[:report])
  rescue => e
    result ="{error:#{e.message}}"
  end
  return result
end

# ===================END GET REPORTexitS=========================================================

def get_connect
  conn = Application_v7.new
  conn.create
  conn.connect
  @V7 = conn.v7
end


