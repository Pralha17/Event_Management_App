import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../page/QRpage.dart';
import '../page/registartion.dart';

class Event {
  final String name;
  final String description;
  final String time;
  final List<String> rules;
  final double fee;
  final List<String> subEvents;

  Event({
    required this.name,
    required this.description,
    required this.time,
    required this.rules,
    required this.fee,
    required this.subEvents,
  });
}

class StudentScreen extends StatefulWidget {
  const StudentScreen({super.key});

  @override
  _StudentScreenState createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  String searchText = '';

  final List<Event> events = [
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

  final List<String> sliderImages = [
    'assets/images/img1.png',
    'assets/images/img2.png',
    'assets/images/img3.png',
    'assets/images/img4.png',
    'assets/images/img5.png',
  ];

  @override
  Widget build(BuildContext context) {
    final filteredEvents = events
        .where((event) =>
            event.name.toLowerCase().contains(searchText.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Student Dashboard',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: Colors.blue,
        elevation: 4,
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Student Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.event),
              title: const Text('View Events'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.qr_code),
              title: const Text('QR'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const QRPage(qrData: ''),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                FirebaseAuth.instance.signOut();
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search Events',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
            ),
          ),
          CarouselSlider(
            options: CarouselOptions(
              height: 180.0,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 5),
              enlargeCenterPage: true,
            ),
            items: sliderImages.map((imagePath) {
              return Builder(
                builder: (BuildContext context) {
                  return Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                  );
                },
              );
            }).toList(),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Upcoming Events',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredEvents.length,
              itemBuilder: (context, index) {
                final event = filteredEvents[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: const Icon(Icons.event),
                    title: Text(event.name),
                    subtitle: Text(
                      '${event.description}\nTime: ${event.time}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    isThreeLine: true,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => RegistrationScreen(
                            eventName: event.name,
                            eventDetails: event.description,
                            eventRules: event.rules,
                            eventFee: event.fee,
                            subEvents: event.subEvents,
                          ),
                        ),
                      );
                    },
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
