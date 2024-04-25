import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

void main() {
  runApp(const MaterialApp(
    home: MainApp(),
  ));
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
                          final TextEditingController commissoncontroller =
                              TextEditingController();
                          showDialog(
                            context: context,
                            builder: (ctx) => Theme(
                              data: ThemeData(
                                  dialogBackgroundColor: Colors.white),
                              child: AlertDialog(
                                actions: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(top: 28.0),
                                    child: Container(
                                      height: 200,
                                      decoration: BoxDecoration(
                                        border: Border.all(),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: TextFormField(
                                        controller: commissoncontroller,
                                        decoration: const InputDecoration(
                                            hintText: "Request commission",
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 20,
                                                    horizontal: 20),
                                            border: InputBorder.none),
                                        maxLines: null,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Center(
                                    child: SizedBox(
                                      width: 250,
                                      height: 60,
                                      child: ElevatedButton(
                                          onPressed: () {
                                            final Email email = Email(
                                              body: commissoncontroller.text,
                                              subject: "Commission Request",
                                              recipients: [],
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.black,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15))),
                                          child: const Text(
                                            "Submit Request",
                                            style:
                                                TextStyle(color: Colors.white),
                                          )),
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child:
                                          const Center(child: Text("Cancel"))),
                                ],
                              ),
                            ),
                          );
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
