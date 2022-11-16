require 'sequel'
require 'C:\www\root\sinatra_1c_77\path.rb'

class Base

  def initialize
    @path = Path.new
    @db = Sequel.connect(adapter: :postgres, user: @path.pg_path[:usr],
                         password: @path.pg_path[:pw], host: @path.pg_path[:host],
                         port:  @path.pg_path[:port],database: @path.pg_path[:db],
                         max_connections: 10)
  end

  def create_db
    @db.create_table :documents_crc do
      column :date,  DateTime
      column :doc_date, Date
      column :doc_number, String
      column :doc_type, String
      column :doc_type_number, Integer
      column :active, Integer, :default=> 0
      column :document, String
      column :crc, String
    end
  end

  def insert_crc (date, doc_date, active, document, crc, doc_number, doc_type, doc_type_number)
    table = @db[:documents_crc]
    table.insert(date: date, doc_date: doc_date, active: active, document: document, doc_number: doc_number,
                 doc_type: doc_type, crc: crc, doc_type_number: doc_type_number)
  end


  def crc_active (number, doc_type_number, crc)
    @db[:documents_crc][{active: 1, doc_number:number, doc_type_number:doc_type_number, crc:crc}]
  end

  def update_crc_records (doc_type_number)
    @db[:documents_crc].where(:doc_type_number=>doc_type_number, :active=>0).update(active: 1)
  end

end
