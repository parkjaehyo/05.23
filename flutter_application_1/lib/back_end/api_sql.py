from flask import Flask, request, jsonify
from flask_cors import CORS
import mysql.connector
from datetime import datetime

app = Flask(__name__)
CORS(app)

@app.route('/rental', methods=['POST'])
def rental():
    data       = request.get_json()
    student_id = data.get('student_id')
    action     = data.get('action')
    now        = datetime.now().strftime('%Y-%m-%d %H:%M:%S')  # 현재 시간

    print(f"[DEBUG] 받은 student_id = '{student_id}' (type: {type(student_id)})")

    if not student_id or action not in ['대여', '반납']:
        return jsonify({'status': 'error', 'message': '잘못된 요청입니다.'}), 400

    try:
        if action == '대여':
            # 사용자 정보 조회
            cursor.execute("SELECT * FROM user WHERE student_id = %s", (student_id,))
            print(f"[DEBUG] 쿼리 실행 완료: SELECT * FROM user WHERE student_id = '{student_id}'")
            row = cursor.fetchone()
            print(f"[DEBUG] fetchone 결과: {row}")

            if not row:
                return jsonify({'status': 'error', 'message': '사용자를 찾을 수 없습니다.'}), 404

            # 컬럼명 + 데이터 매핑
            column_names = [desc[0] for desc in cursor.description]
            user_info    = dict(zip(column_names, row))

            print(f"[DEBUG] user_info = {user_info}")
            return jsonify({'status': 'success', 'user_info': user_info})

        elif action == '반납':
            cursor.execute("SELECT borrow_day, pre_return_day FROM user WHERE student_id = %s", (student_id,))
            result = cursor.fetchone()
            if not result or not result[0]:
                return jsonify({'status': 'error', 'message': '대여 기록이 없습니다.'}), 404

            borrow_day, pre_return_day = result

            # 반납 처리
            cursor.execute("""
                UPDATE user
                SET return_day   = %s,
                    penalty_days = IF(pre_return_day IS NULL, 0, GREATEST(DATEDIFF(DATE(%s), DATE(pre_return_day)), 0))
                WHERE student_id = %s
            """, (now, now, student_id))

            # 연체 확인 후 쿠폰 갱신
            cursor.execute("SELECT penalty_days FROM user WHERE student_id = %s", (student_id,))
            penalty_days = cursor.fetchone()[0]

            if penalty_days > 0:
                cursor.execute("UPDATE user SET coupon_count = 0 WHERE student_id = %s", (student_id,))
            else:
                cursor.execute("UPDATE user SET coupon_count = 1 WHERE student_id = %s", (student_id,))

        db.commit()
        return jsonify({'status': 'success', 'action': action, 'time': now})

    except Exception as e:
        db.rollback()
        print(f"[ERROR] 예외 발생: {e}")
        return jsonify({'status': 'error', 'message': str(e)}), 500

# DB 연결
if __name__ == '__main__':
    db = mysql.connector.connect(
        host     = '112.184.197.77',     # Raspberry Pi IP
        port    =   3306,
        user     = 'flutter_user',
        password = '1234',
        database = 'project_umbrella'
    )
    cursor = db.cursor()
    app.run(host='0.0.0.0', port=5000, debug=True)
