import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../shared/components/drawer.dart';
import '../../shared/components/image_card.dart';
import 'my_images_provider.dart';

class MyImages extends StatefulWidget {
  const MyImages({super.key});

  @override
  State<MyImages> createState() => _MyImagesState();
}

class _MyImagesState extends State<MyImages> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MyImagesProvider>().fetchUserImages();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Images"),
      ),
      drawer: MyDrawer(),
      body: Consumer<MyImagesProvider>(
        builder: (context, myImagesProvider, child) {
          if (myImagesProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (myImagesProvider.userImages.isEmpty) {
            return const Center(
              child: Text("No data found"),
            );
          } else {
            return ListView.builder(
              itemCount: myImagesProvider.userImages.length,
              itemBuilder: (context, index) {
                final item = myImagesProvider.userImages[index];
                return ImageCard(
                    id: item.id,
                    bodyPart: item.bodyPart,
                    description: item.description,
                    image: item.image,
                    publishDate: item.createdAt);
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Provider.of<MyImagesProvider>(context, listen: false)
              .fetchUserImages();
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
