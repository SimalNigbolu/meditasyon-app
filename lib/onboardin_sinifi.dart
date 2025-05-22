import 'package:flutter/widgets.dart';

class OnboardingStep extends StatelessWidget {
  final String title;
  final String description;
  final String buttonText;
  final VoidCallback onPressed;

  const OnboardingStep({
    required this.title,
    required this.description,
    required this.buttonText,
    required this.onPressed,
 
  });
  
  @override
  Widget build(BuildContext context) {
   
    throw UnimplementedError();
  }
}