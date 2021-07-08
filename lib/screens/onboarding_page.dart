import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trkar_vendor/screens/login.dart';
import 'package:trkar_vendor/utils/navigator.dart';
import 'package:trkar_vendor/utils/screen_size.dart';
import '../main.dart';

class OnboardingPage extends StatefulWidget {
  OnboardingPage({Key key}) : super(key: key);

  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final int _totalPages = 3;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  Widget _buildPageIndicator(bool isCurrentPage) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 350),
      margin: EdgeInsets.symmetric(horizontal: 4.0),
      height: isCurrentPage ? 12.0 : 8.0,
      width: isCurrentPage ? 12.0 : 8.0,
      decoration: BoxDecoration(
        color: isCurrentPage ? Colors.orange : Colors.grey[300],
        borderRadius: BorderRadius.all(Radius.circular(1)),
      ),
    );
  }

  @override
  void initState() {
    saveOnboardPageShared();
    super.initState();
    setInstance();
  }

  Future saveOnboardPageShared() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setBool("onboard", true);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark),
    );
    return Scaffold(
      body: Container(
        height: double.infinity,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            image: DecorationImage(
              image:
                  new ExactAssetImage('assets/images/onboardingBackground.png'),
              fit: BoxFit.fill,
            ),
            color: Color(0xff27332F),
          ),
          child: PageView(
            controller: _pageController,
            onPageChanged: (int page) {
              _currentPage = page;
              setState(() {});
            },
            children: <Widget>[
              _buildPageContent(
                  image: 'assets/images/logo.png',
                  title: 'تركار',
                  body: 'المنصة الأفضل لبيع قطع غيار السيارات والشاحنات.'),
              _buildPageContent(
                  image: 'assets/images/logo.png',
                  title: 'تركار',
                  body: 'سجل كبائع ليمكنك عرض منتجاتك لآلاف المستخدمين'),
              _buildPageContent(
                  image: 'assets/images/logo.png',
                  title: 'هيا بنا',
                  body: 'للمزيد من المعلومات قم بزيارة موقعنا ww w.trkar.com'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageContent({
    String image,
    String title,
    String body,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _currentPage == 2
              ? Container(
                  child: Align(
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/logo.png',
                          width: ScreenUtil.getWidth(context) / 1.7,
                          fit: BoxFit.contain,
                          // color: themeColor.getColor(),
                        ),
                        Container(
                          width: ScreenUtil.getWidth(context) / 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                'vendor',
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                'البائع',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil.getHeight(context) / 8,
                        ),
                        Container(
                          height: 50,
                          width: ScreenUtil.getWidth(context) / 1.4,
                          child: FlatButton(
                            color: Colors.orange,
                            onPressed: () {
                              Nav.routeReplacement(context, LoginPage());
                            },
                            child: Text(
                              "دخول التطبيق",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil.getHeight(context) / 25,
                        ),
                        Container(
                          height: 50,
                          width: ScreenUtil.getWidth(context) / 1.4,
                          child: FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(1),
                                side:
                                    BorderSide(color: Colors.orange, width: 2)),
                            color: Colors.white,
                            onPressed: () {
                              Nav.routeReplacement(context, LoginPage());
                            },
                            child: Text(
                              "سجل كبائع",
                              style: TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Container(),
          _currentPage == 2
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          height: 2.0,
                          fontWeight: FontWeight.w800,
                          color: Colors.white),
                    ),
                    SizedBox(height: 32),
                    Image.asset(
                      image,
                      fit: BoxFit.fill,
                      height: ScreenUtil.getHeight(context) / 20,
                    ),
                  ],
                ),
          SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: AutoSizeText(
              body,
              minFontSize: 30,
              maxFontSize: 35,
              maxLines: 3,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
            ),
          ),
          SizedBox(height: 32),

          _currentPage != 2
              ? Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FlatButton(
                        onPressed: () {
                          _pageController.animateToPage(2,
                              duration: Duration(milliseconds: 400),
                              curve: Curves.linear);
                          setState(() {});
                          Nav.routeReplacement(context, LoginPage());
                        },
                        splashColor: Colors.blue[50],
                        child: Text(
                          'تخطى',
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                      ),
                      Container(
                        child: Row(children: [
                          for (int i = 0; i < _totalPages; i++)
                            i == _currentPage
                                ? _buildPageIndicator(true)
                                : _buildPageIndicator(false)
                        ]),
                      ),
                      FlatButton(
                        onPressed: () {
                          _pageController.animateToPage(_currentPage + 1,
                              duration: Duration(milliseconds: 400),
                              curve: Curves.linear);
                          setState(() {});
                        },
                        splashColor: Colors.blue[50],
                        child: Text(
                          'التالى',
                          style: TextStyle(color: Colors.orange),
                        ),
                      )
                    ],
                  ),
                )
              : Container(
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (int i = 0; i < _totalPages; i++)
                          i == _currentPage
                              ? _buildPageIndicator(true)
                              : _buildPageIndicator(false)
                      ]),
                ),
          SizedBox(
            height: ScreenUtil.getHeight(context) / 25,
          )
        ],
      ),
    );
  }

  Future<void> setInstance() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("instance", 'done');
  }
}
