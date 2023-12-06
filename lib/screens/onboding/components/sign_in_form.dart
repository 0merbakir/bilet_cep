import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

final _firebase = FirebaseAuth.instance;

class SignInForm extends StatefulWidget {
  SignInForm({super.key, required this.isSignIn});
  bool
      isSignIn; // Giriş mi yoksa kayıt mı olduğunu belirlemek için kullanılan bir bayrak

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); // Formun anahtarını oluşturur
  bool isShowLoading =
      false; // Yüklenme animasyonunu göstermek için kullanılan bayrak
  bool isShowConfetti =
      false; // Konfeti animasyonunu göstermek için kullanılan bayrak

  late SMITrigger check; // Başarılı animasyon tetikleyicisi
  late SMITrigger error; // Hata animasyon tetikleyicisi
  late SMITrigger reset;

  late SMITrigger confetti; // Konfeti animasyon tetikleyicisi

  var _enteredEmail = ''; // Kullanıcının girdiği e-posta adresi
  var _enteredPassword = ''; // Kullanıcının girdiği şifre

  bool invalidCredentials = false;
  bool userAlreadyExist = false;

  var _enteredNameSurname;
  var _enteredGender;
  bool isMale = false;
  bool isFemale = false;
  DateTime? _enteredBirthDay;
  var _enteredPhone;

  final db = FirebaseFirestore.instance;

  StateMachineController getRiveController(Artboard artboard) {
    StateMachineController? controller =
        StateMachineController.fromArtboard(artboard, "State Machine 1");
    artboard.addController(controller!);
    return controller; // Rive animasyon kontrolcüsünü alır
  }

  void registerUser() async {
    if (_formKey.currentState!.validate()) {
      await db.collection('Users').doc(_enteredNameSurname).set({
        'id': _firebase.currentUser!.uid,
        'namesurname': _enteredNameSurname,
        'email': _enteredEmail,
        'password': _enteredPassword,
        'gender': _enteredGender,
        'birthdate': _enteredBirthDay,
        'phone': _enteredPhone
      });
    }
  }

  void signIn(BuildContext context) async {
    setState(() {
      isShowLoading = true;
      isShowConfetti = true;
    });
    Future.delayed(Duration(seconds: 1), () {
      if (_formKey.currentState!.validate()) {
        check.fire();
        Future.delayed(Duration(seconds: 2), () {
          setState(() {
            isShowLoading = false;
          });
          confetti.fire();
        });
      } else {
        error.fire();
        Future.delayed(Duration(seconds: 2), () {
          setState(() {
            isShowLoading = false;
          });
        });
      }
    });

    _formKey.currentState!.save();
    if (_formKey.currentState!.validate()) {
      if (widget.isSignIn) {
        try {
          final UserCredentials = await _firebase.signInWithEmailAndPassword(
              email: _enteredEmail, password: _enteredPassword);
          print(UserCredentials);
          Navigator.pop(context);
        } on FirebaseAuthException catch (error) {
          if (error.code == 'INVALID_LOGIN_CREDENTIALS') {
            setState(() {
              invalidCredentials = true;
            });
          }
        }
      } else {
        try {
          final UserCredentials =
              await _firebase.createUserWithEmailAndPassword(
                  email: _enteredEmail, password: _enteredPassword);
          registerUser();
          print(UserCredentials);
          Navigator.pop(context);
        } on FirebaseAuthException catch (error) {
          print(error.code);
          if (error.code == 'email-already-in-use') {
            setState(() {
              userAlreadyExist = true;
            });
          }
        }
      }
    }
  }

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(1990, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );

    setState(() {
      _enteredBirthDay = pickedDate!;
    });
  }

  @override
  Widget build(BuildContext context) {
    // validation fonksiyonları ve snackbar eklenecek
    return Stack(
      children: [
        Form(
            key: _formKey, // Form anahtarını kullanır
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!widget.isSignIn)
                  const Text(
                    "Ad Soyad",
                    style: TextStyle(color: Colors.black54),
                  ),
                if (!widget.isSignIn)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 16),
                    child: TextFormField(
                      onSaved: (nameSurname) {
                        _enteredNameSurname = nameSurname;
                      },
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                          prefixIcon: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child:
                            SvgPicture.asset("assets/icons/name_surname.svg"),
                      )),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Zorunlu';
                        }
                      },
                    ),
                  ),
                if (!widget.isSignIn)
                  Row(
                    children: [
                      Column(
                        children: [
                          const Text(
                            "Doğum Tarihi",
                            style: TextStyle(color: Colors.black54),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                            child: ElevatedButton.icon(
                              onPressed: () => _presentDatePicker(),
                              icon: Icon(
                                Icons.calendar_month,
                                color: Color.fromARGB(235, 241, 227,
                                    227), // İstediğiniz rengi burada tanımlayabilirsiniz.
                              ),
                              label: Text("Doğum Tarihi"), // Düğme metni
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(235, 250, 168, 171)),
                            ),
                          ),
                          Text(
                            _enteredBirthDay == null
                                ? ' Lütfen Doğum tarihinizi belirtin'
                                : '${_enteredBirthDay!.day}/${_enteredBirthDay!.month}/${_enteredBirthDay!.year}',
                            style: TextStyle(color: Colors.black54),
                          ),
                        ],
                      ),
                      SizedBox(width: 36),
                      Column(
                        children: [
                          const Text(
                            "Cinsiyet",
                            style: TextStyle(color: Colors.black54),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, bottom: 16),
                            child: Row(
                              children: [
                                Checkbox(
                                  activeColor:
                                      Color.fromARGB(255, 250, 168, 171),
                                  value: isFemale,
                                  onChanged: (value) {
                                    setState(() {
                                      if (isMale == true) {
                                        isMale = false;
                                      }
                                      isFemale = true;
                                      _enteredGender = 'Kadın';
                                    });
                                  },
                                ),
                                SizedBox(width: 5),
                                Checkbox(
                                  activeColor: Color.fromARGB(255, 80, 86, 240),
                                  value: isMale,
                                  onChanged: (value) {
                                    setState(() {
                                      if (isFemale == true) {
                                        isFemale = false;
                                      }
                                      isMale = true;
                                      _enteredGender = 'Erkek';
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
                if (!widget.isSignIn) SizedBox(height: 12),
                if (!widget.isSignIn)
                  const Text(
                    "Telefon Numarası",
                    style: TextStyle(color: Colors.black54),
                  ),
                if (!widget.isSignIn)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 16),
                    child: TextFormField(
                      onSaved: (phoneNumber) {
                        _enteredPhone = phoneNumber;
                      },
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                          prefixIcon: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: SvgPicture.asset("assets/icons/phone.svg"),
                      )),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Zorunlu';
                        }
                      },
                    ),
                  ),
                if (!widget.isSignIn) SizedBox(height: 12),
                const Text(
                  "Email",
                  style: TextStyle(color: Colors.black54),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 16),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Lütfen geçerli bir mail adresi giriniz!';
                      }
                      if (widget.isSignIn) {
                        if (invalidCredentials) {
                          return "Lütfen bilgileri kontrol edip tekrar deneyin!";
                        }
                      } else if (userAlreadyExist) {
                        setState(() {
                          userAlreadyExist = false;
                        });
                        return 'Bu hesaba ait bir kullanıcı mevcut!';
                      }
                    },
                    keyboardType: TextInputType.emailAddress,
                    onSaved: (email) {
                      _enteredEmail = email!;
                    },
                    decoration: InputDecoration(
                        prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: SvgPicture.asset("assets/icons/email.svg"),
                    )),
                  ),
                ),
                const Text(
                  "Password",
                  style: TextStyle(color: Colors.black54),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 16),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty || value.length < 6) {
                        return 'Şifre en az 6 karakterden oluşmalıdır!.';
                      }
                    },
                    onSaved: (password) {
                      _enteredPassword = password!;
                    },
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                        prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: SvgPicture.asset("assets/icons/password.svg"),
                    )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 42),
                  child: ElevatedButton.icon(
                      onPressed: () {
                        signIn(context);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF77D8E),
                          minimumSize: const Size(double.infinity, 56),
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(25),
                                  bottomRight: Radius.circular(25),
                                  bottomLeft: Radius.circular(25)))),
                      icon: const Icon(
                        CupertinoIcons.arrow_right,
                        color: Color(0xFFFE0037),
                      ),
                      label: widget.isSignIn
                          ? const Text("Giriş Yap")
                          : const Text("Kaydol")),
                )
              ],
            )),
        isShowLoading
            ? CustomPositioned(
                child: RiveAnimation.asset(
                "assets/RiveAssets/check.riv",
                onInit: (artboard) {
                  StateMachineController controller =
                      getRiveController(artboard);
                  check = controller.findSMI("Check") as SMITrigger;
                  error = controller.findSMI("Error") as SMITrigger;
                  reset = controller.findSMI("Reset") as SMITrigger;
                },
              ))
            : const SizedBox(),
        isShowConfetti
            ? CustomPositioned(
                child: Transform.scale(
                scale: 6,
                child: RiveAnimation.asset(
                  "assets/RiveAssets/confetti.riv",
                  onInit: (artboard) {
                    StateMachineController controller =
                        getRiveController(artboard);
                    confetti =
                        controller.findSMI("Trigger explosion") as SMITrigger;
                  },
                ),
              ))
            : const SizedBox()
      ],
    );
  }
}

class CustomPositioned extends StatelessWidget {
  const CustomPositioned({super.key, required this.child, this.size = 100});
  final Widget child;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Column(
        children: [
          Spacer(),
          SizedBox(
            height: size,
            width: size,
            child: child,
          ),
          Spacer(flex: 2),
        ],
      ),
    );
  }
}
