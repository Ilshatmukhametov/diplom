import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Detail_page extends StatelessWidget {

  final String heading;
  final String href;
  final String date;
  final String image;

  Detail_page({Key? key, required this.heading, required this.href, required this.date, required this.image}) : super(key: key);

  final articleText = <String>[];

  parsingtext() async{
    articleText.clear();
    final response =
    await http.Client().get(Uri.parse(href));
  if (response.statusCode == 200) {
    var document = parse(response.body);
    for(int i=0; i < 10; i++){
      String data = document.getElementsByClassName('article__text')[i].text;
      if (data != null) {
        articleText.add(data);
      }
    }
  }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: parsingtext(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        TextButton.icon(onPressed: (){
                          Navigator.pop(context);},
                            label: Text('Назад', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                            icon: Icon(Icons.arrow_back_ios_outlined, color: Colors.black,)),
                        TextButton.icon(onPressed: () async{
                          await Share.share('Посмотри эту новость!\n\n$href');
                        }, icon: Icon(Icons.share, color: Colors.black), label: Text('Поделиться', style: TextStyle(color: Colors.black),))
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    ),
                    Text(heading, style: GoogleFonts.anton(fontSize: 20, fontWeight: FontWeight.bold),),
                    SizedBox(height: 15),
                    Container(
                      height: 200.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        //let's add the height

                        image: DecorationImage(
                            image: NetworkImage(image), fit: BoxFit.cover),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.access_time_outlined),
                            Text(
                              date,
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        TextButton.icon(onPressed: (){
                            final Uri _url = Uri.parse(href);
                            launchUrl(_url);
                          }, label: Text('Первоисточник'), icon: Icon(Icons.article)),
                      ],
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      articleText.join('.\n\n'),
                      style: GoogleFonts.robotoCondensed(textStyle: TextStyle( fontSize: 16, fontWeight: FontWeight.w400))
                    )
                  ],
                ),)
            ],
          );
          },
      ),
    );
  }
}


