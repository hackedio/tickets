class RenameTicketsMsisdnToName < ActiveRecord::Migration
  def up
    remove_column :tickets, :msisdn
    add_column :tickets, :name, :string
  end

  def down
    remove_column :tickets, :name
    add_column :tickets, :msisdn, :string
  end
end
