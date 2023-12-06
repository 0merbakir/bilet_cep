import 'package:bilet_cep/model/ticket.dart';
import 'package:flutter/material.dart';
import 'package:bilet_cep/utils/app_styles.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:bilet_cep/model/ticket.dart';
import 'package:flutter_svg/svg.dart';
import 'package:bilet_cep/utils/app_layout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bilet_cep/screens/home/ticket-booking/seat_selection.dart';

import 'package:bilet_cep/model/flight_data.dart';
import 'package:bilet_cep/screens/home/ticket-booking/avaliable_flights.dart';

class PassengersInfo extends StatefulWidget {
  PassengersInfo(
      {super.key,
      required this.arrival,
      required this.departure,
      required this.isOneDirection});

  final String arrival;
  final String departure;
  final bool isOneDirection;

  @override
  State<PassengersInfo> createState() => _PassengersInfoState();
}

class _PassengersInfoState extends State<PassengersInfo> {
  String _enteredNameSurname = "";
  String _enteredTcNo = "";
  DateTime? _enteredDate;
  String _enteredPhoneNumber = "";
  var _enteredGender;

  List<bool> isMaleAdult = [false];
  List<bool> isMaleChild = [false];
  List<bool> isFemaleAdult = [false];
  List<bool> isFemaleChild = [false];

  var adultCount = 0;
  var childCount = 0;

  DateTime? arrivalDate = DateTime.now(); // daha sonra değişecek
  DateTime departureDate = DateTime.now();
  int baggage = 0;

  final List<Ticket> tickets = [];
  // Yolcu bilgilerini tutan liste

  List<TextEditingController> _nameControllers = [];
  List<TextEditingController> _phoneNumberControllers = [];
  List<TextEditingController> _tcNoControllers = [];

  List<GlobalKey<FormState>> _formKeysAdult = []; // form keys list
  List<GlobalKey<FormState>> _formKeysChild = []; // form keys list

  List<List<TextEditingController>> _controllersAdult = [];
  List<List<TextEditingController>> _controllersChild = [];

  List<DateTime> adultBirthDates = [];
  List<DateTime> childBirthDates = [];

  final db = FirebaseFirestore.instance;
  int validatedAdultFormCounter = 0;
  int validatedChildFormCounter = 0;

  void _submit() {
    if (childCount + adultCount > 0) {
      loadTickets();
      validatedAdultFormCounter = 0;
      validatedChildFormCounter = 0;
    } else {
      Fluttertoast.showToast(
        msg: "Lütfen Yolcu bilgilerini girin!",
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  void loadTickets() async {
    tickets.clear();
    for (int i = 0; i < adultCount; i++) {
      if (!_formKeysAdult[i].currentState!.validate()) {
        // await db
        //     .collection('Tickets')
        //     .doc(_controllersAdult[i][0].text.toString())
        //     .set({
        //   'ticketId': i + 1, // auto generated olmalı
        //   'namesurname': _controllersAdult[i][0].text.toString(),
        //   'phone': _controllersAdult[i][1].text.toString(),
        //   'tcno': _controllersAdult[i][2].text.toString(),
        //   'gender': _controllersAdult[i][3].text.toString(),
        //   'birthdate': adultBirthDates[i].toString(),
        // });

        tickets.add(
          Ticket.adult(
            nameSurname: _controllersAdult[i][0].text.toString(),
            gender: _controllersAdult[i][3].text.toString(),
            birthDate: adultBirthDates[i].toString(),
            tcNo: _controllersAdult[i][2].text.toString(),
            phoneNumber: _controllersAdult[i][1].text.toString(),
          ),
        );
      } else {
        validatedAdultFormCounter++;
      }
    }

    for (int i = 0; i < childCount; i++) {
      if (!_formKeysChild[i].currentState!.validate()) {
        // await db
        //     .collection('Tickets')
        //     .doc(_controllersChild[i][0].text.toString())
        //     .set({
        //   'ticketId': i + 1,
        //   'namesurname': _controllersChild[i][0].text.toString(),
        //   'tcno': _controllersChild[i][1].text.toString(),
        //   'gender': _controllersAdult[i][2].text.toString(),
        //   'birthdate': adultBirthDates[i].toString(),
        // });

        tickets.add(
          Ticket.child(
            nameSurname: _controllersChild[i][0].text.toString(),
            gender: _controllersAdult[i][2].text.toString(),
            birthDate: childBirthDates[i].toString(),
            tcNo: _controllersChild[i][1].text.toString(),
          ),
        );
      } else {
        validatedChildFormCounter++;
      }
    }

    if (validatedChildFormCounter + validatedAdultFormCounter ==
        adultCount + childCount) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (ctx) => AvailableFlightsPage(
              // tickets: tickets,
              // departureDate: departureDate,
              // arrivalDate: arrivalDate,
              // baggage:
              //     baggage
              ), // tickets, departuredate, arrivaldate..., baggage
        ),
      );
    }

    for (int i = 0; i < tickets.length; i++) {
      print(tickets[i].nameSurname);
    }
  }

