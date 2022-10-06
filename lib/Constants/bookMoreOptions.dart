import 'package:flutter/material.dart';

class BookMoreOption {
  final IconData icon;
  final String title;
  // final VoidCallback onTap;
  BookMoreOption({
    required this.icon,
    required this.title,
    // required this.onTap,
  });
}

List<BookMoreOption> bookMoreOptions = [
  BookMoreOption(icon: Icons.edit, title: 'Rename'),
  BookMoreOption(icon: Icons.copy, title: 'Duplicate Book'),
  BookMoreOption(icon: Icons.person_add_alt, title: 'Add Member'),
  BookMoreOption(icon: Icons.delete_outline_rounded, title: 'Delete'),
];
