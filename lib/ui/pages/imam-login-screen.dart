import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:masjid_finder/constants/colors.dart';
import 'package:masjid_finder/constants/text-styles.dart';
import 'package:masjid_finder/enums/auth-result-status.dart';
import 'package:masjid_finder/models/imam-model.dart';
import 'package:masjid_finder/providers/auth-provider.dart';
import 'package:masjid_finder/services/auth-exception-handler.dart';
import 'package:masjid_finder/services/firestore-helper.dart';
import 'package:masjid_finder/ui/custom_widgets/asset-logo.dart';
import 'package:masjid_finder/ui/custom_widgets/custom-blue-rounded-button.dart';
import 'package:masjid_finder/ui/custom_widgets/custom-rounded-textfield.dart';
import 'package:masjid_finder/ui/pages/imam-signup-screen.dart';
import 'package:masjid_finder/ui/pages/mosque-dashboard-screen.dart';
import 'package:masjid_finder/ui/pages/mosque-not-listed.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

import 'imam-phone-verification-screen.dart';

class ImamLoginScreen extends StatefulWidget {
  @override
  _ImamLoginScreenState createState() => _ImamLoginScreenState();
}

class _ImamLoginScreenState extends State<ImamLoginScreen> {
  bool isInProgress = false;
  Imam imam = Imam();
  String password;

  @override
  void initState() {
    print('@ImamLoginScreen');
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (Provider.of<AuthProvider>(context, listen: false).isLogin) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MosqueDashboardScreen()),
            (r) => false);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall: isInProgress,
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(left: 20, right: 20, top: 50),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: greyBgColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  AssetLogo('assets/static_assets/blue-logo.png'),
                  _signInForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _signInForm() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          CustomRoundedTextField(
            hint: '03158988098',
            label: 'Contact',
            inputType: TextInputType.phone,
            onChange: (String val) {
              imam.contact = '+92${val.substring(1)}';
            },
          ),
//          CustomRoundedTextField(
//            hint: '*********',
//            label: 'Password',
//            isPassword: true,
//            onChange: (val) {
//              password = val;
//            },
//          ),
          SizedBox(height: 20),
          Consumer<AuthProvider>(builder: (context, authProvider, child) {
            return CustomBlueRoundedButton(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  'LOG IN',
                  style: roundedBlueBtnTS,
                ),
              ),
              onPressed: () async {
                setState(() {
                  isInProgress = true;
                });
                await FirebaseAuth.instance.verifyPhoneNumber(
                    phoneNumber: '+923159899097',
                    verificationCompleted: (AuthCredential credential) async {
                      await authProvider.login(
                          credentials: credential, isImam: true);
                      if (authProvider.status == AuthResultStatus.successful) {
                        final masjid = FirestoreHelper()
                            .getMasjid(context.read<AuthProvider>().user.uid);
                        setState(() {
                          isInProgress = false;
                        });
                        if (masjid != null) {
                          /// If masjid relevant to [uid] found, means mosque added.
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MosqueDashboardScreen()),
                              (r) => false);
                        } else {
                          /// If masjid relevant to [uid] not found, means mosque not added yet.
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MosqueNotListed()),
                              (r) => false);
                        }
                      } else {
                        final errorMsg =
                            AuthExceptionHandler.generateExceptionMessage(
                                authProvider.status);
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                'Login Failed',
                                style: TextStyle(color: Colors.black),
                              ),
                              content: Text(errorMsg),
                            );
                          },
                        );
                      }
                    },
                    verificationFailed: (AuthException e) {
                      print('@verificationFailed');
                      print('$e');
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Login Failed',
                                style: TextStyle(color: Colors.black)),
                            content: Text(e.message),
                          );
                        },
                      );
                    },
                    codeAutoRetrievalTimeout: (String verificationId) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ImamPhoneVerificationScreen(
                                  this.imam, verificationId, false)));
                    },
                    codeSent: _codeSent,
                    timeout: Duration(seconds: 15));
//                await authProvider.login(
//                    email: email, pass: password, isImam: true);
//                if (authProvider.status == AuthResultStatus.successful) {
//                  /// Check if mosque added, navigate to dashboard screens
//                  /// otherwise navigate to add mosque screen
//                  ///
//                  final masjid = FirestoreHelper()
//                      .getMasjid(context.read<AuthProvider>().user.uid);
//                  setState(() {
//                    isInProgress = false;
//                  });
//                  if (masjid != null) {
//                    /// If masjid relevant to [uid] found, means mosque added.
//                    Navigator.pushAndRemoveUntil(
//                        context,
//                        MaterialPageRoute(
//                            builder: (context) => MosqueDashboardScreen()),
//                        (r) => false);
//                  } else {
//                    /// If masjid relevant to [uid] not found, means mosque not added yet.
//                    Navigator.pushAndRemoveUntil(
//                        context,
//                        MaterialPageRoute(
//                            builder: (context) => MosqueNotListed()),
//                        (r) => false);
//                  }
//                } else {
//                  setState(() {
//                    isInProgress = false;
//                  });
//                  final errorMsg =
//                      AuthExceptionHandler.generateExceptionMessage(
//                          authProvider.status);
//                  showDialog(
//                    context: context,
//                    builder: (context) {
//                      return AlertDialog(
//                        title: Text(
//                          'Login Failed',
//                          style: TextStyle(color: Colors.black),
//                        ),
//                        content: Text(errorMsg),
//                      );
//                    },
//                  );
//                }
              },
            );
          }),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Not registered yet?', style: alreadyHaveAccountTS),
              SizedBox(width: 3),
              GestureDetector(
                child: Text(
                  'Signup',
                  style: alreadyHaveAccountTS.copyWith(
                    fontWeight: FontWeight.bold,
                    color: mainThemeColor,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImamSignUpScreen(),
                    ),
                  );
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  void _codeSent(String verificationId, [int resendToken]) {
    print('Code sent');
  }
}
