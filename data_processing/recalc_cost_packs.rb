require 'C:\www\root\sinatra_1c_77\com\1c_obj.rb'
require 'C:\www\root\sinatra_1c_77\path.rb'

class Recalc_cost_packs

  def initialize
  end

  def execute
    conn = Application_v7.new
    conn.create
    conn.connect
    @v7 = conn.v7
    path = Path.new

    data_processor_path =  path.project_path + '\data_processing\recalc_cost_packs.ert' #(Dir.pwd + '/recalc_cost_packs.ert').gsub(/\\/,'/')
    log_path = path.project_path + '\data_processing\recalc_cost_packs.csv'#(Dir.pwd + '/recalc_cost_packs.csv').gsub(/\\/,'/')

    parameterList = @v7.CreateObject('СписокЗначений')
    parameterList.ДобавитьЗначение(1,'perform_data_processing')
    parameterList.ДобавитьЗначение(log_path, 'log_path')


    @v7.ОткрытьФорму('Отчет',parameterList , data_processor_path)
    @v7.ExecuteBatch("ЗавершитьРаботуСистемы()")


  end


end