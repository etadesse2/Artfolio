import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            iconSize: 30,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 40, right: 40),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                    width: 200,
                    height: 270,
                    child: Image.asset(
                      "assets/images/img1.jpg",
                      fit: BoxFit.cover,
                    )),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      children: [
                        Text(
                          "Ceramic\nBy Ana Marie",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        // Text("By Ana Marie"),
                      ],
                    ),
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: ClipOval(
                        child: Image.asset(
                          "assets/images/img1.jpg",
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  "Description",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const Text(
                    "This 12-inch tall red ceramic vase, crafted by artist Sarah Meadows, boasts a glossy finish and intricate geometric patterns, making it a captivating centerpiece for any space. Its vibrant hue and elegant silhouette add a touch of artistic flair, perfect for showcasing fresh blooms or standing alone as a statement piece."),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.only(left: 25, right: 25),
                  child: SizedBox(
                    height: 60,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15))),
                        onPressed: () {
                          // showDialog(
                          //     context: context,
                          //     builder: (BuildContext context) {
                          //       return AlertDialog();
                          //     });
                        },
                        child: const Text(
                          "Commissions",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w400),
                        )),
                  ),
                ),
                const SizedBox(height: 50),
                const Padding(
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: Text("Ana's Portfolio"),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      SizedBox(
                          width: 200,
                          height: 200,
                          child: Image.asset(
                            "assets/images/img1.jpg",
                            fit: BoxFit.cover,
                          )),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                const Padding(
                  padding: EdgeInsets.only(bottom: 15.0),
                  child: Text("Comments"),
                ),
                const SizedBox(
                  width: 400,
                  height: 50,
                  child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "Wow! I definitely need one for my living room.\n- Angie William",
                            overflow: TextOverflow.visible,
                          ),
                        ],
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 20),
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: "Add a comment",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15))),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
