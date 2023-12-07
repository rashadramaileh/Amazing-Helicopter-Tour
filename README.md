# Amazing-Helicopter-Tour

Database tied to FARMS database. For CS 3550

Amazing Helicopter Tours Service

Fancy Properties is now partnering with Amazing Helicopter Tours. They are adding tours to each of their three hotel locations. Due to being separate entities Amazing Helicopter tours will use their own billing system. Customers don’t have to be staying at the hotel to book a tour. Customers can book multiple tours if they want to. There will be multiple routes using multiple helicopters at different times throughout the day. Some helicopters will have larger capacity for bigger tours.

The CharterPrice is calculated by the helicopter rate plus the route rate divided by the capacity of the helicopter.

Route rate is calculated by distance times a set number.

If our customer is a guest at one of the Fancy Properties hotels we will apply a discount

Customers ID will start at 3000 and increment by 1

Reservations ID will start at 6000 and increment by 1

Each route will connect to the local hotel ID

There will also be coupon discounts and discounts for multiple reservations

The bill for the charter is calculated by multiplying the GuestCount by the CharterPrice

Each helicopter has a range for a single tank of gas and a capacity for guests

A tour will have a status to indicate if there are seats available based on the capacity of the helicopter. (“F”, “P”, “E”)

F: Full P: Partial E: Empty

Each Reservation and FlightCharter will have a status (“R”, “A”, “C” or “X”)

R: Reserved A: Active C: Completed or canceled with fee X: Canceled without fee

Cancellations must be made 48 hours (from 8 am) in advance of the tour date.

Canceling more than 48 hours prior to tour date have no fee

Canceling from 24 - 48 hours prior to tour date will have a 50% tour fee

Canceling less than 24 hours prior to tour date will have an 80% tour fee

As a business rule we ask the customer to show up 30 minutes prior to take off.

If the customer fails to show up for the tour they will be charged 100% of the tour price.

If the customer shows up after 30 minutes prior to take take off but before the helicopter takes off, they will be charged a 10% late fee
