import 'package:chat_app/page/registartion.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/database_helper.dart';

class Event {
  String name;
  String description;
  String time;
  List<String> rules;
  double fee;
  List<String> subEvents;
  int registrations;
  String? organiserName;

  Event({
    required this.name,
    required this.description,
    required this.time,
    required this.rules,
    required this.fee,
    required this.subEvents,
    this.registrations = 0,
    this.organiserName,
  });

  void register() {
    registrations++;
  }

  void editEvent({
    String? newName,
    String? newDescription,
    String? newTime,
    List<String>? newRules,
    double? newFee,
    List<String>? newSubEvents,
  }) {
    if (newName != null) name = newName;
    if (newDescription != null) description = newDescription;
    if (newTime != null) time = newTime;
    if (newRules != null) rules = newRules;
    if (newFee != null) fee = newFee;
    if (newSubEvents != null) subEvents = newSubEvents;
  }

  void deleteEvent() {
    // Code to delete event (e.g., remove from list or database)
  }
}

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final List<Event> _events = [
    Event(
      name: 'Dancing Competition',
      description: 'Show off your dance moves in a thrilling competition.',
      time: '10:00 AM, 16th Oct',
      rules: [
        'Arrive 15 minutes early.',
        'Dress code: Casual dance attire.',
        'Max 3 minutes for performance.',
      ],
      fee: 1.0,
      subEvents: ['Solo Dance', 'Group Dance', 'Freestyle Dance'],
    ),
    Event(
      name: 'Singing Contest',
      description: 'Sing your heart out and win exciting prizes!',
      time: '1:00 PM, 16th Oct',
      rules: [
        'Maximum song duration is 4 minutes.',
        'Accompanied by a background track only.',
        'No explicit lyrics allowed.',
      ],
      fee: 50.0,
      subEvents: ['Solo Singing', 'Duet Singing', 'Group Singing'],
    ),
    Event(
      name: 'Drama Play',
      description: 'A captivating play performance by the drama club.',
      time: '3:00 PM, 17th Oct',
      rules: [
        'Maximum performance time: 20 minutes.',
        'Props should be arranged in advance.',
        'Participants must be dressed in costume before the event.',
      ],
      fee: 150.0,
      subEvents: ['Short Skits', 'Full Plays', 'Improv'],
    ),
    Event(
      name: 'Art Exhibition',
      description: 'A showcase of the best artistic creations by students.',
      time: '10:00 AM, 18th Oct',
      rules: [
        'Art submissions should be handed in by 9:00 AM.',
        'No digital artworks allowed.',
        'Only one submission per student.',
      ],
      fee: 70.0,
      subEvents: ['Painting', 'Sketching', 'Sculpture'],
    ),
  ];

  // List of Organizers (3 from GIT Aura, TechFest, and 1 from database_helper.dart)
  final List<Map<String, String>> _organizers = [
    {'name': 'Amit Gupta', 'eventCount': '5'},
    {'name': 'Neha Yadav', 'eventCount': '3'},
    {'name': 'John Doe', 'eventCount': '4'},
    {'name': 'Sandy Patel', 'eventCount': '2'},
    {'name': 'Priya Sharma', 'eventCount': '5'},
  ];

  void _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacementNamed('/');
  }

  // Navigate to the registration screen with event details
  void _navigateToRegistration(
    BuildContext context,
    String eventName,
    String eventDetails,
    List<String> eventRules,
    double eventFee,
    List<String> subEvents,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RegistrationScreen(
          eventName: eventName,
          eventDetails: eventDetails,
          eventRules: eventRules,
          eventFee: eventFee,
          subEvents: subEvents,
        ),
      ),
    );
  }

  void _deleteEvent(int index) {
    setState(() {
      _events.removeAt(index);
    });
  }

  void _deleteOrganizer(int index) {
    setState(() {
      _organizers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue, // Blue background color
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => _signOut(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Event Registration Details',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(
                    255, 60, 98, 128), // Highlighted headline in blue
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _events.length,
              itemBuilder: (context, index) {
                final event = _events[index];
                return Card(
                  color: const Color.fromARGB(255, 80, 231, 213),
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 8.0, // Adding shadow effect
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16.0),
                    title: Text(
                      event.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue, // Highlighting event name
                      ),
                    ),
                    subtitle: Text(
                      '${event.description}\nTime: ${event.time}\nFee: \$${event.fee}\nSub-events: ${event.subEvents.join(', ')}',
                    ),
                    onTap: () => _navigateToRegistration(
                      context,
                      event.name,
                      event.description,
                      event.rules,
                      event.fee,
                      event.subEvents,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteEvent(index),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Organizer Details',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(
                    255, 22, 63, 96), // Highlighted headline in blue
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _organizers.length,
              itemBuilder: (context, index) {
                final organizer = _organizers[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  color: const Color.fromARGB(255, 113, 199, 152),
                  elevation: 8.0, // Adding shadow effect
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16.0),
                    title: Text(
                      organizer['name']!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue, // Highlighting organizer name
                      ),
                    ),
                    subtitle: Text(
                      'Events managed: ${organizer['eventCount']}',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteOrganizer(index),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
