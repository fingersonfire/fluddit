import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  const InputField({
    Key? key,
    required this.fieldLabel,
    required this.controller,
    this.isPassword = false,
  }) : super(key: key);

  final String fieldLabel;
  final TextEditingController controller;
  final bool isPassword;

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  bool passwordVisibility = false;
  IconData passwordIcon = Icons.visibility_off_outlined;

  void passwordVisibilityToggle() {
    setState(() {
      if (passwordVisibility) {
        passwordVisibility = false;
        passwordIcon = Icons.visibility_off_outlined;
      } else {
        passwordVisibility = true;
        passwordIcon = Icons.visibility_outlined;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: 250,
      child: TextField(
        controller: widget.controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(9),
            ),
          ),
          filled: true,
          fillColor: Colors.black45,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(9),
            ),
            borderSide: BorderSide(
              width: 1,
              color: Colors.white,
            ),
          ),
          labelStyle: TextStyle(
            color: Colors.grey[350],
          ),
          labelText: widget.fieldLabel,
          // Password visibility suffix widget
          suffix: widget.isPassword
              ? GestureDetector(
                  onTap: passwordVisibilityToggle,
                  child: Icon(
                    passwordIcon,
                    color: Colors.white,
                    size: 20,
                  ),
                )
              : null,
        ),
        // Only obscure if the it's a password field and visibility is set to false
        obscureText: widget.isPassword && !passwordVisibility,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
