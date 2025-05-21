part of 'package:sodong_app/features/create_post/presentation/pages/create_post_page.dart';

class ImagePreview extends StatelessWidget {
  const ImagePreview({super.key, required this.imageFiles});

  final List<XFile> imageFiles;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: imageFiles.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.file(
              File(imageFiles[index].path),
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}
