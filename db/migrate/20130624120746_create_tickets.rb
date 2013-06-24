class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.integer :ticket_no
      t.string :seat
      t.text :description
      t.string :msisdn
      t.string :status, :null => false, :default => "waiting"

      t.timestamps
    end
  end
end
