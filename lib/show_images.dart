import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudgallery/database/storage.dart';
import 'package:cloudgallery/global/design.dart';
import 'package:cloudgallery/global/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ShowImages extends StatelessWidget {
  User? user;
  ShowImages({Key? key, this.user}) : super(key: key);

  final StorageServices _storageServices = StorageServices();

  @override
  Widget build(BuildContext context) {
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
                                        ? GridView.builder(
                                            gridDelegate:
                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 3,
                                              mainAxisSpacing: 5.0,
                                              crossAxisSpacing: 5.0,
                                            ),
                                            shrinkWrap: true,
                                            itemCount: snapshot.data!.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return GestureDetector(
                                                child: Image.network(
                                                  snapshot.data!
                                                      .elementAt(index),
                                                  fit: BoxFit.contain,
                                                ),
                                                onTap: () {
                                                  openImage(
                                                      context, snapshot, index);
                                                },
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

  void openImage(BuildContext context, snapshot, final int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: backgroundColorPage,
          appBar: AppBar(
            //title: Text(snapshot.data!.elementAt(index).toString()),
            backgroundColor: backgroundColorAppBar,
            automaticallyImplyLeading: false,
            leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ),
          body: Stack(children: [
            PhotoView(
              imageProvider: NetworkImage(
                snapshot.data!.elementAt(index),
              ),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.delete),
              label: const Text(
                "Delete Images from cloud",
                style: TextStyle(
                  color: textColorButtonPrimary,
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: backgroundColorButtonPrimary,
              ),
              onPressed: () async {
                await _storageServices.deleteImage(
                    snapshot.data!.elementAt(index), user!);
                Navigator.pushNamed(context, '/');
              },
            ),
          ]),
        ),
      ),
    );
  }
}
