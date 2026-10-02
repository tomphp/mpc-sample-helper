import 'package:flutter/material.dart';

class ShortcutsTool extends StatelessWidget {
  const ShortcutsTool({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Text(
        'A list of shortcuts that are not labelled on the front panel.',
      ),
    );
  }
}