  void _presentDatePicker(String type, int i) async {
    final now = DateTime.now();
    final firstDate = DateTime(1900, now.month, now.day);
    final lastDate = DateTime(1990, 12, 30);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    setState(() {
      _enteredDate = pickedDate!;
      if (type == 'adult') {
        adultBirthDates.insert(i, _enteredDate!);
      } else {
        childBirthDates.insert(i, _enteredDate!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(182, 102, 9, 0.75),
      ),
      backgroundColor: Styles.bgColor,
      body: SafeArea(
        // wrap futurebuilder sonra circularprogressindicator
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const Gap(40),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.verified_user_rounded, // Uçak ikonu
                              size: 32, // İkon boyutunu ayarlayın
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Yolcu Bilgileri',
                              style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(182, 102, 9, 0.75)),
                            ),
                            SizedBox(width: 8), // İkona ve metne boşluk ekleyin
                          ],
                        ),
                      ),
                      const Gap(40),
                    ],
                  ),
                  const Gap(25),
                  Form(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Yetişkin",
                          style: Styles.headLineStyle3
                              .copyWith(color: Colors.black, fontSize: 12),
                        ),
                        SizedBox(width: 5),
                        Container(
                          width: 55,
                          height: 55,
                          child: ClipRect(
                            child: DropdownButtonFormField<int>(
                              value: adultCount,
                              items: List.generate(6, (index) => index++)
                                  .map((count) {
                                return DropdownMenuItem<int>(
                                  value: count,
                                  child: Text(
                                    count.toString(),
                                    style: TextStyle(fontSize: 12),
                                  ),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  validatedAdultFormCounter = 0;
                                  adultCount = newValue!;
                                  _formKeysAdult.clear();
                                  _controllersAdult.clear();
                                  isFemaleAdult.clear();
                                  isMaleAdult.clear();
                                  for (int i = 0; i < adultCount; i++) {
                                    adultBirthDates.add(DateTime.now());
                                    isMaleAdult.add(false);
                                    isFemaleAdult.add(false);
                                    _formKeysAdult.add(GlobalKey<FormState>());
                                    _controllersAdult.add([
                                      TextEditingController(), // Ad Soyad
                                      TextEditingController(), // Telefon Numarası
                                      TextEditingController(), // TC No
                                      TextEditingController(),
                                    ]);
                                  }
                                });
                              },
                              validator: (value) {
                                // Your validation logic here
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Çocuk",
                          style: Styles.headLineStyle3
                              .copyWith(color: Colors.black, fontSize: 12),
                        ),
                        SizedBox(width: 5),
                        Container(
                          width: 55,
                          height: 55,
                          child: ClipRect(
                            child: DropdownButtonFormField<int>(
                              value: childCount,
                              items: List.generate(6, (index) => index++)
                                  .map((count) {
                                return DropdownMenuItem<int>(
                                  value: count,
                                  child: Text(
                                    count.toString(),
                                    style: TextStyle(fontSize: 12),
                                  ),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  validatedChildFormCounter = 0;
                                  childCount = newValue!;
                                  _formKeysChild.clear();
                                  _controllersChild.clear();
                                  isMaleChild.clear();
                                  isFemaleChild.clear();
                                  for (int i = 0; i < childCount; i++) {
                                    childBirthDates.add(DateTime.now());
                                    isMaleChild.add(false);
                                    isFemaleChild.add(false);
                                    _formKeysChild.add(GlobalKey<FormState>());
                                    _controllersChild.add([
                                      TextEditingController(), // Ad Soyad
                                      TextEditingController(), // Telefon Numarası
                                      TextEditingController(), // TC No
                                      TextEditingController(),
                                    ]);
                                  }
                                });
                              },
                              validator: (value) {
                                // Your validation logic here
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Bagaj (kg)",
                          style: Styles.headLineStyle3
                              .copyWith(color: Colors.black, fontSize: 12),
                        ),
                        SizedBox(width: 5),
                        Container(
                          width: 65,
                          height: 55,
                          child: ClipRect(
                            child: DropdownButtonFormField<int>(
                              value: baggage,
                              items: List.generate(6, (index) => index * 10)
                                  .map((count) {
                                return DropdownMenuItem<int>(
                                  value: count,
                                  child: Text(
                                    count.toString(),
                                    style: TextStyle(fontSize: 12),
                                  ),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  baggage = newValue!;
                                });
                              },
                              validator: (value) {
                                // Your validation logic here
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12),
                  Container(
                    height: 450,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          for (int i = 0; i < adultCount; i++)
                            Column(
                              children: [
                                const Gap(25),
                                Text(
                                  "Yolcu (Yetişkin) ${i + 1}",
                                  style: TextStyle(color: Colors.black54),
                                ),
                                Form(
                                  key: _formKeysAdult[i],
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Ad Soyad",
                                        style: TextStyle(color: Colors.black54),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0,
                                            bottom: 16,
                                            right: 16,
                                            left: 16),
                                        child: TextFormField(
                                          controller: _controllersAdult[i][0],
                                          onSaved: (value) {
                                            _enteredNameSurname = value!;
                                          },
                                          keyboardType: TextInputType.name,
                                          decoration: InputDecoration(
                                            prefixIcon: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: SvgPicture.asset(
                                                  "assets/icons/name_surname.svg"),
                                            ),
                                          ),
                                          validator: (name) {
                                            if (name!.isEmpty) {
                                              return 'Zorunlu';
                                            }
                                          },
                                        ),
                                      ),
                                      const Text(
                                        "Telefon Numarası",
                                        style: TextStyle(color: Colors.black54),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0,
                                            bottom: 16,
                                            right: 16,
                                            left: 16),
                                        child: TextFormField(
                                          controller: _controllersAdult[i][1],
                                          onSaved: (phoneNumber) {
                                            _enteredPhoneNumber = phoneNumber!;
                                          },
                                          keyboardType: TextInputType.phone,
                                          decoration: InputDecoration(
                                            prefixIcon: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: SvgPicture.asset(
                                                  "assets/icons/phone.svg"),
                                            ),
                                          ),
                                          validator: (phone) {
                                            if (phone!.isEmpty) {
                                              return 'Zorunlu';
                                            }
                                          },
                                        ),
                                      ),
                                      const Text(
                                        "TC No",
                                        style: TextStyle(color: Colors.black54),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0,
                                            bottom: 16,
                                            right: 16,
                                            left: 16),
                                        child: TextFormField(
                                          controller: _controllersAdult[i][2],
                                          onSaved: (tcNo) {
                                            _enteredTcNo = tcNo!;
                                          },
                                          keyboardType: TextInputType.phone,
                                          decoration: InputDecoration(
                                            prefixIcon: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: SvgPicture.asset(
                                                'assets/icons/id_no.svg',
                                              ),
                                            ),
                                          ),
                                          validator: (phone) {
                                            if (phone!.isEmpty) {
                                              return 'Zorunlu';
                                            }
                                          },
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Column(
                                            children: [
                                              const Text(
                                                "Doğum Tarihi",
                                                style: TextStyle(
                                                    color: Colors.black54),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0, bottom: 8),
                                                child: ElevatedButton.icon(
                                                  onPressed: () {
                                                    _presentDatePicker(
                                                        'adult', i);
                                                  },
                                                  icon: Icon(
                                                    Icons.calendar_month,
                                                    color: Color.fromARGB(
                                                        235,
                                                        241,
                                                        227,
                                                        227), // İstediğiniz rengi burada tanımlayabilirsiniz.
                                                  ),
                                                  label: Text(
                                                      "Doğum Tarihi"), // Düğme metni
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Color.fromRGBO(
                                                            182, 102, 9, 0.75),
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                adultBirthDates.isEmpty
                                                    ? ' Lütfen Doğum tarihinizi belirtin'
                                                    : '${adultBirthDates[i].day}/${adultBirthDates[i].month}/${adultBirthDates[i].year}',
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        182, 102, 9, 0.75),
                                                    fontSize: 12),
                                              ),
                                            ],
                                          ),
                                          SizedBox(width: 36),
                                          Column(
                                            children: [
                                              const Text(
                                                "Cinsiyet",
                                                style: TextStyle(
                                                    color: Colors.black54),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0, bottom: 16),
                                                child: Row(
                                                  children: [
                                                    Checkbox(
                                                      activeColor:
                                                          Color.fromARGB(255,
                                                              250, 168, 171),
                                                      value: isFemaleAdult[i],
                                                      onChanged: (value) {
                                                        setState(() {
                                                          if (isMaleAdult[i] ==
                                                              true) {
                                                            isMaleAdult[i] =
                                                                false;
                                                          }
                                                          isFemaleAdult[i] =
                                                              true;
                                                          _enteredGender =
                                                              'Kadın';
                                                          _controllersAdult[i]
                                                                      [3]
                                                                  .text =
                                                              _enteredGender;
                                                        });
                                                      },
                                                    ),
                                                    SizedBox(width: 5),
                                                    Checkbox(
                                                      activeColor:
                                                          Color.fromARGB(
                                                              255, 80, 86, 240),
                                                      value: isMaleAdult[i],
                                                      onChanged: (value) {
                                                        setState(() {
                                                          if (isFemaleAdult[
                                                                  i] ==
                                                              true) {
                                                            isFemaleAdult[i] =
                                                                false;
                                                          }
                                                          isMaleAdult[i] = true;
                                                          _enteredGender =
                                                              'Erkek';
                                                          _controllersAdult[i]
                                                                      [3]
                                                                  .text =
                                                              _enteredGender;
                                                        });
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          for (int i = 0; i < childCount; i++)
                            Column(
                              children: [
                                const Gap(25),
                                Text(
                                  "Yolcu (Çocuk) ${i + 1}",
                                  style: TextStyle(color: Colors.black54),
                                ),
                                Form(
                                  key: _formKeysChild[i],
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Ad Soyad",
                                        style: TextStyle(color: Colors.black54),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0,
                                            bottom: 16,
                                            right: 16,
                                            left: 16),
                                        child: TextFormField(
                                          controller: _controllersChild[i][0],
                                          onSaved: (value) {
                                            _enteredNameSurname = value!;
                                          },
                                          keyboardType: TextInputType.name,
                                          decoration: InputDecoration(
                                            prefixIcon: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: SvgPicture.asset(
                                                  "assets/icons/name_surname.svg"),
                                            ),
                                          ),
                                          validator: (name) {
                                            if (name!.isEmpty) {
                                              return 'Zorunlu';
                                            }
                                          },
                                        ),
                                      ),
                                      const Text(
                                        "TC No",
                                        style: TextStyle(color: Colors.black54),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0,
                                            bottom: 16,
                                            right: 16,
                                            left: 16),
                                        child: TextFormField(
                                          controller: _controllersChild[i][1],
                                          onSaved: (tcNo) {
                                            _enteredTcNo = tcNo!;
                                          },
                                          keyboardType: TextInputType.phone,
                                          decoration: InputDecoration(
                                            prefixIcon: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: SvgPicture.asset(
                                                  "assets/icons/id_no.svg"),
                                            ),
                                          ),
                                          validator: (phone) {
                                            if (phone!.isEmpty) {
                                              return 'Zorunlu';
                                            }
                                          },
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Column(
                                            children: [
                                              const Text(
                                                "Doğum Tarihi",
                                                style: TextStyle(
                                                    color: Colors.black54),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0, bottom: 8),
                                                child: ElevatedButton.icon(
                                                  onPressed: () {
                                                    _presentDatePicker(
                                                        'child', i);
                                                    childBirthDates
                                                        .add(_enteredDate!);
                                                  },
                                                  icon: Icon(
                                                    Icons.calendar_month,
                                                    color: Color.fromARGB(
                                                        235,
                                                        241,
                                                        227,
                                                        227), // İstediğiniz rengi burada tanımlayabilirsiniz.
                                                  ),
                                                  label: Text(
                                                      "Doğum Tarihi"), // Düğme metni
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Color.fromRGBO(
                                                            182, 102, 9, 0.75),
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                childBirthDates.isEmpty
                                                    ? ' Lütfen Doğum tarihinizi belirtin'
                                                    : '${childBirthDates[i].day}/${childBirthDates[i].month}/${childBirthDates[i].year}',
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        182, 102, 9, 0.75),
                                                    fontSize: 12),
                                              ),
                                            ],
                                          ),
                                          SizedBox(width: 36),
                                          Column(
                                            children: [
                                              const Text(
                                                "Cinsiyet",
                                                style: TextStyle(
                                                    color: Colors.black54),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0, bottom: 16),
                                                child: Row(
                                                  children: [
                                                    Checkbox(
                                                      activeColor:
                                                          Color.fromARGB(255,
                                                              250, 168, 171),
                                                      value: isFemaleChild[i],
                                                      onChanged: (value) {
                                                        setState(() {
                                                          if (isMaleChild[i] ==
                                                              true) {
                                                            isMaleChild[i] =
                                                                false;
                                                          }
                                                          isFemaleChild[i] =
                                                              true;
                                                          _enteredGender =
                                                              'Kadın';
                                                          _controllersChild[i]
                                                                      [3]
                                                                  .text =
                                                              _enteredGender;
                                                        });
                                                      },
                                                    ),
                                                    SizedBox(width: 5),
                                                    Checkbox(
                                                      activeColor:
                                                          Color.fromARGB(
                                                              255, 80, 86, 240),
                                                      value: isMaleChild[i],
                                                      onChanged: (value) {
                                                        setState(
                                                          () {
                                                            if (isFemaleChild[
                                                                    i] ==
                                                                true) {
                                                              isFemaleChild[i] =
                                                                  false;
                                                            }
                                                            isMaleChild[i] =
                                                                true;
                                                            _enteredGender =
                                                                'Erkek';
                                                            _controllersChild[i]
                                                                        [3]
                                                                    .text =
                                                                _enteredGender;
                                                          },
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          SizedBox(height: 16),
                          if (adultCount + childCount > 0)
                            const Divider(
                              color: Color.fromARGB(
                                  255, 117, 71, 71), // Çizgi rengi
                              thickness: 1, // Çizgi kalınlığı
                              indent: 16, // Başlangıç boşluğu
                              endIndent: 16, // Bitiş boşluğu
                            ),
                          if (adultCount + childCount > 0)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    const Text(
                                      "Gidiş Tarihi",
                                      style: TextStyle(color: Colors.black54),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, bottom: 8),
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          _presentDatePicker('', 0);
                                          childBirthDates.add(_enteredDate!);
                                        },
                                        icon: Icon(
                                          Icons.calendar_month,
                                          color: Color.fromARGB(235, 241, 227,
                                              227), // İstediğiniz rengi burada tanımlayabilirsiniz.
                                        ),
                                        label:
                                            Text("Gidiş Tarihi"), // Düğme metni
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color.fromRGBO(
                                              182, 102, 9, 0.75), // Çizgi rengi
                                        ),
                                      ),
                                    ),
                                    Text(
                                      childBirthDates.isEmpty
                                          ? ' Lütfen gidiş tarihinizi belirtin'
                                          : '${departureDate!.day}/${departureDate!.month}/${departureDate!.year}',
                                      style: TextStyle(
                                          color: Color.fromRGBO(
                                              182, 102, 9, 0.75), // Çizgi rengi
                                          fontSize: 12),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 36),
                                if (!widget.isOneDirection)
                                  Column(
                                    children: [
                                      const Text(
                                        "Gönüş Tarihi",
                                        style: TextStyle(color: Colors.black54),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0, bottom: 8),
                                        child: ElevatedButton.icon(
                                          onPressed: () {
                                            _presentDatePicker('', 0);
                                            childBirthDates.add(_enteredDate!);
                                          },
                                          icon: Icon(
                                            Icons.calendar_month,
                                            color: Color.fromARGB(235, 241, 227,
                                                227), // İstediğiniz rengi burada tanımlayabilirsiniz.
                                          ),
                                          label: Text(
                                              "Gönüş Tarihi"), // Düğme metni
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color.fromRGBO(182,
                                                102, 9, 0.75), // Çizgi rengi
                                          ),
                                        ),
                                      ),
                                      Text(
                                        childBirthDates.isEmpty
                                            ? ' Lütfen dönüş tarihinizi belirtin'
                                            : '${arrivalDate!.day}/${arrivalDate!.month}/${arrivalDate!.year}',
                                        style: TextStyle(
                                            color: Color.fromRGBO(182, 102, 9,
                                                0.75), // Çizgi rengi
                                            fontSize: 12),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                  const Gap(25),
                  Container(
                    margin: EdgeInsets.only(left: 250),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromRGBO(
                            182, 102, 9, 0.75), // Button background color
                        onPrimary:
                            Color.fromARGB(237, 252, 252, 252), // Text color
                        padding: EdgeInsets.all(
                            16), // Padding around the button text
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(90), // Button border radius
                        ),
                      ),
                      onPressed: () {
                        _submit();
                        // print('adult ${validatedAdultFormCounter.toString()}');
                        // print('child ${validatedChildFormCounter.toString()}');
                      },
                      child: SvgPicture.asset("assets/icons/arrow_right.svg"),
                    ),
                  ),
                  const Gap(36),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
