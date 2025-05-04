import 'package:flutter/material.dart';
import 'package:armm_app/utils/resources.dart';
import 'package:google_fonts/google_fonts.dart';
      
class AuthTextField extends StatefulWidget {
  final String hintText;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final InputBorder? border;
  final InputBorder? focusedBorder;
  final EdgeInsetsGeometry? contentPadding;

  const AuthTextField({
    Key? key,
    required this.hintText,
    this.obscureText = false,
    this.onChanged,
    this.controller,
    this.textStyle,
    this.hintStyle,
    this.border,
    this.focusedBorder,
    this.contentPadding,
  }) : super(key: key);

  @override
  _AuthTextFieldState createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: widget.controller,
        obscureText: _obscureText,
        style: widget.textStyle ??
            GoogleFonts.inter(
              fontSize: 18,
              color: Colors.black,
            ),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: widget.hintStyle ??
              GoogleFonts.inter(
                color: Color.fromARGB(100, 0, 0, 0),
              ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: const BorderSide(
              color: Colors.transparent,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: const BorderSide(
              color: Colors.transparent,
            ),
          ),
          focusedBorder: widget.focusedBorder ??
              OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide(
                  color: AppColors.primary,
                ),
              ),
          contentPadding: widget.contentPadding ??
              const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
          suffixIcon: widget.obscureText
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: const Color.fromARGB(130, 0, 0, 0),
                  ),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  splashRadius: 1,
                  onPressed: _toggleVisibility,
                )
              : null,
          fillColor: const Color(0xFFF1F4FF),
          filled: true,
        ),
        onChanged: widget.onChanged,
      ),
    );
  }
}