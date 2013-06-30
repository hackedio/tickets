#Help Tickets for Hacked

A system to allow attendees to raise tickets for help during the event


####Setup:
* Go to '/groups' URL and set up the groups (e.g. THUNDER, HEROES, HERALD etc...)
* For each group, on the same URL, click the dropdown button and add members, along with their mobile number.
* That's it. Now when a ticket is raised by an attendee, all members of the appropriate group will receive an SMS containing details of attendee ticket number, name, seat and a URL link for further details of the problem.

####Attendee form
* Currently, there is a stub at _/get-help_. 
* The form is currently being submitted via AJAX. If the ticket form is to be on a separate domain, then a new solution will be required.
* The group to receive the SMS is determined by a set of radio buttons on the bottom of the form which will be selected by the attendee (e.g. software issue, hardware issue, misc.).
* The "value" of each radio button should represent the group that deals with that kind of issue... e.g. "THUNDER", "HEROES" etc... 
* __NOTE: the above point is important as a ticket will not be created unless a correct group name is sent through. Make sure that the group exists before setting a radio button value as the name of that group.__

####Viewing all tickets
* Go to _/tickets_ to view all tickets.
* Click the "waiting" tab to see all tickets that are waiting to be resolved.
* Click the "resolved" tab to view all old tickets that have already been resolved.

###Environment Variables:

The environment variables needed for this app to work are as follows:

* TWILIO_ACCOUNT_SID
* TWILIO_AUTH_TOKEN
* TWILIO_HACKED_NO _(the twilio phone number used to send the messages)_
* HACKED_HELP_TICKET_URL _(root URL that this will be hosted on, e.g. http://hackedhelptickets.com)_
