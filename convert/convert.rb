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

end
