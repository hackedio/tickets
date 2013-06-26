Ticket.destroy_all
Group.destroy_all
Ticket.create(:msisdn => "447712345678",
              :seat => "1A",
              :description => "Foo Bar 1")
Ticket.create(:msisdn => "447712345679",
              :seat => "1B",
              :description => "Foo Bar 2")
Ticket.create(:msisdn => "447712345670",
              :seat => "1C",
              :description => "Foo Bar 3")
Ticket.create(:msisdn => "447712345671",
              :seat => "1D",
              :description => "Foo Bar 4",
              :status => "pending")
Ticket.create(:msisdn => "447712345672",
              :seat => "1E",
              :description => "Foo Bar 5",
              :status => "pending")
Ticket.create(:msisdn => "447712345673",
              :seat => "1F",
              :description => "Foo Bar 6",
              :status => "pending")
Ticket.create(:msisdn => "447712345674",
              :seat => "1G",
              :description => "Foo Bar 7",
              :status => "complete")
Ticket.create(:msisdn => "447712345675",
              :seat => "1H",
              :description => "Foo Bar 8",
              :status => "complete")

Group.create(:name => "thunder")
Group.create(:name => "shield")