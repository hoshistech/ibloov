import 'package:flutter/material.dart';

class CustomNavBarItem {
  const CustomNavBarItem({
    @required this.icon,
    @required this.title,
    this.type = 0,
  });
  final Object icon;
  final String title;
  final int type;
}

class CustomNavBar extends StatefulWidget {
  final int currentIndex;
  const CustomNavBar({this.currentIndex, this.onTap, this.items});
  final Function(int) onTap;
  final List<CustomNavBarItem> items;
  @override
  _CustomNavBarState createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  var width, height;
  int currentIndex = 0;
  List<CustomNavBarItem> icons;
  setBottomBarIndex(index) {
    widget.onTap(index);
    setState(() {
      currentIndex = index;
    });
  }

  @override
  void initState() {
    icons = widget.items;
    super.initState();
  }

  int get tappedValue => currentIndex;

  Widget _buildItem(CustomNavBarItem item, index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        (item.type == 1)
            ? InkWell(
          onTap: () {
            setBottomBarIndex(index);
          },
          child: Container(
            padding: EdgeInsets.all(10),
            width: width * .12,
            height: width * .12,
            child: Visibility(
              visible: (currentIndex == index) ? false : true,
              child: CircleAvatar(
                backgroundImage: item.icon,
                radius: 23.0,
              ),
            ),
          ),
        )
            : IconButton(
            icon: ImageIcon(
              item.icon,
              color: currentIndex == index
                  ? Colors.transparent
                  : Colors.grey.shade400,
            ),
            onPressed: () {
              setBottomBarIndex(index);
            }),

        Text(
          item.title,
          style: TextStyle(
              fontWeight:
              currentIndex == index ? FontWeight.bold : FontWeight.normal,
              fontSize: 12),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Container(
      width: size.width,
      height: height * .11,

      color: Colors.transparent,
      child: Stack(

        clipBehavior: Clip.antiAlias,
        children: [
          CustomPaint(
            size: Size(size.width, height * 0.13168),
            painter: BNBCustomPainter(currentIndex),
          ),
          Positioned(
            left:width*0.06+width*0.2*currentIndex-currentIndex*width*0.01,
            // left: width * 0.024 +
            //     width * 0.036 +
            //     (width * 0.194 * currentIndex * 1.0 -
            //         currentIndex * width * 0.004375),
            child: Center(
              heightFactor: height * 0.00058529,
              child: FloatingActionButton(
                  backgroundColor: Color(0xFF00237B),
                  child: (currentIndex == 3)
                      ? Container(
                    padding: EdgeInsets.all(10),
                    child: CircleAvatar(
                      backgroundImage: icons[currentIndex].icon,
                      radius: 23.0,
                    ),
                  )
                      : ImageIcon(icons[currentIndex].icon),
                  elevation: 0.1,
                  onPressed: () {}),
            ),
          ),
          Container(
            color: Colors.transparent,
            width: size.width,
            // height: width * 0.194,
            padding: EdgeInsets.only(left: width * 0.014572, right: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (int i = 0; i < widget.items.length; i++)
                  _buildItem(icons[i], i)
              ],
            ),
          ),
          Positioned(
            left: width * 0.0701 +
                width * 0.036 +
                (width * 0.192 * currentIndex * 1.0 - currentIndex),
            bottom: height * 0.02911,
            child: Center(
              // heightFactor: height * 0.0000316054,
                child: MyArc(
                  diameter: 18,
                )),
          ),
        ],
      ),
    );
  }
}

class BNBCustomPainter extends CustomPainter {
  int index;
  BNBCustomPainter(int index) {
    this.index = index;
  }
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    var t = 0.28 - 0.19 * index;
    Path path = Path();
    path.moveTo(0, 0); // Start
    path.quadraticBezierTo(
        size.width * (0.10 - t), 0, size.width * (0.30 - t), 0);
    path.quadraticBezierTo(
        size.width * (0.32 - t), 0, size.width * (0.32 - t), 10);
    path.arcToPoint(Offset(size.width * (0.50 - t), 10),
        radius: Radius.circular(1.0), clockwise: false);
    path.quadraticBezierTo(
        size.width * (0.50 - t), 0, size.width * (0.55 - t), 0);
    path.quadraticBezierTo(size.width * (0.70 - t), 0, size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 0);
    canvas.drawShadow(path, Colors.black, 5, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class MyArc extends StatelessWidget {
  final double diameter;

  const MyArc({Key key, this.diameter = 200}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: MyPainter(),
      size: Size(diameter, diameter),
    );
  }
}

// This is the Painter class
class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.blue;
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.height / 2, size.width / 2),
        height: size.height,
        width: size.width,
      ),
      0,
      3.14,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
