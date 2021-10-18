import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudgallery/database/storage.dart';
import 'package:cloudgallery/global/design.dart';
import 'package:cloudgallery/global/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ShowImages extends StatelessWidget {
  User? user;
  ShowImages({Key? key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final StorageServices _storageServices = StorageServices();

    //final user = Provider.of<User?>(context);

    return user != null
        ? Container(
            child: Column(
            children: [
              StreamBuilder<DocumentSnapshot>(
                  stream: _storageServices.getDownloadURLStream(user!),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('something went wrong');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Loading();
                    }
                    return FutureBuilder<List>(
                        future: _storageServices.getDownloadURLS(user!),
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return Loading();
                            case ConnectionState.none:
                              return const Text('Error occured');
                            case ConnectionState.done:
                              return Container(
                                alignment: Alignment.center,
                                child: Column(
                                  children: [
                                    snapshot.data!.isNotEmpty
                                        ? ListView.builder(
                                            shrinkWrap: true,
                                            //itemCount: snapshot.data.docs.length,
                                            itemCount: snapshot.data!.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return ListTile(
                                                contentPadding:
                                                    EdgeInsets.all(8.0),
                                                //title: Text('Image $index'),
                                                leading: Image.network(
                                                    snapshot.data!
                                                        .elementAt(index),
                                                    fit: BoxFit.fill),
                                              );
                                            })
                                        : const Text('no images uploaded yet'),
                                  ],
                                ),
                              );
                            default:
                              return Loading();
                          }
                        });
                  }),
              /*
              ElevatedButton.icon(
                icon: const Icon(Icons.cloud_download),
                label: const Text(
                  "Get Images from cloud",
                  style: TextStyle(
                    color: textColorButtonPrimary,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: backgroundColorButtonPrimary,
                ),
                onPressed: () {
                  _storageServices.getDownloadURLS(user!);
                },
              ),
              */
            ],
          ))
        : Container();
  }
}
