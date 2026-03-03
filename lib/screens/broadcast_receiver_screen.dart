import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';

/// Screen 1: Broadcast Receiver selection with spinner
class BroadcastReceiverScreen extends StatefulWidget {
  const BroadcastReceiverScreen({super.key});

  @override
  State<BroadcastReceiverScreen> createState() =>
      _BroadcastReceiverScreenState();
}

class _BroadcastReceiverScreenState extends State<BroadcastReceiverScreen> {
  String _selectedOption = 'Custom broadcast receiver';

  final List<String> _options = [
    'Custom broadcast receiver',
    'System battery notification receiver',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Select Broadcast Operation',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.deepPurple),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedOption,
                isExpanded: true,
                items: _options.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedOption = newValue!;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              if (_selectedOption == 'Custom broadcast receiver') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CustomBroadcastInputScreen(),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BatteryReceiverScreen(),
                  ),
                );
              }
            },
            icon: const Icon(Icons.arrow_forward),
            label: const Text('Proceed'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

/// Screen 2a: Custom Broadcast - Text Input
class CustomBroadcastInputScreen extends StatefulWidget {
  const CustomBroadcastInputScreen({super.key});

  @override
  State<CustomBroadcastInputScreen> createState() =>
      _CustomBroadcastInputScreenState();
}

class _CustomBroadcastInputScreenState
    extends State<CustomBroadcastInputScreen> {
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Broadcast'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Enter a text message to broadcast:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                hintText: 'Enter your message here...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.message),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                if (_textController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a message to broadcast'),
                    ),
                  );
                  return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CustomBroadcastReceiverScreen(
                      message: _textController.text.trim(),
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.send),
              label: const Text('Send Broadcast'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Screen 2b: Battery Notification Receiver
class BatteryReceiverScreen extends StatefulWidget {
  const BatteryReceiverScreen({super.key});

  @override
  State<BatteryReceiverScreen> createState() => _BatteryReceiverScreenState();
}

class _BatteryReceiverScreenState extends State<BatteryReceiverScreen> {
  final Battery _battery = Battery();
  int _batteryLevel = -1;
  BatteryState _batteryState = BatteryState.unknown;

  @override
  void initState() {
    super.initState();
    _getBatteryInfo();
    // Listen for battery state changes (simulates BroadcastReceiver)
    _battery.onBatteryStateChanged.listen((BatteryState state) {
      if (mounted) {
        setState(() {
          _batteryState = state;
        });
        _getBatteryLevel();
      }
    });
  }

  Future<void> _getBatteryInfo() async {
    await _getBatteryLevel();
    final state = await _battery.batteryState;
    if (mounted) {
      setState(() {
        _batteryState = state;
      });
    }
  }

  Future<void> _getBatteryLevel() async {
    final level = await _battery.batteryLevel;
    if (mounted) {
      setState(() {
        _batteryLevel = level;
      });
    }
  }

  String _getBatteryStateText() {
    switch (_batteryState) {
      case BatteryState.full:
        return 'Full';
      case BatteryState.charging:
        return 'Charging';
      case BatteryState.discharging:
        return 'Discharging';
      case BatteryState.connectedNotCharging:
        return 'Connected (Not Charging)';
      case BatteryState.unknown:
        return 'Unknown';
    }
  }

  IconData _getBatteryIcon() {
    if (_batteryLevel < 0) return Icons.battery_unknown;
    if (_batteryLevel <= 20) return Icons.battery_1_bar;
    if (_batteryLevel <= 40) return Icons.battery_3_bar;
    if (_batteryLevel <= 60) return Icons.battery_4_bar;
    if (_batteryLevel <= 80) return Icons.battery_5_bar;
    return Icons.battery_full;
  }

  Color _getBatteryColor() {
    if (_batteryLevel < 0) return Colors.grey;
    if (_batteryLevel <= 20) return Colors.red;
    if (_batteryLevel <= 50) return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Battery Notification Receiver'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(_getBatteryIcon(), size: 100, color: _getBatteryColor()),
              const SizedBox(height: 24),
              Text(
                _batteryLevel >= 0
                    ? 'Battery Level: $_batteryLevel%'
                    : 'Reading battery...',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: _getBatteryColor(),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Status: ${_getBatteryStateText()}',
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: _getBatteryInfo,
                icon: const Icon(Icons.refresh),
                label: const Text('Refresh'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'This screen receives the battery percentage broadcast '
                    'similar to Android\'s ACTION_BATTERY_CHANGED '
                    'BroadcastReceiver.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Screen 3: Custom Broadcast Receiver - Displays received message
class CustomBroadcastReceiverScreen extends StatelessWidget {
  final String message;

  const CustomBroadcastReceiverScreen({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Broadcast Receiver'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.broadcast_on_personal,
                size: 80,
                color: Colors.deepPurple,
              ),
              const SizedBox(height: 24),
              const Text(
                'Broadcast Received!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Text(
                        'Received Message:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        message,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () {
                  // Go back to home (pop all routes)
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                icon: const Icon(Icons.home),
                label: const Text('Back to Home'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
