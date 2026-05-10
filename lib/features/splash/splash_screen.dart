import 'package:flutter/material.dart';
import 'package:ruang_sehat/theme/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ruang_sehat/features/auth/presentation/widget/auth_form.dart';
import 'package:ruang_sehat/features/auth/presentation/screens/auth_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const String routeName = '/splash-screen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _iconController;
  late AnimationController _textController;

  late Animation<Offset> _slideAnimation;
  late Animation<double> _textAnimation;

  @override
  void initState() {
    super.initState();
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _slideAnimation =
        Tween<Offset>(
          begin: const Offset(0, -10),
          end: const Offset(0, -0.5),
        ).animate(
          CurvedAnimation(parent: _iconController, curve: Curves.bounceOut),
        );

     _textAnimation = Tween<double>(
          begin: 0,
          end: 1,
        ).animate(
          CurvedAnimation(parent: _textController, curve: Curves.easeIn),
        );
    _iconController.forward();

    _iconController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _textController.forward();
      }
    });

    _textController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pushReplacementNamed(context, AuthScreen.routeName);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SlideTransition(
                position: _slideAnimation,
                child: SvgPicture.asset('assets/icons/logo.svg', width: 60),
              ),
              AnimatedBuilder(
                animation: _textAnimation,
                builder: (context, child) {
                  return ClipRect(
                    child: Align(
                      alignment: Alignment.center,
                      widthFactor: _textAnimation.value,
                      child: child,
                    ),
                  );
                },
                child: const Text(
                  'Ruang Sehat',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
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