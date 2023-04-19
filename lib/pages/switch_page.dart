part of 'package:user/modules/page_switcher.dart';


class SwitchPage extends StatelessWidget {

  final Widget destinationPage;
  final String lottiePath;
  final String label;
  final PageTransitionType animation;

  const SwitchPage({
    super.key,
    required this.destinationPage,
    required this.lottiePath,
    required this.label,
    required this.animation,
  });

  
  @override
  Widget build(BuildContext context) {
    Timer(
      const Duration(seconds: 2),
      () => Navigator.of(context).pushReplacement(
        PageTransition(
          child: destinationPage,
          type: animation,
        ),
      ),
    );

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                lottiePath,
                repeat: false,
                width: 100,
                height: 100,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 18,
                    letterSpacing: 2,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}