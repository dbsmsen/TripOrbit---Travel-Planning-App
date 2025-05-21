import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GroupChatScreen extends ConsumerStatefulWidget {
  const GroupChatScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends ConsumerState<GroupChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [
    ChatMessage(
      sender: 'John',
      message: 'Hey everyone! Are we ready for the Paris trip?',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      isCurrentUser: false,
    ),
    ChatMessage(
      sender: 'Alice',
      message: 'Yes! I\'ve booked my flights already.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
      isCurrentUser: false,
    ),
    ChatMessage(
      sender: 'You',
      message: 'Great! I\'ll share the hotel options soon.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
      isCurrentUser: true,
    ),
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Paris Trip Group'),
            Text(
              '5 members',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white70,
                  ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // TODO: Show group settings
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[_messages.length - 1 - index];
                return _buildMessageBubble(message);
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment:
            message.isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isCurrentUser) ...[
            CircleAvatar(
              backgroundColor: Colors.grey[300],
              child: Text(
                message.sender[0].toUpperCase(),
                style: const TextStyle(color: Colors.black87),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: message.isCurrentUser
                    ? Theme.of(context).primaryColor
                    : Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: message.isCurrentUser
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  if (!message.isCurrentUser)
                    Text(
                      message.sender,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  Text(
                    message.message,
                    style: TextStyle(
                      color: message.isCurrentUser ? Colors.white : Colors.black87,
                    ),
                  ),
                  Text(
                    _formatTimestamp(message.timestamp),
                    style: TextStyle(
                      fontSize: 10,
                      color: message.isCurrentUser
                          ? Colors.white70
                          : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (message.isCurrentUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: const Text(
                'Y',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.attach_file),
            onPressed: () {
              // TODO: Implement file attachment
            },
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: 'Type a message...',
                border: InputBorder.none,
              ),
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            color: Theme.of(context).primaryColor,
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.insert(
        0,
        ChatMessage(
          sender: 'You',
          message: _messageController.text.trim(),
          timestamp: DateTime.now(),
          isCurrentUser: true,
        ),
      );
    });

    _messageController.clear();
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    if (timestamp.day == now.day &&
        timestamp.month == now.month &&
        timestamp.year == now.year) {
      return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    }
    return '${timestamp.day}/${timestamp.month} ${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  }
}

class ChatMessage {
  final String sender;
  final String message;
  final DateTime timestamp;
  final bool isCurrentUser;

  ChatMessage({
    required this.sender,
    required this.message,
    required this.timestamp,
    required this.isCurrentUser,
  });
}
