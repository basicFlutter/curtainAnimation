import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rive/rive.dart';


class Curtain extends StatefulWidget {
  const Curtain({Key? key}) : super(key: key);
  @override
  _CurtainState createState() => _CurtainState();
}

class _CurtainState extends State<Curtain> {


  int indexSelected = 0;
  bool checkConnection = false;
  Artboard? _riveArtboard;
  late RiveAnimationController _controller;
  bool get isPlaying => _controller.isActive ;


  @override
  void initState() {
    super.initState();
    _curtain('open');
  }




  void _curtain(String status) {
    rootBundle.load('assets/pardebarghi.riv',).then(
          (data) async {
        final file = RiveFile.import(data);
        final artBoard = file.mainArtboard;
        artBoard.addController(_controller = SimpleAnimation(status));
        setState(() => _riveArtboard = artBoard);
      },
    );
    setState((){});
  }

  void _stop() {
    setState(() => _controller.isActive = !_controller.isActive);
  }

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(
              width: screenWidth * 0.042,
              height: screenHeight * 0.042,
              child: SvgPicture.asset("assets/images/insta.svg",
                  color: Colors.grey),
            ),
            SizedBox(
              width:screenWidth*0.02,
            ),
            const Text("basic_flutter",style: TextStyle(color: Colors.grey),),
          ],
        ),
        centerTitle: true,
      ),
        resizeToAvoidBottomInset: false,
        body:SizedBox(
          width: screenWidth,
          height: screenHeight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: screenHeight * 0.1,
              ),
              SizedBox(
                height: screenHeight * 0.55,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                   _riveArtboard != null ? Rive(
                      artboard: _riveArtboard!,
                    ) : const SizedBox(),
                    GestureDetector(
                      onHorizontalDragUpdate: (details) {
                        details.primaryDelta!.floor() >= 0  ? _curtain('open'): _curtain('close');
                      },
                      onTap: () {
                        // _stop();
                      },
                    ),
                  ],
                ),
              ),

            ],
          ),
        )
    );
  }
}
