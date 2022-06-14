import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled6/DatabaseHandler/DbHelper.dart';
import 'package:untitled6/Screens/HomeForm.dart';
import 'package:untitled6/Screens/detailForm.dart';
import 'package:untitled6/Screens/mainmenu.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';

import 'LoginForm.dart';

class News_page extends StatelessWidget {
  final List<String> selectedItems;
  final List<String> selectedCategory;
  News_page({Key? key, required this.selectedItems, required this.selectedCategory}) : super(key: key);

  int initPosition = 0;

  List<String> title = [];

  List<String> href = [];

  List<String> date = [];

  List<String> looks = [];

  List<String> image = [];

  final List<String> items = [];

  fetchHttp() async {
    title.clear();
    for (int i = 0; i < selectedItems.length; i++) {
      final response =
      await http.Client().get(
          Uri.parse('https://ria.ru/' + selectedCategory[i] + '/'));
      if (response.statusCode == 200) {
        var document = parse(response.body);

        for(int i=0; i < 10; i++){
          title.add(document.getElementsByClassName('list-item__title color-font-hover-only')[i].text);
          href.add(document.getElementsByClassName('list-item__title color-font-hover-only')[i].attributes['href'].toString());
          date.add(document.getElementsByClassName('list-item__date')[i].text);
          looks.add(document.getElementsByClassName('list-item__views-text')[i].text);
          image.add(document.getElementsByClassName('list-item__image')[i].getElementsByTagName('picture')[0].getElementsByTagName('img')[0].attributes['src'].toString());
        }
      }
    }
    print('Заголовок:'+ title.length.toString());
    print('ссылок:'+ href.length.toString());
    print('Дат:'+ date.length.toString());
    print('Картинок:'+ image.length.toString());
    print(title[0]);
    print(title[50]);
    print(title[100]);
    print(title[150]);
    print(title[200]);
    return title;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      drawer: Drawer(child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            onDetailsPressed: (){Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => HomeForm()));},
            accountName: Text('Личный кабинет'
            ),
            accountEmail: Text('Пользователя'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: FlutterLogo(size: 42.0),
            ),
          ),
          ListTile(
            title: const Text('Фильтр'),
            subtitle: Text('Настройки предпочтений'),
            leading: Icon(Icons.settings),
            onTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
              selectedItems.clear();
              selectedCategory.clear();
            },
          ),
          SizedBox(height: 20),
          Center(
            child: TextButton(onPressed: (){Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => LoginForm()), (Route<dynamic> route) => false);}, child: Text('Выйти', style: TextStyle(color: Colors.red),)),
          )
        ],
      )
      ),
      appBar: PreferredSize(preferredSize: Size.fromHeight(40),child: AppBar(backgroundColor: Colors.transparent,elevation: 0,)),

      body: SafeArea(
        child: CustomTabView(
          initPosition: initPosition,
          itemCount: selectedItems.length,
          tabBuilder: (context, index) => Tab(text: selectedItems[index]),
          pageBuilder: (context, index) =>
              FutureBuilder(
                  future: fetchHttp(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (title.length == 0) {
                      return Center(child: CircularProgressIndicator(),);
                    }
                    else {
                      return Container(
                          child: ListView.builder(
                              itemCount: 10,
                              itemBuilder: (BuildContext context, int indexx) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (_) =>
                                            Detail_page(heading: title[indexx +
                                                (index * (10 *
                                                    selectedItems.length))],
                                              href: href[indexx + (index * (10 * selectedItems.length))],
                                              date: date[indexx + (index * (10 * selectedItems.length))],
                                              image: image[indexx +
                                                  (index * (10 * selectedItems.length))],)));
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(12.0),
                                    padding: EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                            12.0),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 3.0,
                                          ),
                                        ]),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment
                                          .start,
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: [
                                        Container(
                                          height: 200.0,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            //let's add the height

                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    image[indexx + (index *
                                                        (10 * selectedItems
                                                            .length))]),
                                                fit: BoxFit.cover),
                                            borderRadius: BorderRadius.circular(
                                                12.0),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 8.0,
                                        ),
                                        Container(

                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(Icons
                                                        .access_time_outlined,
                                                      size: 16,),
                                                    SizedBox(width: 5),
                                                    Text(date[indexx + (index *
                                                        (10 * selectedItems
                                                            .length))],
                                                      style: GoogleFonts.dosis(
                                                          fontSize: 13),),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Icon(Icons
                                                        .remove_red_eye_sharp,
                                                      size: 16,),
                                                    SizedBox(width: 5),
                                                    Text(looks[indexx + (index *
                                                        (10 * selectedItems
                                                            .length))],
                                                      style: GoogleFonts.dosis(
                                                          fontSize: 13),),
                                                  ],
                                                )
                                              ],
                                            )
                                        ),
                                        SizedBox(
                                          height: 8.0,
                                        ),
                                        Text(
                                            title[indexx + (index *
                                                (10 * selectedItems.length))],
                                            style: GoogleFonts.dosis(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w300)
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }
                          )
                      );
                    }
                  }
              ),
          onPositionChange: (index){
            print(title.length);
          },
          onScroll: (position) {
          },
          stub: Container(child: Center(child: Text('Вы не выбрали категории новостей'),),),
        ),
      ),
    );
  }
}




