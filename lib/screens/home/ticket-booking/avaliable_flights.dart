import 'package:bilet_cep/model/flight_data.dart';
import 'package:bilet_cep/screens/home/ticket-booking/seat_selection.dart';
import 'package:flutter/material.dart';

import 'package:bilet_cep/model/ticket.dart';
import 'package:bilet_cep/model/flight.dart';

class AvailableFlightsPage extends StatefulWidget {
  // final List<Ticket> tickets;
  // final DateTime? arrivalDate;
  final DateTime departureDate  = DateTime.now();
  // final int baggage;
  AvailableFlightsPage(
      {Key? key,
      // required this.tickets,
      // required this.arrivalDate,
      // required this.departureDate,
      // required this.baggage
      });

  @override
  State<AvailableFlightsPage> createState() => _AvailableFlightsPageState();
}

class _AvailableFlightsPageState extends State<AvailableFlightsPage> {
  String selectedDateIndex = DateTime.now().day.toString();

  // Dummy flight information   // buradan devam
  List<Flight> dummyFlights = [
    Flight('10', '2h', DateTime.now().day.toString(), '11.08.2023',
        'A flight info'),
    Flight('10', '2h', DateTime.now().day.toString(), '11.08.2023',
        'A flight info'),
    Flight('10', '2h', DateTime.now().day.toString(), '11.08.2023',
        'A flight info'),
    Flight('10', '2h', DateTime.now().day.toString(), '11.08.2023',
        'A flight info'),
    Flight('10', '2h', DateTime.now().day.toString(), '11.08.2023',
        'A flight info'),

    // Add more dummy flights as needed
  ];

  @override
  Widget build(BuildContext context) {
    List<Flight> filteredFlights = dummyFlights
        .where((flight) => flight.departureDate.toString() == selectedDateIndex)
        .toList();

    return Scaffold(
      backgroundColor:
          Colors.white, // Set the primary color as the background color
      appBar: AppBar(
        backgroundColor:
            Color(0xFF526799), // Use the primary color for the app bar
      ),
      body: Column(
        children: [
          // Dates Section
          Container(
            height: 75,
            padding: EdgeInsets.only(right: 10, left: 10),
            margin: EdgeInsets.symmetric(vertical: 20),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.departureDate!.day.toInt(),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDateIndex = DateTime.now().day.toString();
                    });
                  },
                  child: Container(
                    width: 75,
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: index == selectedDateIndex
                          ? Colors.white
                          : Color(0xFF526799),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        'Date ${index + 1}',
                        style: TextStyle(
                          color: index == selectedDateIndex
                              ? Color(0xFF526799)
                              : Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Flight Information Section
          Expanded(
            child: Container(
              padding: EdgeInsets.only(right: 10, left: 10),
              child: ListView.builder(
                itemCount: filteredFlights.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListTile(
                        title: Text(
                          'Flight Info ${filteredFlights[index].no}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color(0xFF526799),
                          ),
                        ),
                        subtitle: Text(
                          '${filteredFlights[index].info}',
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          IconButton(
              onPressed: () {
                   // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => SeatSelectionPage(
                      //       flightData: FlightData(
                      //           departureShort: "departureShort",
                      //           departure: "departure",
                      //           date: "date",
                      //           destinationShort: "destinationShort",
                      //           destination: "destination",
                      //           flightNumber: "flightNumber",
                      //           duration: "duration",
                      //           time: "time"),
                      //     ),
                      //   ),
                      // );
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (ctx) => SeatSelectionPage(
                            flightData: FlightData(
                                departureShort: 'departureShort',
                                departure: 'departure',
                                date: 'date',
                                destinationShort: 'destinationShort',
                                destination: 'destination',
                                flightNumber: 'flightNumber',
                                duration: 'duration',
                                time: 'time'))));
              },
              icon: Icon(Icons.skip_next))
        ],
      ),
    );
  }
}
