require 'C:\www\root\sinatra_1c_77\com\1c_obj.rb'
require 'C:\www\root\sinatra_1c_77\path.rb'

class Post_documents

  def initialize
  end

  def execute
    conn = Application_v7.new
    conn.create
    conn.connect
    @v7 = conn.v7
    path = Path.new

    data_processor_path = path.project_path + '\data_processing\post_documents.ert'  #(Dir.pwd + '/post_documents.ert').gsub(/\\/,'/')
    log_path = path.project_path + '\data_processing\log_post_documents.csv'#(Dir.pwd + '/log_post_documents.csv').gsub(/\\/,'/')
    log_path = log_path

    documentsList = @v7.CreateObject('СписокЗначений')

    documents = %w(ВозвратнаяНакладная
    ВозвратПоставщику
    ВозвратТМЦИзПроизводства
    ВыпускПродукции
    ОприходованиеИзлишков
    Перемещение
    ПереработкаМяса
    ПриходнаяНакладнаяЗапасы
    ПриходнаяНакладнаяПрочие
    РасходнаяНакладная
    СписаниеТМЦ
    СписаниеТМЦВПроизводство
    СхемаРасчетаЗП
    УМК_КассоваяВедомость
    УМК_КассоваяВедомостьРасходная
    УМК_ПерезачетСписком
    БанковскаяВыписка
    РасходныйКассовый
    ПриходныйКассовый)

    documents.each { |doc| documentsList.ДобавитьЗначение(doc, doc)}

    parameterList = @v7.CreateObject('СписокЗначений')
    parameterList.ДобавитьЗначение(documentsList,'documentsList')
    parameterList.ДобавитьЗначение(1,'perform_data_processing')
    parameterList.ДобавитьЗначение(log_path, 'log_path')
    parameterList.ДобавитьЗначение(10, 'pause_doc')
    parameterList.ДобавитьЗначение(3, 'time_pause_doc')
    parameterList.ДобавитьЗначение(3, 'attempts')
    parameterList.ДобавитьЗначение(15, 'time_attempts')
    parameterList.ДобавитьЗначение(1, 'control_balances')


    @v7.ОткрытьФорму('Отчет',parameterList , data_processor_path)
    @v7.ExecuteBatch("ЗавершитьРаботуСистемы()")


  end


end