import 'package:flutter/material.dart';

class CommandInputWidget extends StatefulWidget {
  final TextEditingController controller;
  final void Function(String) handleCommand;

  CommandInputWidget({required this.controller, required this.handleCommand});

  @override
  _CommandInputWidgetState createState() => _CommandInputWidgetState();
}

class _CommandInputWidgetState extends State<CommandInputWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: widget.controller,
            style: const TextStyle(color: Colors.white, fontFamily: 'monospace'),
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
              labelText: 'Enter command',
              labelStyle: TextStyle(color: Colors.green),
            ),
            cursorColor: Colors.green,
            onSubmitted: widget.handleCommand,
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () => widget.handleCommand(widget.controller.text),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
              side: const BorderSide(color: Colors.green),
            ),
            // padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          child: const Text(
            'Submit',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'monospace',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
