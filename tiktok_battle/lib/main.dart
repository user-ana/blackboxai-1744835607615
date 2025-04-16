import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TikTok Battle',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        textTheme: GoogleFonts.chakraPetchTextTheme(
          ThemeData.dark().textTheme,
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Particle Background
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                backgroundBlendMode: BlendMode.screen,
              ),
              child: Lottie.network(
                'https://assets5.lottiefiles.com/packages/lf20_yNYxCH.json',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.black,
                  child: CustomPaint(
                    painter: ParticlePainter(),
                  ),
                ),
              ),
            ),
          ),

          // Main Content
          Column(
            children: [
              const SizedBox(height: 40),
              // Animated Title
              AnimatedTextKit(
                animatedTexts: [
                  FlickerAnimatedText(
                    '🔥 ALVAROTHEBADBOY 🔥',
                    textStyle: GoogleFonts.orbitron(
                      fontSize: 32,
                      color: Colors.red,
                      shadows: [
                        const Shadow(
                          color: Colors.red,
                          blurRadius: 10,
                          offset: Offset(0, 0),
                        ),
                        const Shadow(
                          color: Colors.redAccent,
                          blurRadius: 20,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                  ),
                ],
                repeatForever: true,
              ),

              // Video Player Area
              Expanded(
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.6,
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.red.withOpacity(0.5),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.2),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // MVP Carousel
              SizedBox(
                height: 150,
                child: CarouselSlider.builder(
                  itemCount: 10,
                  options: CarouselOptions(
                    height: 120,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    viewportFraction: 0.3,
                    autoPlayInterval: const Duration(seconds: 3),
                    autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  ),
                  itemBuilder: (context, index, realIndex) {
                    return MVPCard(
                      index: index,
                      key: ValueKey(index),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),

          // Floating Mic Button
          Positioned(
            right: 30,
            bottom: 30,
            child: GlowingMicButton(),
          ),
        ],
      ),
    );
  }
}

class MVPCard extends StatelessWidget {
  final int index;

  const MVPCard({required this.index, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.5),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.blue,
                width: 2,
              ),
              gradient: LinearGradient(
                colors: [
                  Colors.blue.shade900,
                  Colors.blue.shade400,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Text(
                '[${String.fromCharCode(65 + index)}]',
                style: GoogleFonts.orbitron(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'MVP ${index + 1}',
            style: GoogleFonts.orbitron(
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class GlowingMicButton extends StatefulWidget {
  const GlowingMicButton({super.key});

  @override
  State<GlowingMicButton> createState() => _GlowingMicButtonState();
}

class _GlowingMicButtonState extends State<GlowingMicButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 1, end: 2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.red,
            boxShadow: [
              BoxShadow(
                color: Colors.red.withOpacity(0.6),
                blurRadius: 20 * _animation.value,
                spreadRadius: 5 * _animation.value,
              ),
            ],
          ),
          child: const Icon(
            Icons.mic,
            color: Colors.white,
            size: 30,
          ),
        );
      },
    );
  }
}

class ParticlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    for (var i = 0; i < 100; i++) {
      canvas.drawCircle(
        Offset(
          (i * size.width / 100),
          (i * size.height / 100),
        ),
        2,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
