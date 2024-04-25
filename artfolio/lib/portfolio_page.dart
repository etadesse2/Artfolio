import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: PortfolioScreen(),
  ));
}

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({Key? key}) : super(key: key);

  @override
  _PortfolioScreenState createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  String? type;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 35, right: 35, top: 50),
            child: SizedBox(
              width: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      child: ClipOval(
                        child: Image.asset(
                          "assets/images/img.jpg",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.edit),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Profile\n& Portfolio",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Ana',
                          style: TextStyle(fontSize: 15, color: Colors.black),
                        ),
                        WidgetSpan(
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 5),
                            height: 1,
                            color: Colors.grey,
                          ),
                        ),
                        const WidgetSpan(child: SizedBox(height: 10)),
                        const TextSpan(
                          text: 'Marie',
                          style: TextStyle(fontSize: 15, color: Colors.black),
                        ),
                        WidgetSpan(
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 5),
                            height: 1,
                            color: Colors.grey,
                          ),
                        ),
                        const WidgetSpan(child: SizedBox(height: 10)),
                        const TextSpan(
                          text: 'annart@gmail.com',
                          style: TextStyle(fontSize: 15, color: Colors.black),
                        ),
                        WidgetSpan(
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 5),
                            height: 1,
                            color: Colors.grey,
                          ),
                        ),
                        const WidgetSpan(child: SizedBox(height: 10)),
                        const TextSpan(
                          text: '.........',
                          style: TextStyle(fontSize: 15, color: Colors.black),
                        ),
                        WidgetSpan(
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 5),
                            height: 1,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      "Reset Password",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 60),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
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
                                        decoration: const InputDecoration(
                                          hintText: "Update description",
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: 20,
                                            horizontal: 20,
                                          ),
                                          border: InputBorder.none,
                                        ),
                                        maxLines: null,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Center(
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 235,
                                          height: 60,
                                          child: ElevatedButton(
                                            onPressed: () {},
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.black,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                            ),
                                            child: const Text(
                                              "Update",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {},
                                          icon: const Icon(Icons.delete),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Center(
                                      child: Text("Cancel"),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: Container(
                            width: 140,
                            height: 160,
                            child: Image.asset(
                              "assets/images/img.jpg",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 140,
                        height: 160,
                        decoration:
                            const BoxDecoration(color: Color(0xFFEAEAEA)),
                        child: IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  actions: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(top: 28.0),
                                      child: Container(
                                        height: 200,
                                        decoration: BoxDecoration(
                                          border: Border.all(),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: TextFormField(
                                          decoration: const InputDecoration(
                                            hintText: "Description",
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                              vertical: 20,
                                              horizontal: 20,
                                            ),
                                            border: InputBorder.none,
                                          ),
                                          maxLines: null,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Center(
                                      child: DropdownButton(
                                        value: type,
                                        items: const [
                                          DropdownMenuItem(
                                            value: "Photography",
                                            child: Text("Photography"),
                                          ),
                                          DropdownMenuItem(
                                            value: "Ceramic",
                                            child: Text("Ceramic"),
                                          ),
                                          DropdownMenuItem(
                                            value: "Painting",
                                            child: Text("Painting"),
                                          ),
                                          DropdownMenuItem(
                                            value: "Sculpture",
                                            child: Text("Sculpture"),
                                          ),
                                          DropdownMenuItem(
                                            value: "Digital",
                                            child: Text("Digital"),
                                          ),
                                          DropdownMenuItem(
                                            value: "Other",
                                            child: Text("Other"),
                                          ),
                                        ],
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            type = newValue;
                                          });
                                        },
                                      ),
                                    ),
                                    Center(
                                      child: SizedBox(
                                        width: 260,
                                        height: 60,
                                        child: ElevatedButton(
                                          onPressed: () {},
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.black,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                          ),
                                          child: const Text(
                                            "Add to Portfolio",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 30),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Center(
                                        child: Text("Cancel"),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: const Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
