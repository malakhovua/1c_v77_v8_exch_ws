class Pack
  def initialize (v7, owner)
    @V7 = v7
    @pack_com = @V7.CreateObject("Справочник.УМК_РазрешенныеВидыУпаковкиТМЦ")
    @pack_com.ИспользоватьВладельца(owner)
  end

  def ref
    @pack_com
  end

end
