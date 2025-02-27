import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FontTestScreen extends StatelessWidget {
  const FontTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Font Weight Test'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Inter Font Weights (Google Fonts)',
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            
            _buildFontWeightRow('Thin (w100)', FontWeight.w100),
            _buildFontWeightRow('Extra-Light (w200)', FontWeight.w200),
            _buildFontWeightRow('Light (w300)', FontWeight.w300),
            _buildFontWeightRow('Regular (w400)', FontWeight.w400),
            _buildFontWeightRow('Medium (w500)', FontWeight.w500),
            _buildFontWeightRow('SemiBold (w600)', FontWeight.w600),
            _buildFontWeightRow('Bold (w700)', FontWeight.w700),
            _buildFontWeightRow('Extra-Bold (w800)', FontWeight.w800),
            _buildFontWeightRow('Black (w900)', FontWeight.w900),
            
            const SizedBox(height: 30),
            Text(
              'Compare Weights Side-by-Side:',
              style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            
            _buildComparisonRow('400 vs 500', FontWeight.w400, FontWeight.w500),
            _buildComparisonRow('500 vs 600', FontWeight.w500, FontWeight.w600),
            _buildComparisonRow('600 vs 700', FontWeight.w600, FontWeight.w700),
            _buildComparisonRow('700 vs 800', FontWeight.w700, FontWeight.w800),
            _buildComparisonRow('800 vs 900', FontWeight.w800, FontWeight.w900),
            
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Back to Dashboard',
                style: GoogleFonts.inter(),
              ),
            ),
            
            const SizedBox(height: 30),
            Text(
              'How Google Fonts differ from local fonts:',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '• Google Fonts provides more reliable weight rendering across platforms\n'
              '• Weight differences are more consistent and noticeable\n'
              '• No need to manage font files in your assets',
              style: GoogleFonts.inter(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFontWeightRow(String label, FontWeight weight) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          Text(
            'Inter Font Sample',
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: weight,
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
  
  Widget _buildComparisonRow(String label, FontWeight weight1, FontWeight weight2) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Sample Text',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: weight1,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'Sample Text',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: weight2,
                  ),
                ),
              ),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }
}
