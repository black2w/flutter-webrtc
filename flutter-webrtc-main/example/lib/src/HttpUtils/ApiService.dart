import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://172.17.16.22:1985';

  Future<String?> push(String code, String sdp) async {
    final url = Uri.parse('$baseUrl/rtc/v1/publish/');
    final Map<String, dynamic> requestBody = {
      "api": "http://172.17.16.22:1985/rtc/v1/publish/",
      "tid": generateRandomHexString(),
      "streamurl": "webrtc://172.17.16.22/cast/" + code,
      "clientip": null,
      "sdp": sdp
    };

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      print('Request successful');
      print('Response body: ${response.body}');
      final responseBody = jsonDecode(response.body);
      if (responseBody['code'] == 0) {
        return responseBody['sdp'];
      } else {
        // Handle non-zero code
        print('Error: ${responseBody['code']}');
        return null;
      }
    } else {
      print('Request failed with status: ${response.statusCode}');
      print('Response body: ${response.body}');
      return null;
    }
  }


  Future<String?> pull(String code, String sdp) async {
    final url = Uri.parse('$baseUrl/rtc/v1/play/');
    final Map<String, dynamic> requestBody = {
      "api": "http://172.17.16.22:1985/rtc/v1/play/",
      "tid": generateRandomHexString(),
      "streamurl": "webrtc://172.17.16.22/cast/" + code,
      "clientip": null,
      "sdp": sdp
    };

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      print('Request successful');
      print('Response body: ${response.body}');
      final responseBody = jsonDecode(response.body);
      if (responseBody['code'] == 0) {
        return responseBody['sdp'];
      } else {
        // Handle non-zero code
        print('Error: ${responseBody['code']}');
        return null;
      }
    } else {
      print('Request failed with status: ${response.statusCode}');
      print('Response body: ${response.body}');
      return null;
    }
  }

  String generateRandomHexString() {
    // 获取当前时间的毫秒数
    int currentTimeMillis = DateTime.now().millisecondsSinceEpoch;

    // 生成一个随机数
    Random random = Random();
    int randomNumber = (currentTimeMillis * random.nextDouble() * 100).toInt();

    // 将随机数转换为十六进制字符串
    String hexString = randomNumber.toRadixString(16);

    // 返回十六进制字符串的前7个字符
    return hexString.substring(0, 7);
  }
}
