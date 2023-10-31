import 'package:flutter/material.dart';
import 'package:flutter_app/components/already_have_an_account_check.dart';
import 'package:flutter_app/components/rounded_button.dart';
import 'package:flutter_app/components/rounded_input_field.dart';
import 'package:flutter_app/components/rounded_password_field.dart';
import 'package:flutter_app/src/core/models/user_model.dart';
import 'package:flutter_app/src/core/services/api_service.dart';
import 'package:flutter_app/src/ui/common/show_toast_message.dart';
import 'package:flutter_app/src/ui/views/Login/components/background.dart';
import 'package:flutter_app/src/ui/views/Signup/signup_page.dart';
import 'package:flutter_app/src/ui/views/home_page.dart';
import 'package:flutter_svg/svg.dart';

class Body extends StatelessWidget {
  const Body({
    super.key,
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
          const Text("LOGIN", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: size.height * 0.03),
          SvgPicture.asset(
            "assets/icons/login.svg",
            height: size.height * 0.35,
          ),
          SizedBox(height: size.height * 0.03),
          RoundedInputField(
              hintText: "Your Email",
              onChanged: (value) {
                username = value;
              }),
          RoundedPasswordField(onChanged: (value) {
            password = value;
          }),
          RoundedButton(
            text: "LOGIN",
            onPressed: () async {
              await ApiService()
                  .login(User_Account(
                      userName: username, userPasswordHash: password))
                  .then((data) {
                if (data.result == "True") {
                  ShowToastMessage.showCenterShortToast("SUCCESS");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomePage(userId: data.userId)),
                  );
                } else {
                  print(data.result);
                  ShowToastMessage.showCenterShortToast(data.result);
                }
              });
            },
          ),
          SizedBox(height: size.height * 0.03),
          AlreadyHaveAnAccountCheck(
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SignUpPage()),
              );
            },
          )
        ],
      ),
    ));
  }
}
