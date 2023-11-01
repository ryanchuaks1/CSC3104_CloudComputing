import 'package:flutter/material.dart';
import 'package:flutter_app/components/already_have_an_account_check.dart';
import 'package:flutter_app/components/rounded_button.dart';
import 'package:flutter_app/components/rounded_input_field.dart';
import 'package:flutter_app/components/rounded_password_field.dart';
import 'package:flutter_app/src/core/models/user_model.dart';
import 'package:flutter_app/src/core/services/api_service.dart';
import 'package:flutter_app/src/ui/common/show_toast_message.dart';
import 'package:flutter_app/src/ui/views/Login/login_page.dart';
import 'package:flutter_app/src/ui/views/Signup/components/background.dart';
import 'package:flutter_svg/svg.dart';

class Body extends StatelessWidget {
  final Widget child;

  const Body({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    String username = "";
    String password = "";
    Size size = MediaQuery.of(context).size;
    return Background(
        child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "SIGNUP",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: size.height * 0.03),
          SvgPicture.asset(
            "assets/icons/signup.svg",
            height: size.height * 0.35,
          ),
          RoundedInputField(
            hintText: "Your Email",
            onChanged: (value) {
              username = value;
            },
          ),
          RoundedPasswordField(
            onChanged: (value) {
              password = value;
            },
          ),
          RoundedButton(
            text: "SIGNUP",
            onPressed: () async {
              await ApiService()
                  .createAccount(User_Account(
                      userName: username, userPasswordHash: password))
                  .then((data) {
                if (data.result == "True") {
                  ShowToastMessage.showCenterShortToast("SUCCESS");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()));
                } else {
                  print(data.result);
                  ShowToastMessage.showCenterShortToast(data.result);
                }
              });
            },
          ),
          SizedBox(height: size.height * 0.03),
          AlreadyHaveAnAccountCheck(
            login: false,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
    ));
  }
}
