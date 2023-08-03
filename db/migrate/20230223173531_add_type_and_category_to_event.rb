class AddTypeAndCategoryToEvent < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :mixed, :boolean #Indicates the type of the event: Fixed Couples or Mixed Couples. This helps to generate the round robin in different ways.
    add_column :events, :level, :integer 
  end
end
