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
import 'package:masjid_finder/ui/pages/imam-login-screen.dart';
import 'package:masjid_finder/ui/pages/mosque-dashboard-screen.dart';
import 'package:masjid_finder/ui/pages/mosque-not-listed.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

class ImamPhoneVerificationScreen extends StatefulWidget {
  final Imam imam;
  final String verificationId;
  final bool isSignUp;

  ImamPhoneVerificationScreen(this.imam, this.verificationId, this.isSignUp);

  @override
  _ImamPhoneVerificationScreenState createState() =>
      _ImamPhoneVerificationScreenState(this.imam);
}

class _ImamPhoneVerificationScreenState
    extends State<ImamPhoneVerificationScreen> {
  final Imam imam;
  bool isInProgress = false;
  String verificationCode;

  _ImamPhoneVerificationScreenState(this.imam);

  @override
  void initState() {
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
                    _signUpForm(),
                  ],
                )),
          ),
        ),
      ),
    );
  }

  _signUpForm() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          CustomRoundedTextField(
            hint: '345622',
            label: 'Verification Code',
            textCapitalization: TextCapitalization.words,
            onChange: (val) {
              verificationCode = val;
            },
          ),
//          CustomRoundedTextField(
//            hint: 'userName@email.com',
//            label: 'Email',
//            onChange: (val) {
//              imam.email = val;
//            },
//          ),
//          CustomRoundedTextField(
//            hint: '03*******97',
//            label: 'Contact',
//            inputType: TextInputType.phone,
//            onChange: (val) {
//              imam.contact = val;
//            },
//          ),
//          CustomRoundedTextField(
//            hint: '*********',
//            label: 'Password',
//            isPassword: true,
//            onChange: (val) {
//              imam.password = val;
//            },
//          ),
          SizedBox(height: 20),
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return CustomBlueRoundedButton(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    'Verify',
                    style: roundedBlueBtnTS,
                  ),
                ),
                onPressed: () async {
                  setState(() {
                    isInProgress = true;
                  });
                  final credentials = PhoneAuthProvider.getCredential(
                      verificationId: widget.verificationId,
                      smsCode: verificationCode);
                  if (widget.isSignUp) {
                    await authProvider.createImamAccount(
                        this.imam, credentials);
                  } else {
                    await authProvider.login(
                        credentials: credentials, isImam: true);
                  }

                  setState(() {
                    isInProgress = false;
                  });
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
                              builder: (context) => MosqueDashboardScreen()),
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
              );
            },
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Already have an account?', style: alreadyHaveAccountTS),
              SizedBox(width: 3),
              GestureDetector(
                  child: Text(
                    'Login',
                    style: alreadyHaveAccountTS.copyWith(
                      fontWeight: FontWeight.bold,
                      color: mainThemeColor,
                    ),
                  ),
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ImamLoginScreen()),
                        (route) => false);
                  }),
            ],
          )
        ],
      ),
    );
  }

  void _codeSent(String verificationId, int resendToken) {}
}
