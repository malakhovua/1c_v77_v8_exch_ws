require 'time'
require 'C:\www\root\sinatra_1c_77\data_processing\post_documents.rb'
require 'C:\www\root\sinatra_1c_77\data_processing\recalc_cost_packs.rb'

loop do

  if DateTime.now.hour.to_s + "-" + DateTime.now.minute.to_s + "-" +  DateTime.now.second.to_s  == '21-0-0'
    p 'post documents ' + DateTime.now.to_s
    post = Post_documents.new
    post.execute
    p 'end post documents. ' + DateTime.now.to_s
  end

  if DateTime.now.hour.to_s + "-" + DateTime.now.minute.to_s + "-" +  DateTime.now.second.to_s  == '20-35-0'
    p 'recalculate cost packs ' + DateTime.now.to_s
    recalc = Recalc_cost_packs.new
    recalc.execute
    p 'end recalculate cost packs. ' + DateTime.now.to_s
  end

end