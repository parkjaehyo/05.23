//local maria db
import 'package:mysql1/mysql1.dart';

class DatabaseHelper {
  static final settings = ConnectionSettings(
    host: '', // DB 서버 IP
    port: 3306,
    user: 'park', // DB 사용자 이름
    password: '1234', // 비밀번호
    db: 'project_umbrella', // DB 이름
  );

  /// MariaDB에 연결을 시도하고 로그를 출력함
  static Future<void> connect() async {
    print('🔵 DB 연결 시도...');
    try {
      final conn = await MySqlConnection.connect(settings);
      print('✅ DB 연결 성공!');

      // 여기서 초기 쿼리 실행 가능

      await conn.close();
    } catch (e) {
      print('❌ DB 연결 실패: $e');
      rethrow; // 호출자에게 예외 전달
    }
  }
}
