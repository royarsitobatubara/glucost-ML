import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TxtInputDiabetes extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool isDecimal;
  final IconData? icon;

  const TxtInputDiabetes({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.isDecimal = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.numberWithOptions(
          decimal: isDecimal,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.allow(
            RegExp(isDecimal ? r'^\d*\.?\d*' : r'\d*'),
          ),
        ],
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: icon != null ? Icon(icon) : null,

          filled: true,
          fillColor: Colors.white,

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Colors.grey.shade300,
              width: 1.2,
            ),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Colors.blue,
              width: 2,
            ),
          ),

          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 1.5,
            ),
          ),

          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 2,
            ),
          ),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty ) {
            return '$label tidak boleh kosong';
          }

          if (double.tryParse(value) == null) {
            return 'Masukkan angka yang valid';
          }

          return null;
        },
      ),
    );
  }
}