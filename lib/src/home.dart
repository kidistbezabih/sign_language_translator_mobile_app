import 'package:flutter/material.dart';
import 'package:sign_language_translater/src/list.dart';

import 'widgets/common_button.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  static const routeName = '/home';

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool showHome = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      floatingActionButton: !showHome
          ? AnimatedOpacity(
              opacity: showHome ? 0.0 : 1.0,
              duration: const Duration(
                milliseconds: 300,
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      showHome = true;
                    });
                    // Navigator.pushNamed(context, '/tabs');
                  },
                  tooltip: 'Drawer',
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  child: const Icon(
                    Icons.apps,
                    size: 45,
                    color: Color(0xFF4053B5),
                  ),
                ),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Expanded(
              flex: 2,
              child: SizedBox(),
            ),
            showHome
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CommonButton(
                        titleWidget: const Text(
                          "Transcribe",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        color: const Color(0xFF4053B5),
                        onPressed: () {
                          Navigator.pushNamed(context, '/transcribe');
                        },
                      ),
                      CommonButton(
                        titleWidget: const Text(
                          "Others",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            showHome = false;
                          });
                          // Navigator.pushNamed(context, '/tabs');
                        },
                      ),
                    ],
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CommonButton(
                        titleWidget: const Text(
                          "Learning",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        color: const Color(0xFF4053B5),
                        onPressed: () {
                          Navigator.pushNamed(context, TabsView.routeName);
                        },
                      ),
                      CommonButton(
                        titleWidget: const Text(
                          "Quiz",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          // Navigator.pushNamed(context, '/tabs');
                        },
                      ),
                    ],
                  ),
            const Expanded(
              flex: 3,
              child: SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
