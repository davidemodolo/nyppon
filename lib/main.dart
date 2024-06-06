import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nyppon/input.dart';
import 'package:nyppon/suggestions.dart';

void main() {
  runApp(const ConsoleApp());
}

Map<String, String> toAsciiMap = {
  'wishlist': '''
Yb        dP 88 .dP"Y8 88  88 88     88 .dP"Y8 888888 
 Yb  db  dP  88 `Ybo." 88  88 88     88 `Ybo."   88   
  YbdPYbdP   88 o.`Y8b 888888 88  .o 88 o.`Y8b   88   
   YP  YP    88 8bodP' 88  88 88ood8 88 8bodP'   88  
''',
  'shops': '''
.dP"Y8 88  88  dP"Yb  88""Yb .dP"Y8 
`Ybo." 88  88 dP   Yb 88__dP `Ybo." 
o.`Y8b 888888 Yb   dP 88"""  o.`Y8b 
8bodP' 88  88  YbodP  88     8bodP' 
''',
  'settings': '''
.dP"Y8 888888 888888 888888 88 88b 88  dP""b8 .dP"Y8 
`Ybo." 88__     88     88   88 88Yb88 dP   `" `Ybo." 
o.`Y8b 88""     88     88   88 88 Y88 Yb  "88 o.`Y8b 
8bodP' 888888   88     88   88 88  Y8  YboodP 8bodP' 
''',
};

String chosenCategory = toAsciiMap['wishlist']!;

List<String> availableCommands = [
  '/help',
  '/hello',
  '/filter ',
  '/settings',
  '/wishlist',
  '/shops',
  '/clear',
  '/new'
];
int layer = 0;
String layer_name = '';

Map<String, List<String>> layer2 = {
  '/filter ': [
    'videogame',
    'manga',
    'console',
    'card'
  ]
};

class ConsoleApp extends StatelessWidget {
  const ConsoleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nyppon',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const ConsoleScreen(),
    );
  }
}

class ConsoleScreen extends StatefulWidget {
  const ConsoleScreen({super.key});

  @override
  _ConsoleScreenState createState() => _ConsoleScreenState();
}

class _ConsoleScreenState extends State<ConsoleScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _log = [];
  List<String> _filteredCommands = availableCommands;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_filterCommands);
  }

  void _handleCommand(String command) {
    setState(() {
      _log.add('> $command');
      _log.add(_getResponse(command));
    });
    _controller.clear();
  }

  String _getResponse(String command) {
    if (command.startsWith('/')) {
      List<String> parts = command.split(' ');
      String cmd = parts[0].substring(1);
      List<String> args = parts.sublist(1);
      switch (cmd.toLowerCase()) {
        case 'help':
          return 'Available commands: help, hello, clear';
        case 'hello':
          return 'Hello, user!';
        case 'settings' || 'wishlist' || 'shops':
          setState(() {
            chosenCategory = toAsciiMap[cmd]!;
          });
          return 'Category changed to: $cmd';
        case 'clear':
          setState(() {
            _log.clear();
          });
          return '';
        case 'changecategory':
          if (args.isNotEmpty) {
            String category = args[0];
            if (toAsciiMap.containsKey(category)) {
              setState(() {
                chosenCategory = toAsciiMap[category]!;
              });
              return 'Category changed to: $category';
            }
            return 'Category not found: $category';
          }
          return 'No category provided for changecategory command';
        default:
          return 'Unknown command: $cmd';
      }
    }
    return 'Invalid command format: $command';
  }

  void _filterCommands() {
    String query = _controller.text.toLowerCase();
    setState(() {
      if (layer == 0){
      _filteredCommands = availableCommands
          .where((command) => command.toLowerCase().contains(query))
          .toList();
      }
      else{
        print("Layer 2" + layer_name);
        if(layer2.containsKey(layer_name)){
        _filteredCommands = layer2[layer_name]!.toList();
          // !.where((command) => command.toLowerCase().contains(query))
          // .toList();
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_filterCommands);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Nyppon Console',
          style: GoogleFonts.robotoMono(
                  textStyle: const TextStyle(color: Colors.green, letterSpacing: .5),
                ),
        ),
      ),
      body: Column(
        children: [
          // category title
          Container(
            color: Colors.black,
            height: 100,
            child: Center(
              child: Text(
                chosenCategory,
                style: GoogleFonts.robotoMono(
                  textStyle: const TextStyle(color: Colors.green, letterSpacing: .5),
                ),
              ),
            ),
          ),
          // log view
          Expanded(
            child: ListView.builder(
              itemCount: _log.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _log[index],
                    style: const TextStyle(color: Colors.green, fontFamily: 'monospace'),
                  ),
                );
              },
            ),
          ),
          // suggestions
          CommandListWidget(
            filteredCommands: _filteredCommands,
            controller: _controller,
            handleCommand: _handleCommand,
            setLayerName: (String name) {
              setState(() {
                layer_name = name;
              });
            },
            setLayer: (int newLayer) {
              setState(() {
                layer = newLayer;
              });
            },
          ),
          // input field and submit button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CommandInputWidget(
        controller: _controller,
        handleCommand: _handleCommand,
      )
          ),
        ],
      ),
    );
  }
}
