import 'package:flutter/material.dart';

enum TicketStatus { open, inProgress, resolved }

class SupportTicket {
  final String id;
  final String title;
  final String description;
  TicketStatus status;
  final List<String> messages;

  SupportTicket({
    required this.id,
    required this.title,
    required this.description,
    this.status = TicketStatus.open,
    List<String>? messages,
  }) : messages = messages ?? [];
}

class TicketingSupportScreen extends StatefulWidget {
  @override
  _TicketingSupportScreenState createState() => _TicketingSupportScreenState();
}

class _TicketingSupportScreenState extends State<TicketingSupportScreen> {
  List<SupportTicket> tickets = [];

  final _formKey = GlobalKey<FormState>();
  String _ticketTitle = '';
  String _ticketDescription = '';

  void _createTicket() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newTicket = SupportTicket(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _ticketTitle,
        description: _ticketDescription,
      );
      setState(() {
        tickets.add(newTicket);
      });
      Navigator.pop(context);
    }
  }

  void _showCreateTicketDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Raise Support Ticket'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Title'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Enter title' : null,
                  onSaved: (value) => _ticketTitle = value!.trim(),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Description'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Enter description' : null,
                  onSaved: (value) => _ticketDescription = value!.trim(),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: _createTicket,
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  void _showTicketDetails(SupportTicket ticket) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TicketDetailScreen(
          ticket: ticket,
          onUpdate: () {
            setState(() {});
          },
        ),
      ),
    );
  }

  String _statusToString(TicketStatus status) {
    switch (status) {
      case TicketStatus.open:
        return 'Open';
      case TicketStatus.inProgress:
        return 'In Progress';
      case TicketStatus.resolved:
        return 'Resolved';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ticketing & Support'),
      ),
      body: tickets.isEmpty
          ? Center(child: Text('No support tickets raised.'))
          : ListView.builder(
              itemCount: tickets.length,
              itemBuilder: (context, index) {
                final ticket = tickets[index];
                return ListTile(
                  title: Text(ticket.title),
                  subtitle: Text('Status: ${_statusToString(ticket.status)}'),
                  onTap: () => _showTicketDetails(ticket),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateTicketDialog,
        child: Icon(Icons.add),
        tooltip: 'Raise Support Ticket',
      ),
    );
  }
}

class TicketDetailScreen extends StatefulWidget {
  final SupportTicket ticket;
  final VoidCallback onUpdate;

  const TicketDetailScreen({Key? key, required this.ticket, required this.onUpdate}) : super(key: key);

  @override
  _TicketDetailScreenState createState() => _TicketDetailScreenState();
}

class _TicketDetailScreenState extends State<TicketDetailScreen> {
  final _messageController = TextEditingController();

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      setState(() {
        widget.ticket.messages.add(message);
      });
      _messageController.clear();
      widget.onUpdate();
    }
  }

  void _changeStatus(TicketStatus? status) {
    if (status != null) {
      setState(() {
        widget.ticket.status = status;
      });
      widget.onUpdate();
    }
  }

  String _statusToString(TicketStatus status) {
    switch (status) {
      case TicketStatus.open:
        return 'Open';
      case TicketStatus.inProgress:
        return 'In Progress';
      case TicketStatus.resolved:
        return 'Resolved';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.ticket.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Description: ${widget.ticket.description}'),
            SizedBox(height: 10),
            DropdownButton<TicketStatus>(
              value: widget.ticket.status,
              onChanged: _changeStatus,
              items: TicketStatus.values.map((status) {
                return DropdownMenuItem<TicketStatus>(
                  value: status,
                  child: Text(_statusToString(status)),
                );
              }).toList(),
            ),
            Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: widget.ticket.messages.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(widget.ticket.messages[index]),
                  );
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      labelText: 'Send message',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
