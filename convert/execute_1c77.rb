require 'date'
require 'win32ole'
require 'securerandom'
require 'C:\www\root\sinatra_1c_77\path.rb'
require 'fileutils'

rule = ARGV[0]
date1 = ARGV[1]
date2 = ARGV[2]
period = ARGV[3]
update = ARGV[4] == "update_" ? 1 : 0
code = ARGV[5] == "empty" ? '' : ARGV[5].to_s
data_file = ARGV[6]
path = Path.new

str = path.v7_path

begin
  v7 = WIN32OLE.new('V77.Application')
rescue => e
  p "=============================================================================================================="
  p "Ошибка открытия базы 1с 77"
  p e.message
  p "=============================================================================================================="
  FileUtils.touch(data_file)
  exit
end

v7.Initialize(v7.RMTrade, str, '"NO_SPLASH_SHOW"')

path = 'C:\www\root\sinatra_1c_77\convert\V77Exp.ert'

#  FileUtils.cp path, new_path

ruleFileName = 'C:\www\root\sinatra_1c_77\convert\rules\rules.xml'
dataFileName = data_file

nameCommand = 'Выгрузить'
usedRulesUnloading = rule
commentUnloadingObjects = 1

begin
  tableSettingsParameters = v7.CreateObject('СписокЗначений')
rescue => e
  p "=============================================================================================================="
  p "ошибка создания списка параметров"
  p e.message
  p "=============================================================================================================="
  FileUtils.touch(data_file)
  exit
end

tableSettingsParameters.ДобавитьЗначение(period, 'ПериодВыгрузки')
tableSettingsParameters.ДобавитьЗначение(update, 'Обновлять')
tableSettingsParameters.ДобавитьЗначение(code, 'Код')

parameterList = v7.CreateObject('СписокЗначений')
parameterList.ДобавитьЗначение(ruleFileName, 'ИмяФайлаПравил')
parameterList.ДобавитьЗначение(dataFileName, 'ИмяФайлаДанных')
parameterList.ДобавитьЗначение(date1, 'ДатаНачала')
parameterList.ДобавитьЗначение(date2, 'ДатаОкончания')
parameterList.ДобавитьЗначение(tableSettingsParameters, 'ТаблицаНастройкиПараметров')
parameterList.ДобавитьЗначение(commentUnloadingObjects, 'КомментироватьВыгрузкуОбъектов')
parameterList.ДобавитьЗначение(usedRulesUnloading, 'ИспользуемыеПравилаВыгрузки')
parameterList.ДобавитьЗначение(nameCommand, 'ИмяКоманды')
#ParameterList.ДобавитьЗначение(ИмяАлгоритма,'ИмяАлгоритма')


begin
v7.ОткрытьФормуМодально('Отчет', parameterList, path)
rescue => e
  p "=============================================================================================================="
  p "ошибка открытия формы выгрузки 1с 77"
  p e.message
  p "=============================================================================================================="
  FileUtils.touch(data_file)
  exit
end



