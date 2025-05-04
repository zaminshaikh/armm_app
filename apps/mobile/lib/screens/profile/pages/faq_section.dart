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
      question: "What is the role of risk in an investment portfolio?",
      answer: "Risk is inherent in investing. It’s the potential for losses..."
    ),
    FAQItem(
      question: "How often should I review my investment portfolio?",
      answer: "Reviewing your portfolio at least once a year (or quarterly)..."
    ),
    FAQItem(
      question: "What is diversification, and why is it important?",
      answer: "Diversification involves spreading your investments across..."
    ),
    FAQItem(
      question: "Can I customize my investment portfolio based on my preferences?",
      answer: "Yes, most investment platforms allow you to choose..."
    ),
    FAQItem(
      question: "Are there fees associated with managing an investment portfolio?",
      answer: "Depending on the platform or advisor, you may incur..."
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