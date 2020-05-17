import 'package:masjid_finder/enums/user-type.dart';
import 'package:masjid_finder/ui/pages/splash-screen.dart';

class SharePrefHelper {
  var prefs = SplashScreen.prefs;

//  checkIfDoctorApproved() {
//    bool status = prefs.getBool('isDoctorApproved') ?? false;
//    return status;
//  }
//
//  setDoctorApproved(val) {
//    prefs.setBool('isDoctor', val);
//  }

  getUserType() {
    String stringUserType = prefs.getString('userType');
    UserType userType;
    if (stringUserType == 'imam')
      userType = UserType.imam;
    else if (stringUserType == 'user')
      userType = UserType.user;
    else
      userType = null;
    return userType;
  }

  setAsImam() {
    prefs.setString('userType', 'imam');
  }

  setAsUser() {
    prefs.setString('userType', 'user');
  }
}
