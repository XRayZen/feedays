//testコードはこれをimport
import 'package:flutter_test/flutter_test.dart'; 
//インテグレーションtestコードはこれをimport
import 'package:integration_test/integration_test.dart'; 


void main(){
   // インテグレーションテストの場合はこれを１行目に書く
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
}
