import 'package:flutter/material.dart';

class BranchOne extends StatefulWidget {
  const BranchOne({super.key});

  @override
  State<BranchOne> createState() => _BranchOneState();
}

class _BranchOneState extends State<BranchOne> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('branch testing '),),
    );
  }
}