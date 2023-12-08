import 'package:flutter/material.dart';

class FlightInfoOverlayWidget extends StatefulWidget {
  final String no;
  final String company;
  final bool isIndirect;
  final String duration;
  final DateTime departureDate;
  final DateTime arrivalDate;
  final String info;

  FlightInfoOverlayWidget({
    required this.no,
    required this.company,
    required this.isIndirect,
    required this.duration,
    required this.departureDate,
    required this.arrivalDate,
    required this.info,
  });

  @override
  _FlightInfoOverlayWidgetState createState() =>
      _FlightInfoOverlayWidgetState();
}

class _FlightInfoOverlayWidgetState extends State<FlightInfoOverlayWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Automatically open the overlay
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: Transform.scale(
            scale: _animation.value,
            child: child,
          ),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white.withOpacity(0.8), // Background color
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 300,
              height: 400,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Flight Information',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                    thickness: 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('No: ${widget.no}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Company: ${widget.company}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Is Indirect: ${widget.isIndirect}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Duration: ${widget.duration}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Departure Date: ${widget.departureDate}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Arrival Date: ${widget.arrivalDate}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Info: ${widget.info}'),
                  ),
                  Spacer(),
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: () {
                        _animationController.reverse().whenComplete(() {
                          Navigator.of(context).pop();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blueAccent,
                      ),
                      child: Text('Close'),
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}


