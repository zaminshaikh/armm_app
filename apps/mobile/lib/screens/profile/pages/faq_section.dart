import 'package:armm_app/utils/resources.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class FAQItem {
  final String question;
  final List<Widget> answer;
  FAQItem({required this.question, required this.answer});
}

class FAQSection extends StatefulWidget {
  const FAQSection({Key? key}) : super(key: key);

  @override
  _FAQSectionState createState() => _FAQSectionState();
}

class _FAQSectionState extends State<FAQSection> {
  final List<FAQItem> _faqItems = [
    FAQItem(
      question: "What should I do if I forget my password?",
      answer: [
        Text(
          "On the login screen, tap “Forgot Password” and follow the steps to securely reset your credentials via email or SMS verification.",
          style: GoogleFonts.inter(color: Colors.black),
        ),
      ],
    ),
    FAQItem(
      question: "Is the ARMM app available on both iOS and Android?",
      answer: [
        Text(
          "The ARMM Group app is available on both Android and iOS for download on the Apple App Store and Google Play Store.",
          style: GoogleFonts.inter(color: Colors.black),
        ),
      ],
    ),
    FAQItem(
      question: "How do I enable or disable push notifications?",
      answer: [
        Text(
          "You can manage notification preferences under \"Profile Settings\" within the app to stay informed about investment updates, document uploads, and account activity.",
          style: GoogleFonts.inter(color: Colors.black),
        ),
      ],
    ),
    FAQItem(
      question: "Is there a minimum account balance required to use the ARMM app?",
      answer: [
        Text(
          "There is no minimum balance required to access the app; however, investment offerings may have their own minimum contribution requirements.",
          style: GoogleFonts.inter(color: Colors.black),
        ),
      ],
    ),
    FAQItem(
      question: "How often are transactions updated on the ARMM Group App?",
      answer: [
        Text(
          "Transactions on the ARMM Group App are updated regularly, with most activity reflected in real-time or promptly upon confirmation. This allows you to monitor your investment transactions accurately and without delay.",
          style: GoogleFonts.inter(color: Colors.black),
        ),
      ],
    ),
    FAQItem(
      question: "How do I request an account statement?",
      answer: [
        Text(
          "To request an account statement, simply email your request—along with the specific months or date range you need—to one of the following:",
          style: GoogleFonts.inter(color: Colors.black),
        ),
        GestureDetector(
          onTap: () => launchUrl(Uri.parse('mailto:info@armmgroup.com')),
          child: Text("info@armmgroup.com",
              style: GoogleFonts.inter(color: AppColors.primary,)),
        ),
        GestureDetector(
          onTap: () => launchUrl(Uri.parse('mailto:mohammed@armmgroup.com')),
          child: Text("mohammed@armmgroup.com",
              style: GoogleFonts.inter(color: AppColors.primary,)),
        ),
        Text(
          "Your request will typically be processed within 24 hours. For urgent needs, feel free to contact your ARMM advisor directly.",
          style: GoogleFonts.inter(color: Colors.black),
        ),
      ],
    ),
    FAQItem(
      question: "Can I add to my existing investment?",
      answer: [
        Text(
          "Yes. You can make additional investments into your current portfolio. Contact your ARMM Group representative for guidance on the process.",
          style: GoogleFonts.inter(color: Colors.black),
        ),
      ],
    ),
  ];

  final List<bool> _isExpanded = [];

  @override
  void initState() {
    super.initState();
    _isExpanded.addAll(List.generate(_faqItems.length, (_) => false));
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _faqItems.length,
      itemBuilder: (context, index) {
        final item = _faqItems[index];
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(16),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                childrenPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                title: Text(
                  item.question,
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                ),
                trailing: Icon(
                  _isExpanded[index] ? Icons.remove : Icons.add,
                  color: const Color(0xFF2B41B8),
                ),
                onExpansionChanged: (expanded) {
                  setState(() {
                    _isExpanded[index] = expanded;
                  });
                },
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: item.answer,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}