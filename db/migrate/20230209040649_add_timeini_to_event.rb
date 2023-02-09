class AddTimeiniToEvent < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :timeIni, :time
    add_column :events, :timeEnd, :time
  end
end
