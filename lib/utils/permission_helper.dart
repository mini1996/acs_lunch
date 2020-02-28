import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {
  static final PermissionHelper _singleton = new PermissionHelper._internal();
  bool isPermissionRequested = false;
  factory PermissionHelper() {
    return _singleton;
  }

  PermissionHelper._internal();

  verifyPermission(PermissionGroup permissionGroup) async {
    if (!isPermissionRequested) {
      isPermissionRequested = true;
      PermissionStatus permission =
          await PermissionHandler().checkPermissionStatus(permissionGroup);
      if (permission == PermissionStatus.granted) {
        isPermissionRequested = false;
        return true;
      } else if (permission == PermissionStatus.denied ||
          permission == PermissionStatus.disabled ||
          permission == PermissionStatus.restricted) {
        await PermissionHandler().requestPermissions([permissionGroup]);
        isPermissionRequested = false;
        verifyPermission(permissionGroup);
      }
    } else {
      verifyPermission(permissionGroup);
    }
  }
}
