import 'package:flutter/material.dart';

import 'shortcuts_tool.dart';
import 'step_edit_tool.dart';
import 'theme.dart';

class MpcSampleHelperApp extends StatelessWidget {
  const MpcSampleHelperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MPC Sample Helper',
      theme: buildTheme(Brightness.light),
      darkTheme: buildTheme(Brightness.dark),
      home: const _ToolShell(),
    );
  }
}

/// A Tool shown as one destination of the bottom navigation bar.
class _Tool {
  const _Tool(this.label, this.icon, this.body);

  final String label;
  final IconData icon;
  final Widget body;
}

const _tools = [
  _Tool('STEP EDIT', Icons.grid_on, StepEditTool()),
  _Tool('Shortcuts', Icons.keyboard, ShortcutsTool()),
];

class _ToolShell extends StatefulWidget {
  const _ToolShell();

  @override
  State<_ToolShell> createState() => _ToolShellState();
}

class _ToolShellState extends State<_ToolShell> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MPC Sample Helper')),
      body: SafeArea(
        child: IndexedStack(
          index: _selected,
          children: [for (final tool in _tools) tool.body],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selected,
        onDestinationSelected: (index) => setState(() => _selected = index),
        destinations: [
          for (final tool in _tools)
            NavigationDestination(icon: Icon(tool.icon), label: tool.label),
        ],
      ),
    );
  }
}
