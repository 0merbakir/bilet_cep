import 'package:bilet_cep/screens/onboding/components/sign_in_form.dart';
import 'package:flutter/material.dart';

// Özel bir kayıt oluşturma iletişim kutusu göstermek için kullanılan işlev.
Future<Object?> customSignUpDialog(BuildContext context, {required ValueChanged onClosed}) {
  return showGeneralDialog(
    barrierDismissible: true, // Dışarı tıklayarak kapatılabilir mi?
    barrierLabel: "kayit", // Engelleme etiketi
    context: context,
    transitionDuration: const Duration(milliseconds: 400), // Geçiş süresi
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      Tween<Offset> tween = Tween(begin: Offset(0, -1), end: Offset.zero);
      return SlideTransition(
        position: tween.animate(
          CurvedAnimation(parent: animation, curve: Curves.easeInOut),
        ),
        child: child,
      );
    },
    pageBuilder: (context, _, __) => Center(
      child: Container(
        height: 550,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: const BorderRadius.all(Radius.circular(40)),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false, // Klavye gösterildiğinde taşma hatasını önler.
          body: SingleChildScrollView( // Wrap the content in SingleChildScrollView
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Column(children: [
                  const Text(
                    "Kayıt Ol",
                    style: TextStyle(fontSize: 34, fontFamily: "Poppins"),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      "BiletCep ile yolculuklarınızı düşündüğünüzden daha kolay hale getirin. Hemen bilet alın ve yola çıkın",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SignInForm(isSignIn: false), // Kayıt formunu içeren widget.
                  const Row(
                    children: [
                      Expanded(
                        child: Divider(),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                      Expanded(
                        child: Divider(),
                      ),
                    ],
                  ),
                ]),
                const Positioned(
                  left: 0,
                  right: 0,
                  bottom: -48,
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.close, color: Colors.black),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ),
  ).then(onClosed); // İletişim kutusu kapatıldığında gerçekleşecek işlemi belirler.
}
