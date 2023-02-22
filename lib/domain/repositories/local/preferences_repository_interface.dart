
import 'dart:async';


abstract class PreferencesRepositoryInterface {
  // SharedPreferencesなどに保存
  Future<void> save(String key, Object? value);

  // 永続化から削除
  Future<void> delete(String key);

  // 永続化から全てのデータをMap形として取得
  Future<Map<String, Object?>> getAll();
  //keyで探して返す
  Future<Map<String, Object?>> findKey(String key);
}
