import 'package:flutter/material.dart';

class Flight {
  // dummy flights daha sonra admin panelden oluşturulacak
  final String no;
  final String Company;
  final bool isIndirect;
  final String duration;
  final DateTime departureDate;
  final DateTime arrivalDate;
  final String info;

  Flight(this.no, this.Company, this.isIndirect, this.duration,
      this.departureDate, this.arrivalDate, this.info);
}
