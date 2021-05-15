import 'package:flutter/material.dart';

final Color darkBlue = Color.fromARGB(255, 18, 32, 47);

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isSmall = width < 950;
    return MaterialApp(
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: darkBlue),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        // Outer white container with padding
        body: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 80),
          // Inner yellow container
          child: Container(
            // pass double.infinity to prevent shrinking of the painter area to 0.
            width: width * 0.99995,
            height: double.infinity,
            color: Colors.white60,
            child: CustomPaint(painter: FaceOutlinePainter()),
          ),
        ),
      ),
    );
  }
}

class FaceOutlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..color = Colors.indigo;

    double squareSize = size.width / 10.0;

    //drawRect(canvas, squareSize, paint);
    drawFrets(canvas, squareSize, paint);
    drawStrings(canvas, squareSize, paint);

    drawMarkers(squareSize, paint, canvas);

    for (double across = 0; across < 6; across++)
      drawCircles(across, squareSize, paint, canvas);


  }

  @override
  bool shouldRepaint(FaceOutlinePainter oldDelegate) => false;
}

void drawFrets(canvas, squareSize, paint) {

  double half= squareSize/2;
  paint.color = Colors.cyan;
  for (double down = 0; down < 13; down++) { //
    canvas.drawLine(Offset(half, down* squareSize +half), Offset(squareSize*5.5, down* squareSize+half), paint);
  }
}

void drawStrings(canvas, squareSize, paint) {

  double half= squareSize/2;
  paint.color = Colors.amberAccent;
  for (double across = 0; across < 6; across++)
    canvas.drawLine(Offset( across* squareSize +half,half), Offset( across* squareSize+half,squareSize*12.5), paint);
}

void drawRect(canvas, squareSize, paint) {
  double fontsize = squareSize / 1.5;

  for (double down = 0; down < 12; down++) {
    for (double across = 0; across < 5; across++) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(squareSize * across + (squareSize / 2),
                (down * squareSize) + (squareSize / 2), squareSize, squareSize),
            Radius.circular(0)),
        paint,
      );
    }
  }
}

void drawCircles(across, squareSize, paint, canvas) {
  final data = [
    [5, 0, 7, 2, 10, 5],
    [7, 2, 9, 4, 0, 7],
    [8, 3, 10, 5, 1, 8],
    [10, 5, 0, 7, 3, 10],
    [0, 7, 2, 9, 5, 0],
    [1, 8, 3, 10, 6, 1],
    [3, 10, 5, 0, 8, 3],
  ];
  int down = data[5][across.round()];
  paint.style = PaintingStyle.fill;
  double fontsize = squareSize / 1.3;
  final textStyle = TextStyle(
    color: Colors.red,
    fontSize: 30,
  );
  final textStyle2 = TextStyle(
    color: Colors.white,
    fontSize: fontsize,
  );


  paint.color = Colors.red;
  canvas.drawOval(
    Rect.fromLTWH(
        squareSize * across, squareSize * down, squareSize, squareSize),
    paint,
  );

  TextSpan span2 = new TextSpan(text: down.toString(), style: textStyle2);
  TextPainter tp = new TextPainter(
      text: span2, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
  tp.text = span2;
  tp.layout();
  if (down < 10)
    tp.paint(canvas,
        new Offset(squareSize * across + (squareSize / 4), squareSize * down +squareSize/15));
  else
    tp.paint(canvas,
        new Offset(squareSize * across + (squareSize / 35), squareSize * down +squareSize/15));
  paint.style = PaintingStyle.stroke;
}

void drawMarkers(squareSize, paint, canvas) {
  final data = [3, 5, 7, 9, 12];
  paint.color = Colors.black;
  paint.style = PaintingStyle.fill;
  for (int i = 0; i < data.length-1; i++) {
    canvas.drawOval(
      Rect.fromLTWH(squareSize * 2.75, squareSize * (data[i] - 0.25),
          squareSize / 2, squareSize / 2),
      paint,
    );
  }
  canvas.drawOval(
    Rect.fromLTWH(squareSize * 1.75, squareSize * (data[data.length-1] - 0.25),
        squareSize / 2, squareSize / 2),
    paint,
  );
  canvas.drawOval(
    Rect.fromLTWH(squareSize * 3.75, squareSize * (data[data.length-1] - 0.25),
        squareSize / 2, squareSize / 2),
    paint,
  );
  paint.style = PaintingStyle.stroke;
}

double getScreenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double getScreenHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double getScreenHeightSafe(BuildContext context) {
// Height (without SafeArea)
  var padding = MediaQuery.of(context).padding;
  return getScreenHeight(context) - padding.top - padding.bottom;
}
