import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CommandListWidget extends StatefulWidget {
  final List<String> filteredCommands;
  final TextEditingController controller;
  final void Function(String) handleCommand;
  final void Function(String) setLayerName;
  final void Function(int) setLayer;

  CommandListWidget({
    required this.filteredCommands,
    required this.controller,
    required this.handleCommand,
    required this.setLayerName,
    required this.setLayer,
  });

  @override
  _CommandListWidgetState createState() => _CommandListWidgetState();
}

class _CommandListWidgetState extends State<CommandListWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: Colors.black,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.filteredCommands.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ElevatedButton(
              onPressed: () {
                String command = widget.filteredCommands[index];
                if (command[command.length - 1] != ' ') {
                  widget.handleCommand(widget.controller.text + command);
                  print("No space in command");
                } else {
                  widget.setLayerName(command);
                  widget.setLayer(1);
                  print("After click: " + command);
                  print(1);
                  widget.controller.text += command;
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                  side: const BorderSide(color: Colors.green),
                ),
              ),
              child: Text(
                widget.filteredCommands[index],
                style: GoogleFonts.robotoMono(
                  textStyle: const TextStyle(color: Colors.black, letterSpacing: .5),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
