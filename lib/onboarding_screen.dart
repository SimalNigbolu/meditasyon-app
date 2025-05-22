import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingScreen extends StatelessWidget {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFA7A8F5),
      body: PageView(
        controller: _pageController,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 225,
                left: 1,
                child: SvgPicture.asset(
                  'resimler/bg.svg',
                  height: 350,
                  width: 200,
                ),
              ),
              Positioned(
                top: 210,
                child: SvgPicture.asset(
                  'resimler/illustartion.svg',
                  height: 500,
                  width: 325,
                ),
              ),
              Positioned(
                top: 600,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/giris');
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                    backgroundColor: Color(0xff371B34),
                  ),
                  child: Text(
                    "Başlayalım mı?",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0XFFFAFAFA),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 70,
                child: Text(
                  'Hey!',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Color(0XFFFAFAFA),
                  ),
                ),
              ),
              Positioned(
                top: 140,
                child: Text(
                  'İyileşmeye Hazır mısın?',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0XFFFAFAFA),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
