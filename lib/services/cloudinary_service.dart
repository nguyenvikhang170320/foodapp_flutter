import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class CloudinaryService {
  final String cloudName = "da95oqe1j"; // thay bằng cloud_name
  final String uploadPreset = "foodapp_unsigned"; // preset unsigned đã tạo

  Future<String?> uploadImage(File imageFile) async {
    final url = Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload");

    var request = http.MultipartRequest("POST", url);
    request.fields['upload_preset'] = uploadPreset;
    request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    var response = await request.send();

    if (response.statusCode == 200) {
      final resStr = await response.stream.bytesToString();
      final data = json.decode(resStr);
      return data["secure_url"]; // link ảnh Cloudinary
    } else {
      print("Upload failed: ${response.statusCode}");
      return null;
    }
  }
}
