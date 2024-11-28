import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:chat_app/data/database_helper.dart';

class OrganizerScreen extends StatefulWidget {
  const OrganizerScreen({super.key});

  @override
  _OrganizerScreenState createState() => _OrganizerScreenState();
}

class _OrganizerScreenState extends State<OrganizerScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _amountController = TextEditingController();
  final _organizerNameController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  List<Map<String, dynamic>> _events = [];
  String? _organizerName;

  @override
  void initState() {
    super.initState();
    _loadOrganizerName();
  }

  @override
  void dispose() {
    // Dispose of all controllers to prevent memory leaks
    _nameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _amountController.dispose();
    _organizerNameController.dispose();
    super.dispose();
  }

  void _loadOrganizerName() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final savedName =
          await DatabaseHelper.instance.getOrganizerName(currentUser.uid);

      if (savedName == null) {
        // Prompt for organizer name if not already saved
        await _showNamePrompt(currentUser.uid);
      } else {
        setState(() {
          _organizerName = savedName;
        });
      }
    }
    _loadEvents();
  }

  Future<void> _showNamePrompt(String organizerId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Welcome Organizer'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text(
                    'Please enter your name to personalize your dashboard.'),
                TextField(
                  controller: _organizerNameController,
                  decoration: const InputDecoration(
                    hintText: 'Enter your name',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Save'),
              onPressed: () async {
                final name = _organizerNameController.text.trim();
                if (name.isNotEmpty) {
                  await DatabaseHelper.instance
                      .saveOrganizerName(organizerId, name);
                  setState(() {
                    _organizerName = name;
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _loadEvents() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final events = await DatabaseHelper.instance
          .getAllEvents(organizerId: currentUser.uid);
      setState(() {
        _events = events;
      });
    }
  }

  void _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacementNamed('/');
  }

  void _createOrUpdateEvent({Map<String, dynamic>? existingEvent}) async {
    // Reset or populate controllers
    if (existingEvent == null) {
      _clearForm();
    } else {
      _nameController.text = existingEvent['name'] ?? '';
      _descriptionController.text = existingEvent['description'] ?? '';
      _locationController.text = existingEvent['location'] ?? '';
      _amountController.text = existingEvent['amount']?.toString() ?? '';

      _selectedDate = existingEvent['date'] != null
          ? DateFormat('yyyy-MM-dd').parse(existingEvent['date'])
          : null;

      _selectedTime = existingEvent['time'] != null
          ? TimeOfDay(
              hour: int.parse(existingEvent['time'].split(":")[0]),
              minute: int.parse(existingEvent['time'].split(":")[1]),
            )
          : null;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Event Details",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _nameController,
                      label: 'Event Name',
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _descriptionController,
                      label: 'Event Description',
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _locationController,
                      label: 'Event Location',
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _amountController,
                      label: 'Event Amount',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                            ),
                            onPressed: () async {
                              final selected = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (selected != null) {
                                setState(() => _selectedDate = selected);
                              }
                            },
                            child: Text(_selectedDate == null
                                ? 'Select Date'
                                : DateFormat('yyyy-MM-dd')
                                    .format(_selectedDate!)),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                            ),
                            onPressed: () async {
                              final selected = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (selected != null) {
                                setState(() => _selectedTime = selected);
                              }
                            },
                            child: Text(_selectedTime == null
                                ? 'Select Time'
                                : _selectedTime!.format(context)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        final currentUser = FirebaseAuth.instance.currentUser;
                        if (currentUser == null) return;

                        final event = {
                          'name': _nameController.text,
                          'description': _descriptionController.text,
                          'location': _locationController.text,
                          'date': _selectedDate != null
                              ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                              : null,
                          'time': _selectedTime != null
                              ? _selectedTime!.format(context)
                              : null,
                          'amount': double.tryParse(_amountController.text),
                          'organizerId': currentUser.uid,
                        };

                        if (existingEvent != null) {
                          event['id'] = existingEvent['id'];
                          await DatabaseHelper.instance.updateEvent(event);
                        } else {
                          await DatabaseHelper.instance.insertEvent(event);
                        }

                        _loadEvents();
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: Text(
                        existingEvent != null ? 'Update Event' : 'Create Event',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _deleteEvent(int id) async {
    await DatabaseHelper.instance.deleteEvent(id);
    _loadEvents();
  }

  void _clearForm() {
    _nameController.clear();
    _descriptionController.clear();
    _locationController.clear();
    _amountController.clear();
    _selectedDate = null;
    _selectedTime = null;
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Organizer Dashboard',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => _signOut(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Welcome Card
            Card(
              elevation: 6,
              color: Colors.blue[50],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hi, ${_organizerName ?? 'Organizer'}!',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Ready to organize your next great event?',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue[700],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Events List
            Expanded(
              child: _events.isEmpty
                  ? const Center(
                      child: Text(
                        'No Events Found!',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _events.length,
                      itemBuilder: (context, index) {
                        final event = _events[index];
                        return Card(
                          elevation: 5,
                          shadowColor: const Color.fromARGB(255, 30, 68, 136),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: ListTile(
                            title: Text(
                              event['name'] ?? 'Unnamed Event',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 5),
                                Text(event['description'] ?? 'No description'),
                                Text('Location: ${event['location'] ?? 'N/A'}'),
                                Text('Date: ${event['date'] ?? 'N/A'}'),
                                Text('Time: ${event['time'] ?? 'N/A'}'),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.blue),
                                  onPressed: () => _createOrUpdateEvent(
                                      existingEvent: event),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () => _deleteEvent(event['id']),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createOrUpdateEvent(),
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}
