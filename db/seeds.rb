Ticket.destroy_all
Ticket.create(:msisdn => "447712345678",
              :seat => "1A",
              :description => "Foo Bar 1")
Ticket.create(:msisdn => "447712345679",
              :seat => "1B",
              :description => "Foo Bar 2")
Ticket.create(:msisdn => "447712345670",
              :seat => "1C",
              :description => "Foo Bar 3")