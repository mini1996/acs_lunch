import 'package:acs_lunch/app/domain/repository/auth_screen/auth_screen.respository.dart';
import 'package:acs_lunch/app/utils/http_helper.dart';
import 'package:acs_lunch/constant/endpoints.dart';

// OfflineHelper offlineHelper = OfflineHelper();
HttpHelper httpHelper = HttpHelper();

class DataAuthScreenRepository implements AuthScreenRepository {
  loginUser() async {
    return await httpHelper.request(
      HttpMethods.get,
      endPoint: Endpoints.loginUrl,
      authenticationRequired: true,
    );
  }
}
