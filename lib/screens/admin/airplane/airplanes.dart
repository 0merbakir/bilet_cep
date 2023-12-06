// ignore_for_file: library_private_types_in_public_api, deprecated_member_use, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/svg.dart';

class AirplanesPage extends StatefulWidget {
  const AirplanesPage({Key? key}) : super(key: key);

  @override
  _AirplanesPageState createState() => _AirplanesPageState();
}

class _AirplanesPageState extends State<AirplanesPage> {
  final _form = GlobalKey<FormState>();

  var _airplaneName = '';
  var _city = '';
  var _code = '';
  var arrivals = [];
  var departures = [];

  final db = FirebaseFirestore.instance;

  void _submit() async {
    _form.currentState!.save();
    try {
      await db.collection('airplanes').doc(_airplaneName).set({
        'airplanename': _airplaneName,
        'city': _city,
        'code': _code,
      });

      var airplaneRef = db.collection('airplanes').doc(_airplaneName);

      for (var departure in departures) {
        await airplaneRef
            .collection('departures')
            .doc(departure.toString())
            .set({'departure': departure.toString(), 'code': '000'});
      }
      for (var arrival in arrivals) {
        await airplaneRef
            .collection('arrivals')
            .doc(arrival.toString())
            .set({'arrival': arrival.toString(), 'code': '000'});
      }
    } catch (e) {
      print(e);
    }
  }

  TextEditingController arrivalsController = TextEditingController();
  TextEditingController departuresController = TextEditingController();

