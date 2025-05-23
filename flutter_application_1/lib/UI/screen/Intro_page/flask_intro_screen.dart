import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginService {
  static Future<Map<String, dynamic>?> login(
    String studentId,
    String password,
  ) async {
    final url = Uri.parse('http://112.184.197.77:5000/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'student_id': studentId, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('✅ 로그인 성공: $data');
        return data;
      } else {
        print('❌ 로그인 실패: ${response.body}');
        return null;
      }
    } catch (e) {
      print('❌ 네트워크 오류: $e');
      return null;
    }
  }
}
