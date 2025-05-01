import 'package:flutter/material.dart';

class Event {
  final String title;
  final String description;
  final String speaker;
  final DateTime time;
  final String venue;
  final String track;

  Event({
    required this.title,
    required this.description,
    required this.speaker,
    required this.time,
    required this.venue,
    required this.track,
  });
}

class EventScheduleScreen extends StatefulWidget {
  @override
  _EventScheduleScreenState createState() => _EventScheduleScreenState();
}

class _EventScheduleScreenState extends State<EventScheduleScreen> {
  List<Event> allEvents = [
    Event(
      title: 'Opening Keynote',
      description: 'Welcome and opening remarks.',
      speaker: 'John Doe',
      time: DateTime(2024, 7, 1, 9, 0),
      venue: 'Main Hall',
      track: 'General',
    ),
    Event(
      title: 'Flutter for Beginners',
      description: 'Introduction to Flutter development.',
      speaker: 'Jane Smith',
      time: DateTime(2024, 7, 1, 10, 30),
      venue: 'Room 101',
      track: 'Development',
    ),
    Event(
      title: 'Advanced Dart Tips',
      description: 'Deep dive into Dart language features.',
      speaker: 'Alice Johnson',
      time: DateTime(2024, 7, 2, 14, 0),
      venue: 'Room 102',
      track: 'Development',
    ),
    // Add more events as needed
  ];

  String? selectedTrack;
  DateTime? selectedDate;
  String? selectedSpeaker;

  List<String> get tracks =>
      allEvents.map((e) => e.track).toSet().toList()..sort();

  List<String> get speakers =>
      allEvents.map((e) => e.speaker).toSet().toList()..sort();

  List<Event> get filteredEvents {
    return allEvents.where((event) {
      final matchesTrack =
          selectedTrack == null || event.track == selectedTrack;
      final matchesSpeaker =
          selectedSpeaker == null || event.speaker == selectedSpeaker;
      final matchesDate = selectedDate == null ||
          (event.time.year == selectedDate!.year &&
              event.time.month == selectedDate!.month &&
              event.time.day == selectedDate!.day);
      return matchesTrack && matchesSpeaker && matchesDate;
    }).toList();
  }

  void _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2025),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _clearFilters() {
    setState(() {
      selectedTrack = null;
      selectedSpeaker = null;
      selectedDate = null;
    });
  }

  void _showEventDetails(Event event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventDetailScreen(event: event),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Schedule'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_alt_off),
            tooltip: 'Clear Filters',
            onPressed: _clearFilters,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                DropdownButton<String>(
                  hint: Text('Select Track'),
                  value: selectedTrack,
                  items: [null, ...tracks].map((track) {
                    return DropdownMenuItem<String>(
                      value: track,
                      child: Text(track ?? 'All Tracks'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedTrack = value;
                    });
                  },
                ),
                DropdownButton<String>(
                  hint: Text('Select Speaker'),
                  value: selectedSpeaker,
                  items: [null, ...speakers].map((speaker) {
                    return DropdownMenuItem<String>(
                      value: speaker,
                      child: Text(speaker ?? 'All Speakers'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedSpeaker = value;
                    });
                  },
                ),
                ElevatedButton(
                  onPressed: _selectDate,
                  child: Text(selectedDate == null
                      ? 'Select Date'
                      : '${selectedDate!.toLocal()}'.split(' ')[0]),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredEvents.length,
              itemBuilder: (context, index) {
                final event = filteredEvents[index];
                return ListTile(
                  title: Text(event.title),
                  subtitle: Text(
                      '${event.speaker} - ${event.time.hour.toString().padLeft(2, '0')}:${event.time.minute.toString().padLeft(2, '0')}'),
                  onTap: () => _showEventDetails(event),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class EventDetailScreen extends StatelessWidget {
  final Event event;

  const EventDetailScreen({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timeString =
        '${event.time.year}-${event.time.month.toString().padLeft(2, '0')}-${event.time.day.toString().padLeft(2, '0')} ${event.time.hour.toString().padLeft(2, '0')}:${event.time.minute.toString().padLeft(2, '0')}';

    return Scaffold(
      appBar: AppBar(
        title: Text(event.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Title: ${event.title}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('Description: ${event.description}'),
            SizedBox(height: 10),
            Text('Speaker: ${event.speaker}'),
            SizedBox(height: 10),
            Text('Time: $timeString'),
            SizedBox(height: 10),
            Text('Venue: ${event.venue}'),
            SizedBox(height: 10),
            Text('Track: ${event.track}'),
          ],
        ),
      ),
    );
  }
}
