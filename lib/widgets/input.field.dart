import 'package:fluddit/widgets/index.dart';

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
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: 250,
      child: TextField(
        controller: widget.controller,
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(9),
            ),
          ),
          filled: true,
          fillColor: Colors.black45,
          focusedBorder: const OutlineInputBorder(
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
          suffix: ConditionalWidget(
            condition: widget.isPassword,
            trueWidget: GestureDetector(
              onTap: passwordVisibilityToggle,
              child: Icon(
                passwordIcon,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
        // Only obscure if the it's a password field and visibility is set to false
        obscureText: widget.isPassword && !passwordVisibility,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
