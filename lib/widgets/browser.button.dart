import 'dart:developer';

import 'package:fluddit/widgets/index.dart';
import 'package:url_launcher/url_launcher.dart';

class BrowserButton extends StatelessWidget {
  const BrowserButton({Key? key, required this.url}) : super(key: key);

  final String url;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        await canLaunch(url) ? await launch(url) : log('Could not launch $url');
      },
      icon: const Icon(
        Icons.language_outlined,
        color: Color(0xFF2e3440),
      ),
    );
  }
}
