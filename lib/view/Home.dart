import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:recipe/models/recipe_model.dart';
import 'package:recipe/view/recipe_view.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<RecipeModel> recipes = [];
  TextEditingController textEditingController = new TextEditingController();
  // String applicationID = "d3a5d85e";
  // String applicationKey = "d9c56d855c2623d081bec739f091ee61";

  getRecipes(String query) async {
    String url =
        "https://api.edamam.com/search?q=$query&app_id=d3a5d85e&app_key=d9c56d855c2623d081bec739f091ee61";

    Uri myUri = Uri.parse(url);
    var response = await http.get(myUri);
    Map<String, dynamic> jsonData = jsonDecode(response.body);

    jsonData["hits"].forEach((element) {
      //print(element.toString());

      RecipeModel recipeModel =
          new RecipeModel(label: '', image: '', source: '', url: '');
      recipeModel = RecipeModel.fromMap(element["recipe"]);
      recipes.add(recipeModel);
    });

    setState(() {});

    print("${recipes.toString()}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff213A50),
                  Color(0xff071930),
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: kIsWeb
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "VT",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Recipe",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "What will you cook today ?!",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontFamily: "Overpass"),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  "Just Enter Ingredients you have and we will show the best recipe for you",
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontFamily: "Overpass"),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: textEditingController,
                          decoration: InputDecoration(
                              hintText: "Enter Ingredients",
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              hintStyle: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white.withOpacity(0.5))),
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 24,
                      ),
                      InkWell(
                        onTap: () {
                          if (textEditingController.text.isNotEmpty) {
                            getRecipes(textEditingController.text);
                            print("just do it");
                          } else {
                            print("just don't do it");
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              gradient: LinearGradient(colors: [
                                const Color(0xffA2834D),
                                const Color(0xffBC9A5F)
                              ])),
                          child: Icon(
                            Icons.search,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                SingleChildScrollView(
                  child: GridView(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: ClampingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200, mainAxisSpacing: 10.0),
                      children: List.generate(recipes.length, (index) {
                        return GridTile(
                            child: RecipieTile(
                          title: recipes[index].label,
                          desc: recipes[index].source,
                          imgUrl: recipes[index].image,
                          url: recipes[index].url,
                        ));
                      })),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RecipieTile extends StatefulWidget {
  final String title, desc, imgUrl, url;

  RecipieTile(
      {required this.title,
      required this.desc,
      required this.imgUrl,
      required this.url});

  @override
  _RecipieTileState createState() => _RecipieTileState();
}

class _RecipieTileState extends State<RecipieTile> {
  _launchURL(String url) async {
    print(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            if (kIsWeb) {
              _launchURL(widget.url);
            } else {
              print(widget.url + " this is what we are going to see");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RecipeView(
                            postUrl: widget.url,
                          )));
            }
          },
          child: Container(
            margin: const EdgeInsets.all(10),
            child: Stack(
              children: <Widget>[
                // MainAxisAlignment = MainAxisAlignment.spaceBetween;
                Image.network(
                    // 'https://example.com/image.jpg',
                    widget.imgUrl,
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover
                    // errorBuilder: (context, url, error) => Icon(Icons.error),
                    ),
                Container(
                  width: 200,
                  alignment: Alignment.bottomLeft,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.white30, Colors.white],
                          begin: FractionalOffset.centerRight,
                          end: FractionalOffset.centerLeft)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.title,
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                              fontFamily: 'Overpass'),
                        ),
                        Text(
                          widget.desc,
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.black54,
                              fontFamily: 'OverpassRegular'),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
