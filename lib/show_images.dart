import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudgallery/database/storage.dart';
import 'package:cloudgallery/global/design.dart';
import 'package:cloudgallery/global/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ShowImages extends StatelessWidget {
  final User? user;
  ShowImages({Key? key, this.user}) : super(key: key);

  final StorageServices _storageServices = StorageServices();

  @override
  Widget build(BuildContext context) {
    return user != null
        ? Column(
            children: [
              StreamBuilder<DocumentSnapshot>(
                  stream: _storageServices.getDownloadURLStream(user!),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('something went wrong');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Column(
                          //mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Loading(
                              loadingText: 'Getting images from the cloud...',
                            ),
                          ]);
                    }
                    return FutureBuilder<List>(
                        future: _storageServices.getDownloadURLS(user!),
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const <Widget>[
                                    Loading(
                                      loadingText:
                                          'Getting images from the cloud...',
                                    ),
                                  ]);
                            case ConnectionState.none:
                              return const Text('Error occured');
                            case ConnectionState.done:
                              return Column(
                                //mainAxisAlignment: MainAxisAlignment.start,
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
                                                snapshot.data!.elementAt(index),
                                                fit: BoxFit.contain,
                                              ),
                                              onTap: () {
                                                openImage(
                                                    context, snapshot, index);
                                              },
                                            );
                                          })
                                      : Container(
                                          alignment: Alignment.center,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: const [
                                              Icon(
                                                Icons.image_outlined,
                                                size: 50.0,
                                                color: iconColor,
                                              ),
                                              SizedBox(
                                                height: heightSizedBox,
                                              ),
                                              Text('No images uploaded yet.'),
                                            ],
                                          ),
                                        ),
                                ],
                              );
                            default:
                              return Container(
                                alignment: Alignment.center,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: const <Widget>[
                                      Loading(
                                        loadingText: 'No images uploaded yet',
                                      ),
                                    ]),
                              );
                          }
                        });
                  }),
            ],
          )
        : Container();
  }

  void openImage(BuildContext context, snapshot, final int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: backgroundColorPage,
          appBar: AppBar(
            backgroundColor: backgroundColorAppBar,
            automaticallyImplyLeading: false,
            leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ),
          body: StreamBuilder<DocumentSnapshot>(
              stream: _storageServices.getProgress(user!),
              builder: (context, snapshotProgress) {
                if (snapshotProgress.hasError) {
                  return Container(
                    alignment: Alignment.center,
                    child: Column(
                      children: const [
                        Text('Something went wrong'),
                      ],
                    ),
                  );
                }
                if (snapshotProgress.connectionState ==
                    ConnectionState.waiting) {
                  return Container(
                    alignment: Alignment.center,
                    child: Column(
                      children: const [
                        Text('Image is deleting...'),
                      ],
                    ),
                  );
                }
                return Stack(children: [
                  PhotoView(
                    imageProvider: NetworkImage(
                      snapshot.data!.elementAt(index),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.delete),
                          label: const Text(
                            "Delete this image from cloud",
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
                      ],
                    ),
                  ),
                ]);
              }),
        ),
      ),
    );
  }
}
