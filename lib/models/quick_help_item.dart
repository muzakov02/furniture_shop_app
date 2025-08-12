import 'package:flutter/cupertino.dart';

class QuickHelpItem{
  final IconData icon;
  final String title;
  final VoidCallback onTab;

  QuickHelpItem({
    required this.icon,
    required this.title,
    required this.onTab,

  });
}