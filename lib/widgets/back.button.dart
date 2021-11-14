import 'package:fluddit/widgets/index.dart';
import 'package:get/get.dart';

class NavBackButton extends StatelessWidget {
  const NavBackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Get.back();
      },
      icon: const Icon(
        Icons.arrow_back_ios_new_outlined,
        color: Color(0xFF2e3440),
      ),
    );
  }
}
