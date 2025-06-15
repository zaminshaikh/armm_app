import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FAQItem {
  final String question;
  final String answer;
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
      answer:
          "On the login screen, tap “Forgot Password” and follow the steps to securely reset your credentials via email or SMS verification.",
    ),
    FAQItem(
      question: "Is the ARMM app available on both iOS and Android?",
      answer:
          "The ARMM Group app is available on both Android and iOS for download on the Apple App Store and Google Play Store.",
    ),
    FAQItem(
      question: "How do I enable or disable push notifications?",
      answer:
          "You can manage notification preferences under \"Profile Settings\" within the app to stay informed about investment updates, document uploads, and account activity.",
    ),
    FAQItem(
      question: "Is there a minimum account balance required to use the ARMM app?",
      answer:
          "There is no minimum balance required to access the app; however, investment offerings may have their own minimum contribution requirements.",
    ),
    FAQItem(
      question: "How often are transactions updated on the ARMM Group App?",
      answer:
          "Transactions on the ARMM Group App are updated regularly, with most activity reflected in real-time or promptly upon confirmation. This allows you to monitor your investment transactions accurately and without delay.",
    ),
    FAQItem(
      question: "How do I request an account statement?",
      answer:
          "To request an account statement, simply email your request—along with the specific months or date range you need—to one of the following:\n\n <a href='mailto:info@armmgroup.com'>info@armmgroup.com</a>\n\n <a href='mailto:mohammed@armmgroup.com'>mohammed@armmgroup.com</a>\n\nYour request will typically be processed within 24 hours.\n\nFor urgent needs, feel free to contact your ARMM advisor directly.",
    ),
    FAQItem(
      question: "Can I add to my existing investment?",
      answer:
          "Yes. You can make additional investments into your current portfolio. Contact your ARMM Group representative for guidance on the process.",
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
                tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      item.answer,
                      style: GoogleFonts.inter(color: Colors.black),
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