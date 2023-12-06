import 'package:bilet_cep/screens/onboding/components/custom_sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:bilet_cep/screens/onboding/components/sign_in_form.dart';

// Özel bir giriş iletişim kutusu veya penceresi görüntülemek için kullanılır.
Future<Object?> customSigninDialog(BuildContext context,
    {required ValueChanged onClosed}) {
  return showGeneralDialog(
    barrierDismissible: true, // Dışarı tıklayarak kapatılabilir mi?
    barrierLabel: "giris", // Engelleme etiketi
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
        height: 670,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: const BorderRadius.all(Radius.circular(40)),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false, // Klavye açıkken taşma hatasını önle
          body: Stack(
            clipBehavior: Clip.none,
            children: [
              Column(children: [
                const Text(
                  "Giriş Yap",
                  style: TextStyle(fontSize: 34, fontFamily: "Poppins"),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    "BiletCep ile yolculuklarınızı düşündüğünüzden daha kolay hale getirin. Hemen bilet alın ve yola çıkın",
                    textAlign: TextAlign.center,
                  ),
                ),
                SignInForm(isSignIn: true), // Giriş formu
                const Row(
                  children: [
                    Expanded(
                      child: Divider(),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "Yada",
                        style: TextStyle(color: Colors.black26),
                      ),
                    ),
                    Expanded(
                      child: Divider(),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: Text("Email veya Google ile kaydol",
                      style: TextStyle(color: Colors.black54)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        Navigator.pop(context);
                        customSignUpDialog(context, onClosed: (_) {});
                      },
                      icon: SvgPicture.asset(
                        "assets/icons/email.svg",
                        height: 64,
                        width: 64,
                      ),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        // google Auth
                      },
                      icon: SvgPicture.asset(
                        "assets/icons/google_box.svg",
                        height: 64,
                        width: 64,
                      ),
                    ),
                  ],
                )
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
  ).then(onClosed); // İletişim kutusu kapatıldığında çağrılacak işlev
}
