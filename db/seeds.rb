Ticket.destroy_all
Group.destroy_all
User.destroy_all

Ticket.create(:name => "FooBar1",
              :seat => "1A",
              :description => "Foo Bar 1",
              :group_id => 1)
Ticket.create(:name => "FooBar2",
              :seat => "1B",
              :description => "Foo Bar 2",
              :group_id => 1)
Ticket.create(:name => "FooBar3",
              :seat => "1C",
              :description => "Foo Bar 3",
              :group_id => 1)
Ticket.create(:name => "FooBar4",
              :seat => "1D",
              :description => "Foo Bar 4",
              :status => "resolved",
              :group_id => 1)
Ticket.create(:name => "FooBar5",
              :seat => "1E",
              :description => "Foo Bar 5",
              :status => "resolved",
              :group_id => 1)
Ticket.create(:name => "FooBar6",
              :seat => "1F",
              :description => "Foo Bar 6",
              :status => "resolved",
              :group_id => 1)
Ticket.create(:name => "FooBar7",
              :seat => "1G",
              :description => "Foo Bar 7",
              :status => "resolved",
              :group_id => 1)
Ticket.create(:name => "FooBar8",
              :seat => "1H",
              :description => "Foo Bar 8",
              :status => "resolved",
              :group_id => 1)

Group.create(:name => "thunder")
Group.create(:name => "shield")
User.create(:name => "John Smith", :msisdn => "07712345678")
User.create(:name => "Jane Doe", :msisdn => "07712345679")