  final GlobalKey<FormFieldState<String>> arrivalsKey =
      GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> departuresKey =
      GlobalKey<FormFieldState<String>>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Hava Alanı Ekleme',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 21,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 28, 30, 45),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.airplanemode_active, // Uçak ikonu
                      size: 32, // İkon boyutunu ayarlayın
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Hava Limanı Ekleme',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8), // İkona ve metne boşluk ekleyin
                  ],
                ),
              ),
              Card(
                color: Colors.white,
                margin: const EdgeInsets.all(30),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Form(
                      key: _form,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Color.fromARGB(106, 158, 158, 158),
                              labelText: 'Havalimanı Adı',
                              floatingLabelStyle: TextStyle(
                                  color: Color.fromARGB(255, 22, 23, 34),
                                  fontSize: 19.0),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              ///.....
                              return null;
                            },
                            onSaved: (value) {
                              _airplaneName = value!;
                            },
                          ),
                          SizedBox(height: 5),
                          TextFormField(
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Color.fromARGB(106, 158, 158, 158),
                              labelText: 'Şehir',
                              floatingLabelStyle: TextStyle(
                                  color: Color.fromARGB(255, 22, 23, 34),
                                  fontSize: 19.0),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              ///.....
                              return null;
                            },
                            onSaved: (value) {
                              _city = value!;
                            },
                          ),
                          SizedBox(height: 5),
                          TextFormField(
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Color.fromARGB(106, 158, 158, 158),
                              labelText: 'Kodu',
                              floatingLabelStyle: TextStyle(
                                  color: Color.fromARGB(255, 22, 23, 34),
                                  fontSize: 19.0),
                            ),
                            keyboardType: TextInputType.text,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              ///.....
                              return null;
                            },
                            onSaved: (value) {
                              _code = value!;
                            },
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Container(
                                width: 185,
                                height: 65,
                                child: TextFormField(
                                  controller: arrivalsController,
                                  key: arrivalsKey,
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor:
                                        Color.fromARGB(106, 158, 158, 158),
                                    labelText: 'Gelen Hatlar',
                                    floatingLabelStyle: TextStyle(
                                        color: Color.fromARGB(255, 22, 23, 34),
                                        fontSize: 19.0),
                                  ),
                                  keyboardType: TextInputType.multiline,
                                  autocorrect: false,
                                  textCapitalization: TextCapitalization.none,
                                  validator: (value) {
                                    if (value == '') {
                                      return 'Boş değer!';
                                    }
                                  },
                                  onSaved: (value) {},
                                ),
                              ),
                              SizedBox(width: 20),
                              Container(
                                width: 95,
                                height: 50,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Color.fromARGB(105, 22, 23,
                                        34), // Button background color
                                    onPrimary: Color.fromARGB(
                                        237, 252, 252, 252), // Text color
                                    padding: EdgeInsets.all(
                                        16), // Padding around the button text
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          20), // Button border radius
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      if (arrivalsKey.currentState!.isValid) {
                                        arrivals.add(arrivalsController.text);
                                        arrivalsController.clear();
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                      }
                                    });
                                  },
                                  child: Text(
                                    'Ekle', // Button text
                                    style: TextStyle(
                                      fontSize: 18, // Text font size
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Wrap(
                            spacing: 8, // Elemanlar arasındaki boşluk
                            children: arrivals.map((arrival) {
                              final Key itemKey =
                                  UniqueKey(); // Her öğeye benzersiz bir anahtar oluştur
                              return Container(
                                width:
                                    100, // Her elemanın sabit bir genişliği var
                                margin: EdgeInsets.only(
                                    bottom: 8), // Alt satır aralığı
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      10), // Daha küçük yuvarlak köşeler
                                  color: Color.fromARGB(122, 7, 25, 86),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .center, // Metni yatayda ortala
                                  children: [
                                    Text(
                                      arrival,
                                      style: TextStyle(
                                        color: Colors
                                            .white, // Metin rengini beyaz yapmak için TextStyle kullanılır
                                        fontSize: 13,
                                        fontWeight: FontWeight
                                            .bold, // Metin boyutunu düşürmek için fontSize kullanılır
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.close),
                                      iconSize:
                                          16, // Buton boyutunu küçültmek için iconSize kullanılır
                                      color: Colors
                                          .red, // Buton rengini kırmızı yapmak için color kullanılır
                                      onPressed: () {
                                        // "X" butonuna tıklandığında ilgili öğeyi listeden kaldır
                                        setState(() {
                                          arrivals.remove(arrival);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                          SizedBox(height: 12),
                          Row(
                            children: [
                              Container(
                                width: 185,
                                height: 65,
                                child: TextFormField(
                                  controller: departuresController,
                                  key: departuresKey,
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor:
                                        Color.fromARGB(106, 158, 158, 158),
                                    labelText: 'Giden Hatlar',
                                    floatingLabelStyle: TextStyle(
                                        color: Color.fromARGB(255, 22, 23, 34),
                                        fontSize: 19.0),
                                  ),
                                  keyboardType: TextInputType.multiline,
                                  autocorrect: false,
                                  textCapitalization: TextCapitalization.none,
                                  validator: (value) {
                                    if (value == '') {
                                      return 'Boş değer!';
                                    }
                                  },
                                ),
                              ),
                              SizedBox(width: 20),
                              Container(
                                width: 95,
                                height: 50,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Color.fromARGB(105, 22, 23,
                                        34), // Button background color
                                    onPrimary: Color.fromARGB(
                                        237, 252, 252, 252), // Text color
                                    padding: EdgeInsets.all(
                                        16), // Padding around the button text
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          20), // Button border radius
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      if (departuresKey.currentState!.isValid) {
                                        departures
                                            .add(departuresController.text);
                                        departuresController.clear();
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                      }
                                    });
                                  },
                                  child: Text(
                                    'Ekle', // Button text
                                    style: TextStyle(
                                      fontSize: 18, // Text font size
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Wrap(
                            spacing: 8, // Elemanlar arasındaki boşluk
                            children: departures.map((departure) {
                              final Key itemKey =
                                  UniqueKey(); // Her öğeye benzersiz bir anahtar oluştur
                              return Container(
                                width:
                                    100, // Her elemanın sabit bir genişliği var
                                margin: EdgeInsets.only(
                                    bottom: 8), // Alt satır aralığı
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      10), // Daha küçük yuvarlak köşeler
                                  color: Color.fromARGB(122, 7, 25, 86),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .center, // Metni yatayda ortala
                                  children: [
                                    Text(
                                      departure,
                                      style: TextStyle(
                                        color: Colors
                                            .white, // Metin rengini beyaz yapmak için TextStyle kullanılır
                                        fontSize:
                                            12, // Metin boyutunu düşürmek için fontSize kullanılır
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.close),
                                      iconSize:
                                          16, // Buton boyutunu küçültmek için iconSize kullanılır
                                      color: Colors
                                          .red, // Buton rengini kırmızı yapmak için color kullanılır
                                      onPressed: () {
                                        // "X" butonuna tıklandığında ilgili öğeyi listeden kaldır
                                        setState(() {
                                          departures.remove(departure);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                          SizedBox(height: 36),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(
                                  255, 22, 23, 34), // Button background color
                              onPrimary: Color.fromARGB(
                                  237, 252, 252, 252), // Text color
                              padding: EdgeInsets.all(
                                  16), // Padding around the button text
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    20), // Button border radius
                              ),
                            ),
                            onPressed: () {
                              _submit();
                            },
                            child: Text(
                              'Kaydet', // Button text
                              style: TextStyle(
                                fontSize: 18, // Text font size
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
