import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:bilet_cep/screens/onboding/components/animated_btn.dart';
import 'package:bilet_cep/screens/onboding/components/custom_sign_in.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  bool isSignInDialogShown = false; // SignIn ekranının gösterilip gösterilmeyeceğini tutar
  late RiveAnimationController _btnAnimationController; // Rive animasyon denetleyicisi.

  @override
  void initState() {   
    _btnAnimationController = OneShotAnimation("active", autoplay: false); // Rive animasyon denetleyicisinin başlatılması.
    super.initState();
  }

  //Animasyonlar ve geçişler, çoğu zaman build metodu içinde kullanılır. Eğer AnimationController nesneleri her build 
  //çağrısında tekrar tanımlanırsa, gereksiz yere bellek ve işlemci kaynakları tüketilebilir.
  // initState içinde tanımlandığında, bu nesneler sadece bir kez oluşturulur ve gereksiz tekrar oluşturulmaz.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            width: MediaQuery.of(context).size.width * 1.7, 
            bottom: 200,
            left: 100,
            child: Image.asset('assets/Backgrounds/kapadokya.jpg'),
          ), // Arka plan resmi.

            //MediaQuery sınıfı, cihazın ekran boyutu, oryantasyonu ve piksel 
            //yoğunluğu gibi çeşitli cihaz özelliklerini almak ve kullanmak için kullanılan bir sınıftır.          

          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            ), // Bulanıklaştırma efekti ekleyen bir widget.
          ),

          const RiveAnimation.asset('assets/RiveAssets/shapes.riv'), // Rive animasyonunu gösteren widget.

          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: const SizedBox(),
            ), // Yine bulanıklaştırma efekti ekleyen bir widget.
          ),

          AnimatedPositioned(
            duration: const Duration(milliseconds: 240),
            top: isSignInDialogShown ? -50 : 0,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SafeArea(  //  widget'i, içeriğin bu güvenli bölgelere yayılmasını engeller.
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    SizedBox(
                      width: 260,
                      child: Column(children: [
                        const Text(
                          "BiletCep iyi yolculuklar diler.",
                          style: TextStyle(
                            fontSize: 40,
                            fontFamily: "Poppins",
                            height: 1.2,
                            color: Color.fromARGB(187, 86, 83, 83),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          "BiletCep, seyahat biletlerinizi düzenlemenin ve erişmenin kolay yolunu sunar. Trenlerden uçaklara, otobüslerden feribotlara kadar tüm yolculuklarınızı tek bir mobil uygulama üzerinden yönetin.",
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(fontStyle: FontStyle.italic),
                        ),
                      ]),
                    ),
                    const Spacer(
                      flex: 2,
                    ),
                    AnimatedBtn(  // custom widget olan AnimatedBtn burada çağırılır
                      btnAnimationController: _btnAnimationController,
                      press: () {     // butona basıldığında isSignInDialogShown aktif olur
                        _btnAnimationController.isActive = true;
                        Future.delayed(Duration(milliseconds: 800), () {
                          setState(() {
                            isSignInDialogShown = true;
                          });
                          customSigninDialog(context, onClosed: (_) {   // customSigninDialog gösterilir
                            setState(() { // görünüm kapatıldığında
                              isSignInDialogShown = false;
                            });
                          });
                        });
                      },
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40.0),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
