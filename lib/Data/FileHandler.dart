import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

class FileHandler {
  static Future<String> saveFile(String tempFilePath, String id) async {
    //Get Local Path
    String path = localPath;
    print('path $path');
    //Create Directory For Id If not exists
    String directoryPath = "$path/$id";
    bool isDirExist = await Directory(directoryPath).exists();
    if (!isDirExist) Directory(directoryPath).create();
    //Get Temp File
    Uri uri = Uri.parse(tempFilePath);
    File tempFile = new File.fromUri(uri);
    //Copy File
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    String filePath = "$path/$id/$fileName.png";
    await tempFile.copy(filePath);
    //Delete TempFile
    bool isTempFileExits = await Directory(directoryPath).exists();
    if (!isTempFileExits) Directory(directoryPath).deleteSync(recursive: true);
    return "/$id/$fileName.png";
  }

  static Future<String> readFile(String filePath) async {
    Uri uri = Uri.parse(filePath);
    File imageFile = new File.fromUri(uri);
    Uint8List bytes;
    await imageFile.readAsBytes().then((value) {
      bytes = Uint8List.fromList(value);
      print('reading of bytes is completed');
    }).catchError((onError) {
      print('Exception Error while reading audio from path:' +
          onError.toString());
    });
    return base64.encode(bytes);
  }

  deleteImage(String filePath) {
    final dir = Directory(filePath);
    dir.deleteSync(recursive: true);
  }

  deleteAllImages(String id) async {
    String path = localPath;
    String directoryPath = "$path/$id.png";
    bool isDirExist = await Directory(directoryPath).exists();
    if (!isDirExist) Directory(directoryPath).deleteSync(recursive: true);
  }

  static String localPath;

  static Future<String> initLocalPath() async {
    final directory = await getApplicationDocumentsDirectory();
    localPath = directory.path;
    print('init path: $localPath');
    return localPath;
  }
}
