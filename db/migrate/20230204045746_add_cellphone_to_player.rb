class AddCellphoneToPlayer < ActiveRecord::Migration[7.0]
  def change
    add_column :players, :cellphone, :string
  end
end
