import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GroupListScreen extends ConsumerStatefulWidget {
  const GroupListScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<GroupListScreen> createState() => _GroupListScreenState();
}

class _GroupListScreenState extends ConsumerState<GroupListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Travel Groups'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreateGroupDialog(),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: 3, // Replace with actual groups list
        itemBuilder: (context, index) {
          return _buildGroupCard(index);
        },
      ),
    );
  }

  Widget _buildGroupCard(int index) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.primaries[index % Colors.primaries.length],
          child: const Icon(Icons.group, color: Colors.white),
        ),
        title: Text('Group ${index + 1}'),
        subtitle: const Text('5 members • Next trip: Paris'),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'invite',
              child: Text('Invite Members'),
            ),
            const PopupMenuItem(
              value: 'chat',
              child: Text('Group Chat'),
            ),
            const PopupMenuItem(
              value: 'itinerary',
              child: Text('View Itinerary'),
            ),
            const PopupMenuItem(
              value: 'leave',
              child: Text('Leave Group'),
            ),
          ],
          onSelected: (value) => _handleMenuAction(value),
        ),
        onTap: () => _navigateToGroupDetails(index),
      ),
    );
  }

  void _showCreateGroupDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Group'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Group Name',
                hintText: 'Enter group name',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Enter group description',
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement group creation
              Navigator.pop(context);
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _handleMenuAction(String value) {
    switch (value) {
      case 'invite':
        // TODO: Implement invite functionality
        break;
      case 'chat':
        Navigator.pushNamed(context, '/group-chat');
        break;
      case 'itinerary':
        Navigator.pushNamed(context, '/group-itinerary');
        break;
      case 'leave':
        _showLeaveGroupDialog();
        break;
    }
  }

  void _showLeaveGroupDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Leave Group'),
        content: const Text('Are you sure you want to leave this group?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement leave group functionality
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Leave'),
          ),
        ],
      ),
    );
  }

  void _navigateToGroupDetails(int index) {
    Navigator.pushNamed(context, '/group-details');
  }
}
