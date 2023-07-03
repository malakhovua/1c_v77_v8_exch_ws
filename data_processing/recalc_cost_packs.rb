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

    data_processor_path =  (Dir.pwd + '/recalc_cost_packs.ert').gsub(/\\/,'/')

    parameterList = @v7.CreateObject('СписокЗначений')
    parameterList.ДобавитьЗначение(1,'perform_data_processing')


    @v7.ОткрытьФорму('Отчет',parameterList , data_processor_path)
    @v7.ExecuteBatch("ЗавершитьРаботуСистемы()")


  end


end