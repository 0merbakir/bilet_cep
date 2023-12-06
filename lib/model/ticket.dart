import 'package:flutter/material.dart';

class Ticket {
  final String nameSurname;
  final String gender;
  final String birthDate;
  final String tcNo;
  final String? flightNo;
  final String? classType;
  final String? seat;
  String? phoneNumber;

  Ticket.adult(
      {required this.nameSurname,
      required this.gender,
      required this.birthDate,
      required this.tcNo,
      required this.phoneNumber,
      this.classType,
      this.seat,
      this.flightNo});
  Ticket.child({
    required this.nameSurname,
    required this.gender,
    required this.birthDate,
    required this.tcNo,
    this.classType,
    this.seat,
    this.flightNo,
  });
}
