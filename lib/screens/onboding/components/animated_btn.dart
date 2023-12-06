import 'package:flutter/cupertino.dart';
import 'package:rive/rive.dart';

class AnimatedBtn extends StatelessWidget {
  const AnimatedBtn({
    super.key,
    required RiveAnimationController btnAnimationController,
    required this.press,
  }) : _btnAnimationController = btnAnimationController;

  final RiveAnimationController _btnAnimationController;
  final VoidCallback press;   // buton fonksiyonu

  @override
  Widget build(BuildContext context) {
    return GestureDetector(  // kullanıcı etkileşimlerine yanıt veren bileşenlerin oluşturulmasında yaygın olarak kullanılır. 
      onTap: press,
      child: SizedBox(
        height: 64,
        width: 260,
        child: Stack(children: [
          RiveAnimation.asset(    // rive button animasyonunu
            "assets/RiveAssets/button.riv",
            controllers: [_btnAnimationController],
          ),
          const Positioned.fill(
              top: 8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.arrow_right),
                  SizedBox(
                    width: 8,
                  ),
                  Text("Şİmdi başla",
                      style: TextStyle(fontWeight: FontWeight.w600))
                ],
              )),
        ]),
      ),
    );
  }
}
