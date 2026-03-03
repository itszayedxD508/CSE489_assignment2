import 'package:flutter/material.dart';
import 'screens/broadcast_receiver_screen.dart';
import 'screens/image_scale_screen.dart';
import 'screens/video_player_screen.dart';
import 'screens/audio_player_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CSE 489 Assignment 2',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = [
    BroadcastReceiverScreen(),
    ImageScaleScreen(),
    VideoPlayerScreen(),
    AudioPlayerScreen(),
  ];

  static const List<String> _titles = [
    'Broadcast Receiver',
    'Image Scale',
    'Video Player',
    'Audio Player',
  ];

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context); // Close the drawer
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.deepPurple),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.apps, color: Colors.white, size: 48),
                  SizedBox(height: 8),
                  Text(
                    'CSE 489 Assignment 2',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Menu Options',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.broadcast_on_personal),
              title: const Text('A. Broadcast Receiver'),
              selected: _selectedIndex == 0,
              onTap: () => _onItemSelected(0),
            ),
            ListTile(
              leading: const Icon(Icons.zoom_in),
              title: const Text('B. Image Scale'),
              selected: _selectedIndex == 1,
              onTap: () => _onItemSelected(1),
            ),
            ListTile(
              leading: const Icon(Icons.video_library),
              title: const Text('C. Video'),
              selected: _selectedIndex == 2,
              onTap: () => _onItemSelected(2),
            ),
            ListTile(
              leading: const Icon(Icons.audiotrack),
              title: const Text('D. Audio'),
              selected: _selectedIndex == 3,
              onTap: () => _onItemSelected(3),
            ),
          ],
        ),
      ),
      body: _screens[_selectedIndex],
    );
  }
}
