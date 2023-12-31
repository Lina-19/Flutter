import 'package:crud/screens/home_screen.dart';
import 'package:crud/screens/signup_screen.dart';
import 'package:crud/utils/color_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:crud/reusable_widgets/reusable_widget.dart';
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<SignInScreen> {
   TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
 @override
Widget build(BuildContext context) {
  return Scaffold(
    body: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            hexStringToColor("CB2B93"),
            hexStringToColor("9546C4"),
            hexStringToColor("5E61F4"),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            MediaQuery.of(context).size.height * 0.2,
            20,
            0,
          ),
          child: Column(
            children: <Widget>[
              logoWidget("assets/images/logo1.png"),
              SizedBox(
                height: 30,
              ),
              reusableTextField(
                "Enter username",
                Icons.verified_user,
                false,
                _emailTextController,
              ),
              const SizedBox(
                height: 20,
              ),
              reusableTextField(
                "Enter Password",
                Icons.lock_outline,
                true,
                _passwordTextController,
              ),
              const SizedBox(
                height: 5, // Adjust this value as needed
              ),
              firebaseUIButton(context,'LogIn',(){
                FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: _emailTextController.text,
                   password: _passwordTextController.text).then((value) {
                     Navigator.push(context,
                   MaterialPageRoute(builder: (context) => HomeScreen()));
                   }).onError((error, stackTrace) {
                    print("Error ${error.toString()}");
                   });
                   
              }),
              signUpOption(),
               const SizedBox(
                height: 60, // Adjust this value as needed
              ),

            ],
          ),
        ),
      ),
    ),
  );
}

Row signUpOption(){
return Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    const Text("Don't have account?"),
     GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SignUpScreen()));
          },
          child: const Text(
            " Sign Up",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
  ],
);
}
}





