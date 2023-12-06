import 'package:flutter/material.dart';

class Flight {
  // dummy flights daha sonra admin panelden oluşturulacak
  final String no;
  final String duration;
  final String departureDate;
  final String info;
  final String arrivalDate;

  Flight(this.no, this.duration, this.departureDate, this.arrivalDate, this.info);
}