/// Implementation

class CustomTabView extends StatefulWidget {
  final int itemCount;
  final IndexedWidgetBuilder tabBuilder;
  final IndexedWidgetBuilder pageBuilder;
  final Widget stub;
  final ValueChanged<int> onPositionChange;
  final ValueChanged<double> onScroll;
  final int initPosition;

  CustomTabView({
    required this.itemCount,
    required this.tabBuilder,
    required this.pageBuilder,
    required this.stub,
    required this.onPositionChange,
    required this.onScroll,
    required this.initPosition,
  });

  @override
  _CustomTabsState createState() => _CustomTabsState();
}

class _CustomTabsState extends State<CustomTabView> with TickerProviderStateMixin {
  late TabController controller;
  late int _currentCount;
  late int _currentPosition;

  @override
  void initState() {
    _currentPosition = widget.initPosition;
    controller = TabController(
      length: widget.itemCount,
      vsync: this,
      initialIndex: _currentPosition,
    );
    controller.addListener(onPositionChange);
    controller.animation?.addListener(onScroll);
    _currentCount = widget.itemCount;
    super.initState();
  }

  @override
  void didUpdateWidget(CustomTabView oldWidget) {
    if (_currentCount != widget.itemCount) {
      controller.animation?.removeListener(onScroll);
      controller.removeListener(onPositionChange);
      controller.dispose();

      if (widget.initPosition != null) {
        _currentPosition = widget.initPosition;
      }

      if (_currentPosition > widget.itemCount - 1) {
        _currentPosition = widget.itemCount - 1;
        _currentPosition = _currentPosition < 0 ? 0 :
        _currentPosition;
        if (widget.onPositionChange is ValueChanged<int>) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              widget.onPositionChange(_currentPosition);
            }
          });
        }
      }

      _currentCount = widget.itemCount;
      setState(() {
        controller = TabController(
          length: widget.itemCount,
          vsync: this,
          initialIndex: _currentPosition,
        );
        controller.addListener(onPositionChange);
        controller.animation?.addListener(onScroll);
      });
    } else if (widget.initPosition != null) {
      controller.animateTo(widget.initPosition);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    controller.animation?.removeListener(onScroll);
    controller.removeListener(onPositionChange);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.itemCount < 1) return widget.stub;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 12),
          child: Text('Лента', style: GoogleFonts.playfairDisplay(textStyle: TextStyle(fontSize: 23, fontWeight: FontWeight.w600)),),
        ),
        Container(
          alignment: Alignment.center,
          child: TabBar(
            isScrollable: true,
            controller: controller,
            labelColor: Colors.black,
            labelStyle: GoogleFonts.playfairDisplay(textStyle: TextStyle(fontSize: 21, fontWeight: FontWeight.w500)),
            unselectedLabelStyle: GoogleFonts.playfairDisplay(textStyle: TextStyle(fontSize: 15)),
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.grey,
            indicator: BoxDecoration(
            ),
            tabs: List.generate(
              widget.itemCount,
                  (index) => widget.tabBuilder(context, index),
            ),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: controller,
            children: List.generate(
              widget.itemCount,
                  (index) => widget.pageBuilder(context, index),
            ),
          ),
        ),
      ],
    );
  }

  onPositionChange() {
    if (!controller.indexIsChanging) {
      _currentPosition = controller.index;
      if (widget.onPositionChange is ValueChanged<int>) {
        widget.onPositionChange(_currentPosition);
      }
    }

  }

  onScroll() {
    if (widget.onScroll is ValueChanged<double>) {
      widget.onScroll(controller.animation!.value);
    }
  }
}
