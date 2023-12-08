import 'package:bilet_cep/db/ticket_list.dart';
import 'package:bilet_cep/model/flight_data.dart';
import 'package:bilet_cep/screens/home/ticket-booking/seat_selection.dart';
import 'package:flutter/material.dart';

import 'package:bilet_cep/model/ticket.dart';
import 'package:bilet_cep/model/flight.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:bilet_cep/screens/home/widgets/flight_info_overlay.dart';

class AvailableFlightsPage extends StatefulWidget {
  final List<Ticket> tickets;
  final String arrival;
  final String departure;
  final DateTime goDate;
  DateTime? backDate;
  final int baggage;

  AvailableFlightsPage(
      {Key? key,
      required this.tickets,
      required this.arrival,
      required this.departure,
      required this.goDate,
      this.backDate,
      required this.baggage});

  @override
  State<AvailableFlightsPage> createState() => _AvailableFlightsPageState();
}

class _AvailableFlightsPageState extends State<AvailableFlightsPage> {
  late ScrollController _dateListController;
  int selectedDateIndex = 0;

  List<Flight> dummyFlights = [
    Flight('10', 'Pegasus', true, '3', DateTime.now(), DateTime.now(),
        'A flight info'),
    Flight('10', 'Pegasus', true, '3', DateTime.now(), DateTime.now(),
        'A flight info'),
    Flight('10', 'Pegasus', true, '3', DateTime.now(), DateTime.now(),
        'A flight info'),
    Flight('10', 'Pegasus', true, '3', DateTime.now(), DateTime.now(),
        'A flight info'),
    Flight('10', 'Pegasus', true, '3', DateTime.now(), DateTime.now(),
        'A flight info'),
    Flight('10', 'Pegasus', true, '3', DateTime.now(), DateTime.now(),
        'A flight info'),
    Flight('10', 'Pegasus', true, '3', DateTime.now(), DateTime.now(),
        'A flight info'),
  ];

  @override
  void initState() {
    super.initState();
    selectedDateIndex = widget.goDate.day;
    _dateListController = ScrollController();
    _scrollToSelectedDate();
  }

  void _scrollToSelectedDate() {
    if (_dateListController.hasClients) {
      double scrollOffset =
          selectedDateIndex * 15.0; // Adjust based on your item width
      _dateListController.animateTo(
        scrollOffset,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void checkData() {
    for (int i = 0; i < widget.tickets.length; i++) {
      print({widget.tickets[i].toString()});
    }
    print(widget.arrival);
    print(widget.departure);
    print(widget.goDate.toString());
    print(widget.backDate.toString());
    print(widget.baggage);
  }

  @override
  Widget build(BuildContext context) {
    List<Flight> filteredFlights = dummyFlights
        .where((flight) => flight.departureDate.day == selectedDateIndex)
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF526799),
      ),
      body: Column(
        children: [
          Container(
            height: 75,
            padding: EdgeInsets.only(right: 10, left: 10),
            margin: EdgeInsets.symmetric(vertical: 20),
            child: ListView.builder(
              controller: _dateListController,
              scrollDirection: Axis.horizontal,
              itemCount: 15,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDateIndex = index;
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(
                            '${selectedDateIndex + index}',
                            style: TextStyle(
                              color: index == selectedDateIndex
                                  ? Color(0xFF526799)
                                  : Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            'cum',
                            style: TextStyle(
                              color: index == selectedDateIndex
                                  ? Color(0xFF526799)
                                  : Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            height: 520,
            child: Container(
              height: 500,
              padding: EdgeInsets.only(right: 10, left: 10),
              child: ListView.builder(
                itemCount: filteredFlights.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Expanded(
                        child: Padding(
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
                                '${filteredFlights[index].Company}, ${filteredFlights[index].duration} saat ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Color(0xFF526799),
                                ),
                              ),
                              subtitle: Text(
                                filteredFlights[index].isIndirect
                                    ? "Aktarmalı "
                                    : " Aktarmasız",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black),
                              ),
                              onTap: () {
                                // go seatScreen
                              },
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return FlightInfoOverlayWidget(
                                no: '123',
                                company: 'Example Company',
                                isIndirect: true,
                                duration: '2 hours',
                                departureDate: DateTime.now(),
                                arrivalDate:
                                    DateTime.now().add(Duration(hours: 2)),
                                info: 'Additional information',
                              );
                            },
                          );
                        },
                        icon: Icon(Icons.info),
                        color: Color(0xFF526799),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          const Gap(50),
          Container(
            margin: EdgeInsets.only(left: 250),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF526799), // Button background color
                onPrimary: Color.fromARGB(237, 252, 252, 252), // Text color
                padding: EdgeInsets.all(16), // Padding around the button text
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(90), // Button border radius
                ),
              ),
              onPressed: () {
                checkData();
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
              child: SvgPicture.asset("assets/icons/arrow_right.svg"),
            ),
          ),
        ],
      ),
    );
  }
}
