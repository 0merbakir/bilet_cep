import 'package:bilet_cep/utils/r.dart';
import 'package:bilet_cep/screens/home/widgets/custom_flutter_logo.dart';
import 'package:bilet_cep/screens/home/widgets/fade_in_out_widget.dart';
import 'package:bilet_cep/screens/home/widgets/fade_in_out_widget_controller.dart';
import 'package:flutter/material.dart';

import 'package:bilet_cep/model/flight_data.dart';
import 'package:bilet_cep/model/ticket.dart';

const List<int> freeSeats = [1, 4, 7, 10, 13, 16, 20];
final List<SeatData> leftSideSeats = List.generate(
  20,
  (index) =>
      SeatData("${index + 1}" "A", freeSeats.contains(index) ? true : false),
);
final List<SeatData> rightSideSeats = List.generate(
  20,
  (index) =>
      SeatData("${index + 1}" "B", freeSeats.contains(index) ? true : false),
);

class SeatSelectionPage extends StatefulWidget {
  final FlightData flightData;
  final Function(bool, FlightData)? isSelectionCompleted;
  const SeatSelectionPage({
    Key? key,
    required this.flightData,
    this.isSelectionCompleted,
  }) : super(key: key);

  @override
  State<SeatSelectionPage> createState() => _SeatSelectionPageState();
}

class _SeatSelectionPageState extends State<SeatSelectionPage> {
  late final ValueNotifier<SeatData?> _selectedSeat;
  late final FadeInOutWidgetController _fadeInOutWidgetController;

  @override
  void initState() {
    super.initState();
    _selectedSeat = ValueNotifier(null);
    _fadeInOutWidgetController = FadeInOutWidgetController();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: R.primaryColor,
        appBar: AppBar(
          backgroundColor: Color(0xFF526799),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 24.0, top: 50.0, right: 12.0, bottom: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [ 
                _buildPlaneWithSeatOptions(),
                _buildFlightInfoColumn(),
              ],
            ),
          ),
        ),
      );

  Widget _buildFlightInfoColumn() => Padding(
        padding: EdgeInsets.only(top: 60, left: 12, right: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Kalkış",
              style: TextStyle(color: R.secondaryColor, fontSize: 18.0),
            ),
            Text(
              widget.flightData.departure,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 26.0),
            Icon(
              Icons.flight_land,
              color: R.secondaryColor,
              size: 32.0,
            ),
            Text(
              widget.flightData.duration,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 26.0),
            Text(
              "Varış",
              style: TextStyle(color: R.secondaryColor, fontSize: 18.0),
            ),
            Text(
              widget.flightData.destination,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 26.0),
            Text(
              "Uçuş No",
              style: TextStyle(color: R.secondaryColor, fontSize: 18.0),
            ),
            Text(
              widget.flightData.flightNumber,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 26.0),
            Text(
              "Koltuklar",
              style: TextStyle(color: R.secondaryColor, fontSize: 18.0),
            ),
            FadeInOutWidget(
              fadeInOutWidgetController: _fadeInOutWidgetController,
              initialVisibilityValue: false,
              child: ValueListenableBuilder<SeatData?>(
                valueListenable: _selectedSeat,
                builder: (_, seat, __) => Text(
                  seat?.id ?? "",
                  style: TextStyle(color: R.secondaryColor, fontSize: 18.0),
                ),
              ),
            ),
            const Text(
              "21 - 23 - 25 - 32", // dinamik ve kaydırılabilir olmalı
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );

  Widget _buildPlaneWithSeatOptions() => LayoutBuilder(
        builder: (
          context,
          constraints,
        ) =>
            ClipPath(
          clipper: PlaneClipper(),
          child: Container(
            color: R.tertiaryColor.withOpacity(0.5),
            height: constraints.maxHeight,
            width: 225,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 50.0,
                  ),
                  const CustomFlutterLogo(
                    size: 40.0,
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    "${widget.flightData.date} , ${widget.flightData.time}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 32.0,
                  ),
                  Text(
                    "Business Class",
                    style: TextStyle(
                      color: R.secondaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 2,
                          child: _buildSeatsGrid(leftSideSeats),
                        ),
                        const Spacer(
                          flex: 1,
                        ),
                        Expanded(
                          flex: 2,
                          child: _buildSeatsGrid(rightSideSeats),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 50),
                  Text(
                    "Economy Class",
                    style: TextStyle(
                      color: R.secondaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 2,
                          child: _buildSeatsGrid(leftSideSeats),
                        ),
                        const Spacer(
                          flex: 1,
                        ),
                        Expanded(
                          flex: 2,
                          child: _buildSeatsGrid(rightSideSeats),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  Widget _buildSeatsGrid(List<SeatData> seats) => GridView.builder(
        shrinkWrap: true,
        itemCount: seats.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2 / 3,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
        ),
        itemBuilder: (_, i) => ValueListenableBuilder<SeatData?>(
          valueListenable: _selectedSeat,
          builder: (_, value, __) {
            return GestureDetector(
              onTap: () {
                if (!seats[i].isBooked) {
                  if (_selectedSeat.value != null) {
                    _fadeInOutWidgetController.hide();
                    Future.delayed(const Duration(milliseconds: 300),
                        () => _selectedSeat.value = seats[i]).whenComplete(
                      () => _fadeInOutWidgetController.show(),
                    );
                  } else {
                    _selectedSeat.value = seats[i];
                    _fadeInOutWidgetController.show();
                  }
                  widget.isSelectionCompleted?.call(
                    true,
                    widget.flightData.copyWith(
                      seat: _selectedSeat.value!.id,
                    ),
                  );
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: _isSeatSelected(seats[i])
                      ? R.secondaryColor
                      : Colors.transparent,
                  border: Border.all(
                    color:
                        seats[i].isBooked ? R.tertiaryColor : R.secondaryColor,
                  ),
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            );
          },
        ),
      );

  bool _isSeatSelected(SeatData? seat) {
    if (_selectedSeat.value == null) {
      return false;
    }
    return seat?.id == _selectedSeat.value?.id;
  }
}

class PlaneClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(10, size.height);
    path.lineTo(0, size.height / 2.3);

    path.quadraticBezierTo(size.width / 5, 0, size.width / 2, 0);
    path.quadraticBezierTo(
        size.width - size.width / 5, 0, size.width, size.height / 2.3);
    path.lineTo(size.width - 10, size.height);
    path.lineTo(0, size.height);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

class SeatData {
  final String id;
  final bool isBooked;

  SeatData(this.id, this.isBooked);
}
