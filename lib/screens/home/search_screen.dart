import 'package:bilet_cep/screens/home/ticket-booking/passengers_info.dart';
import 'package:bilet_cep/utils/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:bilet_cep/utils/app_styles.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var _selectedArrival;
  var _selectedDeparture;
  bool isOneDirecton = true;
  DateTime? goDate;
  DateTime? backDate;
  DateTime? _enteredDate;

  Future<List<String>> fetchAirPlanes() async {
    var arrivalsRef = FirebaseFirestore.instance.collection('airplanes');
    QuerySnapshot querySnapshot = await arrivalsRef.get();
    List<DocumentSnapshot> airplanes = querySnapshot.docs;
    List<String> allAirPlanes = [];
    for (var arrival in airplanes) {
      allAirPlanes.add(arrival.id);
    }
    return allAirPlanes;
  }

  void _presentDatePicker(String dateType) async {
    final now = DateTime.now();
    final firstDate = DateTime.now();
    final lastDate = DateTime(2024, 01, 30);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    _enteredDate = pickedDate!;

    if (dateType == 'goDate') {
      setState(() {
        goDate = pickedDate!;
      });
    }
    if (dateType == 'backDate') {
      setState(() {
        backDate = pickedDate!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = AppLayout.getSize(context);
    return Scaffold(
      backgroundColor: Styles.bgColor,
      body: SafeArea(
        child: FutureBuilder<List<String>>(
          future: fetchAirPlanes(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Hata: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text('Veri bulunamadı'),
              );
            } else {
              List<String> allAirPlanes = snapshot.data!;
              return ListView(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                children: [
                  Gap(AppLayout.getHeight(40)),
                  Text("Yolculuk Nereye?",
                      style: Styles.headLineStyle1
                          .copyWith(fontSize: AppLayout.getHeight(35))),
                  Gap(AppLayout.getHeight(40)),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Color(0xFFF4F6FD),
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isOneDirecton = true;
                            });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.44,
                            padding: EdgeInsets.symmetric(vertical: 17),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.white,
                            ),
                            child: Center(
                              child: Text(
                                "Tek Yön",
                                style: Styles.headLineStyle4.copyWith(
                                    color: isOneDirecton
                                        ? Colors.black
                                        : Colors.grey),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isOneDirecton = false;
                            });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.44,
                            padding: EdgeInsets.symmetric(vertical: 17),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Center(
                              child: Text(
                                "Gidiş Dönüş",
                                style: Styles.headLineStyle4.copyWith(
                                    color: isOneDirecton
                                        ? Colors.grey
                                        : Colors.black),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Gap(20),
                  Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Styles.bgColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.flight_takeoff),
                        Gap(10),
                        Container(
                          width: 280,
                          height: 75,
                          child: ClipRect(
                            child: DropdownButtonFormField<String>(
                              value: _selectedDeparture,
                              hint: Text("Nereden",
                                  style: Styles.headLineStyle3
                                      .copyWith(color: Colors.black)),
                              items: allAirPlanes.map((airplane) {
                                return DropdownMenuItem<String>(
                                  value: airplane,
                                  child: Text(airplane),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedDeparture = newValue;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Styles.bgColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.flight_land),
                        Gap(10),
                        Container(
                          width: 280,
                          height: 75,
                          child: ClipRect(
                            child: DropdownButtonFormField<String>(
                              value: _selectedArrival,
                              hint: Text(
                                "Nereye",
                                style: Styles.headLineStyle3
                                    .copyWith(color: Colors.black),
                              ),
                              items: allAirPlanes.map((airplane) {
                                return DropdownMenuItem<String>(
                                  value: airplane,
                                  child: Text(airplane),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedArrival = newValue;
                                });
                              },
                              validator: (value) {
                                if (value == _selectedDeparture) {
                                  return 'Lütfen farklı bir rota seçin'; // validation işlemleri
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gap(10),
                  //ticket btn
                  InkWell(
                    onTap: () {
                      if (_selectedArrival.toString().isEmpty ||
                          _selectedDeparture.toString().isEmpty) {
                        Fluttertoast.showToast(
                          msg: "Lütfen gidiş ve dönüş rotalarını belirleyin.",
                          toastLength: Toast.LENGTH_SHORT,
                        );
                      } else if (_selectedArrival == _selectedDeparture) {
                        Fluttertoast.showToast(
                          msg: "Lütfen Farklı bir rota seçin.",
                          toastLength: Toast.LENGTH_SHORT,
                        );
                      } else if (isOneDirecton &&
                          goDate!.day.toString().isEmpty) {
                        Fluttertoast.showToast(
                          msg: "Lütfen Gidiş tarihinizi belirtin.",
                          toastLength: Toast.LENGTH_SHORT,
                        );
                      } else if (!isOneDirecton &&
                          (goDate!.day.toString().isEmpty ||
                              backDate!.day.toString().isEmpty)) {
                        Fluttertoast.showToast(
                          msg: "Lütfen gidiş ve dönüş tarihlerinizi belirtin.",
                          toastLength: Toast.LENGTH_SHORT,
                        );
                      } else {
                        if (isOneDirecton) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PassengersInfo(
                                arrival: _selectedArrival,
                                departure: _selectedDeparture,
                                goDate: goDate!,
                              ),
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PassengersInfo(
                                arrival: _selectedArrival,
                                departure: _selectedDeparture,
                                goDate: goDate!,
                                backDate: backDate,
                              ),
                            ),
                          );
                        }
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                          "Bilet Ara",
                          style: Styles.headLineStyle3
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 24),
                  const Divider(
                    color: Color.fromARGB(255, 117, 71, 71), // Çizgi rengi
                    thickness: 1, // Çizgi kalınlığı
                    indent: 16, // Başlangıç boşluğu
                    endIndent: 16, // Bitiş boşluğu
                  ),

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
                            padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                            child: ElevatedButton.icon(
                              onPressed: () {
                                _presentDatePicker('goDate');
                              },
                              icon: Icon(
                                Icons.calendar_month,
                                color: Color.fromARGB(235, 241, 227,
                                    227), // İstediğiniz rengi burada tanımlayabilirsiniz.
                              ),
                              label: Text(goDate == null
                                  ? "Gidiş Tarihi"
                                  : "${goDate!.day}/${goDate!.month}/${goDate!.year}"), // Düğme metni
                              style: ElevatedButton.styleFrom(
                                backgroundColor: goDate == null
                                    ? Color.fromRGBO(39, 100, 231, 0.175)
                                    : Colors.blue, // Çizgi rengi
                              ),
                            ),
                          ),
                          Text(
                            goDate == null
                                ? ' Lütfen gidiş tarihinizi belirtin'
                                : '',
                            style: TextStyle(
                                color: Color.fromRGBO(
                                    9, 64, 182, 0.745), // Çizgi rengi
                                fontSize: 12),
                          ),
                        ],
                      ),
                      SizedBox(width: 36),
                      if (!isOneDirecton)
                        Column(
                          children: [
                            const Text(
                              "Gönüş Tarihi",
                              style: TextStyle(color: Colors.black54),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, bottom: 8),
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  _presentDatePicker("backDate");
                                },
                                icon: Icon(
                                  Icons.calendar_month,
                                  color: Color.fromARGB(235, 241, 227,
                                      227), // İstediğiniz rengi burada tanımlayabilirsiniz.
                                ),
                                label: Text(goDate == null
                                    ? "Gidiş Tarihi"
                                    : "${backDate!.day}/${backDate!.month}/${backDate!.year}"), // Düğme metni
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: backDate == null
                                      ? Color.fromRGBO(39, 100, 231, 0.175)
                                      : Colors.blue, // Çizgi rengi
                                ),
                              ),
                            ),
                            Text(
                              backDate == null
                                  ? ' Lütfen gidiş tarihinizi belirtin'
                                  : '',
                              style: TextStyle(
                                  color: Color.fromRGBO(
                                      9, 64, 182, 0.745), // Çizgi rengi
                                  fontSize: 12),
                            ),
                          ],
                        ),
                    ],
                  ),
                  Gap(AppLayout.getHeight(30)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: AppLayout.getHeight(400),
                        padding: EdgeInsets.all(AppLayout.getHeight(15)),
                        width: size.width * 0.42,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                                Radius.circular(AppLayout.getHeight(15)))),
                        child: Column(
                          children: [
                            Container(
                              height: AppLayout.getHeight(190),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      AppLayout.getHeight(12)),
                                  image: const DecorationImage(
                                      fit: BoxFit.cover,
                                      image:
                                          AssetImage("assets/images/sit.jpg"))),
                            ),
                            Gap(AppLayout.getHeight(8)),
                            Text(
                              "20% discount on business class and tickets from Airline International",
                              style: Styles.headLineStyle2
                                  .copyWith(color: Colors.black),
                            )
                          ],
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Stack(
                            children: [
                              Container(
                                height: AppLayout.getHeight(200),
                                width: size.width * 0.44,
                                padding:
                                    EdgeInsets.all(AppLayout.getHeight(15)),
                                decoration: BoxDecoration(
                                    color: const Color(0xFF3ABBBB),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            AppLayout.getHeight(15)))),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Discount \nfor survey",
                                      style: Styles.headLineStyle2
                                          .copyWith(color: Colors.white),
                                    ),
                                    Gap(AppLayout.getHeight(8)),
                                    Text(
                                      "Take the survey",
                                      style: Styles.headLineStyle2.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.normal),
                                    )
                                  ],
                                ),
                              ),
                              Positioned(
                                right: -40,
                                top: -20,
                                child: Container(
                                  padding:
                                      EdgeInsets.all(AppLayout.getHeight(25)),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          width: 18,
                                          color: const Color(0xFF189999))),
                                ),
                              )
                            ],
                          ),
                          Gap(AppLayout.getHeight(15)),
                          Stack(
                            children: [
                              Container(
                                height: AppLayout.getHeight(200),
                                width: size.width * 0.44,
                                padding:
                                    EdgeInsets.all(AppLayout.getHeight(15)),
                                decoration: BoxDecoration(
                                    color: Colors.deepOrange,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            AppLayout.getHeight(15)))),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "We should \nimprove?",
                                      style: Styles.headLineStyle2
                                          .copyWith(color: Colors.white),
                                    ),
                                    Gap(AppLayout.getHeight(8)),
                                    Text(
                                      "Feel free to tell us what we need to improve.",
                                      style: Styles.headLineStyle2.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.normal),
                                    )
                                  ],
                                ),
                              ),
                              Positioned(
                                right: -40,
                                top: -20,
                                child: Container(
                                  padding:
                                      EdgeInsets.all(AppLayout.getHeight(25)),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          width: 18,
                                          color: Colors.deepOrangeAccent)),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ],
                  )
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
