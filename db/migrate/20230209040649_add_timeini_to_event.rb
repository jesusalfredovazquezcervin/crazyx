class AddTimeiniToEvent < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :timeIni, :date
    add_column :events, :timeEnd, :date
  end
end
