import 'package:flutter_pink/db/hi_cache.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test("hiCache测试", () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await HiCache.preInit();
    var key = "testHiCache", value = "hellosas";
    HiCache.getInstance()!.setString(key, value);
  });
}
