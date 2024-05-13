require 'win32ole'
require 'C:\www\root\sinatra_1c_77\path.rb'

class Application_v7

attr_accessor :v7

  def initialize(v7 = nil)
    @path = Path.new
    @v7 = v7
  end 
 
 def create
 @v7 = WIN32OLE.new('V77.Application')
 end
 
def connect 
  str = @path.v7_path
  @v7.Initialize(@v7.RMTrade,str)#,'"NO_SPLASH_SHOW"')
 end

end

