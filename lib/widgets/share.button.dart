import 'package:fluddit/widgets/index.dart';
import 'package:share_plus/share_plus.dart';

class ShareButton extends StatelessWidget {
  const ShareButton({Key? key, required this.url}) : super(key: key);

  final String url;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Share.share(url);
      },
      icon: const Icon(
        Icons.share_outlined,
        color: Color(0xFF2e3440),
      ),
    );
  }
}
