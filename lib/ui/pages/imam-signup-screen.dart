import 'package:flutter/material.dart';
import 'package:masjid_finder/constants/colors.dart';
import 'package:masjid_finder/constants/text-styles.dart';
import 'package:masjid_finder/enums/auth-result-status.dart';
import 'package:masjid_finder/models/imam-model.dart';
import 'package:masjid_finder/providers/auth-provider.dart';
import 'package:masjid_finder/services/auth-exception-handler.dart';
import 'package:masjid_finder/ui/custom_widgets/asset-logo.dart';
import 'package:masjid_finder/ui/custom_widgets/custom-blue-rounded-button.dart';
import 'package:masjid_finder/ui/custom_widgets/custom-rounded-textfield.dart';
import 'package:masjid_finder/ui/pages/mosque-not-listed.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

class ImamSignUpScreen extends StatefulWidget {
  @override
  _ImamSignUpScreenState createState() => _ImamSignUpScreenState();
}

class _ImamSignUpScreenState extends State<ImamSignUpScreen> {
  Imam imam = Imam();
  bool isInProgress;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ChangeNotifierProvider(
        create: (context) => AuthProvider(),
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
            hint: 'FirstName LastName',
            label: 'Full Name',
            onChange: (val) {
              imam.fullName = val;
            },
          ),
          CustomRoundedTextField(
            hint: 'userName@email.com',
            label: 'Email',
            onChange: (val) {
              imam.email = val;
            },
          ),
          CustomRoundedTextField(
            hint: '03*******97',
            label: 'Contact',
            onChange: (val) {
              imam.contact = val;
            },
          ),
          CustomRoundedTextField(
            hint: '*********',
            label: 'Password',
            isPassword: true,
            onChange: (val) {
              imam.password = val;
            },
          ),
          SizedBox(height: 20),
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return CustomBlueRoundedButton(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    'SIGN UP',
                    style: roundedBlueBtnTS,
                  ),
                ),
                onPressed: () async {
                  setState(() {
                    isInProgress = true;
                  });
                  await authProvider.createAccount(user: imam, isImam: true);
                  setState(() {
                    isInProgress = false;
                  });
                  if (authProvider.status == AuthResultStatus.successful) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MosqueNotListed()),
                        (r) => false);
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
                  onTap: () {}),
            ],
          )
        ],
      ),
    );
  }
}
