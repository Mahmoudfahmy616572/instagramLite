

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram/screens/profile.dart';
import 'package:instagram/shared/Colors.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: mobileBackgroundColor,
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title: TextFormField(
            onChanged: (value) {
              setState(() {});
            },
            controller: searchController,
            decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22))),
          ),
        ),
        body: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('usersss')
              .where('name', isEqualTo: searchController.text)
              .get(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return const Text("Something went wrong");
            }

            if (snapshot.connectionState == ConnectionState.done) {
              return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Profile(
                                  uiddd: snapshot.data!.docs[index]['uid'],
                                )),
                      );
                    },
                    title: Text(snapshot.data!.docs[index]['name']),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                          snapshot.data!.docs[index]['profileImage']),
                      radius: 33,
                    ),
                  );
                },
              );
            }

            return const Center(
                child: CircularProgressIndicator(
              color: Colors.white,
            ));
          },
        ));
  }
}
