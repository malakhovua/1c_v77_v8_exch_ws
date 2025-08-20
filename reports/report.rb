require 'date'
require 'time'
require 'json'

class Report
  def initialize (v7, period1, period2, params)
    @V7, @period1, @period2, @params = v7, period1, period2, params
  end

  def get_prices

    #1c 7.7 query
    catalog = @V7.CreateObject("Справочник.ТМЦ")
    tabeleValue = @V7.CreateObject("ValueTable");

    if catalog.FindByCode(@params['catalog']) == 0
      return
    end
    cont = @V7.CreateObject('ValueList')
    cont.AddValue(catalog.CurrentItem())
    cont.AddValue(@params['price'])

    query = @V7.CreateObject("Query")

    text = "//{{ЗАПРОС()
	  ОбрабатыватьДокументы все;
	  owner_ = Справочник.Цены.Владелец;
	  owner = Справочник.Цены.Владелец.Код;
	  price_ = Справочник.Цены.ТекущийЭлемент;
	  price_type = Справочник.Цены.КатегорияЦены.ТекущийЭлемент.Код;
	  Группировка owner_ без групп;
	  Группировка owner без групп;
	  Группировка price_;
	  Группировка price_type;
	  Условие(owner_ В cont.GetValue(1));
	  Условие(price_type = cont.GetValue(2));"

    if @V7.ExcQuery(query, text, cont) == 0
      return ""
    end

    if @V7.GetTableValueFromQuery(query, tabeleValue) == 0
      return
    end

    tabeleValue.SelectLines()

    itemsArray = []

    while tabeleValue.GetLine() == 1 do
      itemsArray << { :owner => tabeleValue.owner, :price_type => tabeleValue.price_type, :price => tabeleValue.price_.Цена.GetValue(@period2)}
    end

    return itemsArray.to_json

  end

  def get_order_fact_weight

    rs = @V7.CreateObject("ODBCRecordset");
    textQuery = "SELECT Sum($УМК_ЗаказКлиентаСтроки.КвоФакт) СуммаКвоФакт
    FROM $ДокументСтроки.УМК_ЗаказКлиента AS УМК_ЗаказКлиентаСтроки
    INNER JOIN _1SJOURN AS Журнал ON УМК_ЗаказКлиентаСтроки.IDDOC = Журнал.IDDOC
    WHERE (Журнал.DATE_TIME_IDDOC >= :data1)
    AND (Журнал.DATE_TIME_IDDOC <= :data2~)
    AND (Журнал.DOCNO = :doc_number)"
    rs.SetTextParam("data1", @period1);
    rs.SetTextParam("data2", @period2);
    rs.SetTextParam("doc_number", @params['doc_number']);

    return rs.ExecuteScalar(textQuery).to_json

  end

end
