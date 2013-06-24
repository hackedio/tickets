class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.integer :position
      t.string :seat
      t.text :description
      t.string :status

      t.timestamps
    end
  end
end
