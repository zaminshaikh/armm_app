import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LinkSentIllustration extends StatelessWidget {
  const LinkSentIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 40),
        SvgPicture.asset(
          'assets/icons/link_sent_icon.svg',
          width: 150,
          height: 150,
          semanticsLabel: 'Link Sent Illustration',
          placeholderBuilder: (BuildContext context) {
            return const CircularProgressIndicator();
          },
        ),
      ],
    );
  }
}
