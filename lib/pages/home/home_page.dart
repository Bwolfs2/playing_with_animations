import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showItems = false;
  bool showFloatActionButtom = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: showFloatActionButtom
          ? FloatingActionButton(
              onPressed: () {},
              child: Icon(Icons.add),
              backgroundColor: Colors.deepOrange,
            )
          : null,
      body: Column(
        children: [
          HeaderWidget(
            onEndAnimation: () {
              Future.delayed(Duration(milliseconds: 1200)).then(
                (value) => setState(() {
                  showFloatActionButtom = true;
                }),
              );
              setState(() {
                showItems = true;
              });
            },
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 110,
            child: Stack(
              children: [
                AnimatedPositioned(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.bounceOut,
                  left: showItems ? 0 : MediaQuery.of(context).size.width + 10,
                  child: Container(
                    height: 110,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: PhysicalModel(
                          color: Colors.transparent,
                          elevation: 4,
                          shape: BoxShape.circle,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(
                              index % 2 == 0 ? "https://miro.medium.com/fit/c/160/160/0*oKbaykGYA9H0Yk4C." : "https://yt3.ggpht.com/ytc/AAUvwnjdyZBf9W1EsD5h11d9_xD1XeFGTs_GiShrd7Aa=s900-c-k-c0x00ffffff-no-rj",
                            ),
                            radius: 50,
                          ),
                        ),
                      ),
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Column(
                  children: [
                    AnimatedOpacity(
                      duration: Duration(seconds: 2),
                      opacity: showItems ? 1 : 0,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          top: 16,
                        ),
                        child: Row(
                          children: [
                            Text(
                              "Products:",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return AnimatedPadding(
                              duration: Duration(milliseconds: 1500),
                              curve: Curves.bounceOut,
                              padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 16, top: showItems ? 0 : MediaQuery.of(context).size.height),
                              child: PhysicalModel(
                                color: index.isEven ? Colors.white : Colors.deepPurple,
                                elevation: 1,
                                borderRadius: BorderRadius.circular(15),
                                child: Container(
                                  child: ListTile(
                                    title: Text(
                                      "Product $index",
                                      style: TextStyle(color: index.isEven ? Colors.black87 : Colors.white70),
                                    ),
                                    trailing: Text(
                                      "\$ 20:00",
                                      style: TextStyle(
                                        color: index.isEven ? Colors.black87 : Colors.white70,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class HeaderWidget extends StatefulWidget {
  final Function onEndAnimation;

  const HeaderWidget({
    Key key,
    this.onEndAnimation,
  }) : super(key: key);

  @override
  _HeaderWidgetState createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;
  Animation<double> opacityAnimation;
  Animation<double> elevationAnimation;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(duration: Duration(milliseconds: 2000), vsync: this);

    animation = Tween<double>(begin: 0, end: 300.0).animate(
      CurvedAnimation(parent: animationController, curve: Interval(0, .4, curve: Curves.decelerate)),
    );

    opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: animationController, curve: Interval(.4, .8, curve: Curves.decelerate)),
    );

    elevationAnimation = Tween<double>(begin: 0, end: 4).animate(
      CurvedAnimation(parent: animationController, curve: Interval(.8, 1, curve: Curves.decelerate)),
    );

    animationController.forward();
    animationController.addListener(() {
      if (animationController.isCompleted) {
        widget.onEndAnimation();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      overflow: Overflow.visible,
      children: [
        AnimatedBuilder(
            animation: animationController,
            builder: (context, snapshot) {
              return PhysicalShape(
                elevation: elevationAnimation.value,
                clipper: MyClipper(),
                color: Colors.transparent,
                child: ClipPath(
                  clipper: MyClipper(),
                  child: Container(
                    decoration: BoxDecoration(color: Color(0xff2B2B2B)),
                    height: animation.value,
                  ),
                ),
              );
            }),
        AnimatedBuilder(
            animation: animationController,
            builder: (context, snapshot) {
              return Opacity(
                opacity: opacityAnimation.value,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16, top: 60, bottom: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                              icon: Icon(
                                Icons.menu,
                                color: Colors.white,
                                size: 40,
                              ),
                              onPressed: () {}),
                          Text(
                            "OVERVIEW",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          IconButton(
                              icon: Icon(
                                Icons.account_circle_rounded,
                                color: Colors.white,
                                size: 40,
                              ),
                              onPressed: () {}),
                        ],
                      ),
                    ),
                    PhysicalModel(
                      color: Color(0xff3DBBB0),
                      borderRadius: BorderRadius.circular(20),
                      shadowColor: Color(0xff3DBBB0),
                      elevation: elevationAnimation.value,
                      child: Container(
                        width: MediaQuery.of(context).size.width * .9,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xff3DBBB0),
                              Color(0xff11D7B8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "My Balances",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Add Money",
                                      style: TextStyle(fontSize: 18, color: Colors.white),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(
                                      Icons.add_circle_outline,
                                      color: Colors.white,
                                    )
                                  ],
                                )
                              ],
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: WalletCard(
                                  wallet: "MVR",
                                  value: 100.00,
                                )),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                    child: WalletCard(
                                  wallet: "USD",
                                  value: 0.00,
                                ))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            })
      ],
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, 337 - 60.0);
    path.quadraticBezierTo(size.width / 2, size.height, size.width, 337 - 60.0);
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class WalletCard extends StatelessWidget {
  final String wallet;
  final double value;

  const WalletCard({Key key, @required this.wallet, @required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PhysicalModel(
      elevation: 1,
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(
        15,
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xff53D5C9).withOpacity(.9),
          borderRadius: BorderRadius.circular(
            15,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Wallet ($wallet)",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15),
            Text(
              "Current Balance",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Text(
              value.toStringAsFixed(2),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
