require 'json'
require 'C:\www\root\sinatra_1c_77\db\base.rb'

class Catalog
  def initialize (v7, name, owner = nil, code = nil)
    @owner = owner
    @name = name
    @V7 = v7
    @code = code
    @catalog = @V7.CreateObject("Справочник.#{name}")
    unless owner.nil?
      @catalog.ИспользоватьВладельца(owner)
    end
  end

  def use_owner
    @catalog.ИспользоватьВладельца(@owner)
  end

  def ref
    @catalog
  end

  def get_boolean (value = 0)
    value == 0 ? false : true
  end

  def crc
    value_str = object_in_string
    expr = 'РассчитатьКРК("' + value_str + '")'
    crc_value = @V7.EvalExpr(expr)
    crc_value
  end

  def object_in_string
    value = @V7.ЗначениеВСтрокуВнутр(@catalog.ТекущийЭлемент())
    value_str = value.gsub('"', '""')
    value_str
  end


end
