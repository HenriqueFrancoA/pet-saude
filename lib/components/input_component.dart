import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool obscureText;
  final ValueChanged<String>? change;
  final TextAlign align;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onSubmitted;
  final FormFieldValidator<String>? validator;
  final bool readOnly;

  const CustomTextField({
    Key? key,
    this.controller,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.align = TextAlign.left,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.onSubmitted,
    this.change,
    this.validator,
    this.readOnly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textAlign: align,
      textAlignVertical: TextAlignVertical.bottom,
      onChanged: change,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color.fromARGB(125, 245, 245, 245),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        labelText: labelText,
        labelStyle: GoogleFonts.poppins(
          color: Colors.black,
          decorationColor: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
        hintText: hintText,
        hintStyle: GoogleFonts.poppins(
            color: Colors.grey[200],
            decoration: TextDecoration.none,
            fontSize: 16,
            fontWeight: FontWeight.normal),
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
      ),
      style: GoogleFonts.poppins(
        color: Colors.black,
        decoration: TextDecoration.none,
        fontSize: 16,
      ),
      readOnly: readOnly,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onFieldSubmitted: onSubmitted,
      validator: validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, preencha o campo  ${labelText ?? ''}';
            }
            return null;
          },
    );
  }
}
