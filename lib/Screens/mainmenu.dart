import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled6/Screens/NewsForm.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';
import 'package:google_fonts/google_fonts.dart';

import '../DatabaseHandler/DbHelper.dart';

class Item{
  Item(this.title, this.obj);
  String title;
  String obj;
  bool seleted = false;
  String toString() => obj;
}

class menu_page extends StatefulWidget {

  @override

  State<menu_page> createState() => _menu_pageState();
}

class _menu_pageState extends State<menu_page> {
  final _formKey = new GlobalKey<FormState>();
  Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  DbHelper? dbHelper;
  final _conUserId = TextEditingController();
  final _conDelUserId = TextEditingController();
  final _conUserName = TextEditingController();
  final _conEmail = TextEditingController();
  final _conPassword = TextEditingController();

  final dataList = <Item>[
    Item('Политика', 'politics'),
    Item('В мире', 'world'),
    Item('Экономика', 'economy'),
    Item('Общество', 'society'),
    Item('Наука','science'),
    Item('Культура', 'culture'),
    Item('Религия', 'religion'),
  ];

  final selectedItems = <Item>[];
  final category = <String>[];
  List<String> items = [];

  @override
  void initState() {
    super.initState();
    getUserData();

    dbHelper = DbHelper();
  }

  Future<void> getUserData() async {
    final SharedPreferences sp = await _pref;

    setState(() {
      _conUserId.text = sp.getString("user_id").toString();
      _conDelUserId.text = sp.getString("user_id").toString();
      _conUserName.text = sp.getString("user_name").toString();
      _conEmail.text = sp.getString("email").toString();
      _conPassword.text = sp.getString("password").toString();
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                AnimatedOpacity(
                  duration: Duration(seconds: 3),
                  opacity: 1,
                  child: Column(
                    children: [
                      
                      Text('Выберите интересующие вас категории новостей, ' + _conUserName.text, textAlign: TextAlign.center,style: GoogleFonts.anton(textStyle: TextStyle(fontSize: 19, fontWeight: FontWeight.w500)),),
                      SizedBox(height: 40),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: generatedItems(),
                      ),
                      SizedBox(height: 20),
                      IconButton(
                          onPressed: (){
                            selectedItems.clear();
                            selectedItems.addAll(dataList.where((p0) => p0.seleted));
                            print(selectedItems);
                            for(int i=0; i < selectedItems.length; i++){
                              items.add(selectedItems[i].title);
                              category.add(selectedItems[i].obj);
                            }
                            setState(() {});
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => News_page(selectedItems: items, selectedCategory: category)));

                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(builder: (_) => News_page(selectedItems: items, selectedCategory: category)));

                          },
                          icon: Icon(Icons.arrow_forward_rounded),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> generatedItems() {
    final result = <Widget>[];
    for(int i=0; i < dataList.length; i++){
      result.add(
          CheckboxListTile(
              activeColor: Colors.grey,
              contentPadding: EdgeInsets.only(left: 40, right: 40),
              title: Text(
                  dataList[i].title,
                  style: GoogleFonts.playfairDisplay(textStyle: TextStyle(fontSize: 21, fontWeight: FontWeight.w500)),
              ),
              value: dataList[i].seleted,
              onChanged: (v) {
                dataList[i].seleted = v ?? false;
                setState(() {});
              }
          )
      );
    }
    return result;
  }
}