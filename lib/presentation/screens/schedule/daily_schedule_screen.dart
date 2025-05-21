import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeline_tile/timeline_tile.dart';

class DailyScheduleScreen extends ConsumerStatefulWidget {
  const DailyScheduleScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<DailyScheduleScreen> createState() => _DailyScheduleScreenState();
}

class _DailyScheduleScreenState extends ConsumerState<DailyScheduleScreen> {
  final List<ScheduleActivity> _activities = [
    ScheduleActivity(
      time: '09:00',
      title: 'Visit Eiffel Tower',
      description: 'Iconic tower with observation deck',
      duration: '2 hours',
      type: ActivityType.attraction,
    ),
    ScheduleActivity(
      time: '11:30',
      title: 'Lunch at Le Cheval d\'Or',
      description: 'Traditional French cuisine',
      duration: '1.5 hours',
      type: ActivityType.dining,
    ),
    ScheduleActivity(
      time: '13:30',
      title: 'Louvre Museum',
      description: 'World\'s largest art museum',
      duration: '3 hours',
      type: ActivityType.attraction,
    ),
    ScheduleActivity(
      time: '17:00',
      title: 'Seine River Cruise',
      description: 'Scenic boat tour along the Seine',
      duration: '1 hour',
      type: ActivityType.activity,
    ),
    ScheduleActivity(
      time: '19:00',
      title: 'Dinner at L\'Arpège',
      description: 'Michelin-starred restaurant',
      duration: '2 hours',
      type: ActivityType.dining,
    ),
  ];

  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Schedule'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: _selectDate,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddActivityDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildDateHeader(),
          Expanded(
            child: _buildScheduleTimeline(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _generateSchedule,
        icon: const Icon(Icons.auto_awesome),
        label: const Text('Generate Schedule'),
      ),
    );
  }

  Widget _buildDateHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).primaryColor.withOpacity(0.1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              setState(() {
                _selectedDate = _selectedDate.subtract(const Duration(days: 1));
              });
            },
          ),
          Text(
            '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () {
              setState(() {
                _selectedDate = _selectedDate.add(const Duration(days: 1));
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleTimeline() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _activities.length,
      itemBuilder: (context, index) {
        final activity = _activities[index];
        final isFirst = index == 0;
        final isLast = index == _activities.length - 1;

        return TimelineTile(
          alignment: TimelineAlign.manual,
          lineXY: 0.2,
          isFirst: isFirst,
          isLast: isLast,
          indicatorStyle: IndicatorStyle(
            width: 40,
            height: 40,
            indicator: _buildActivityIndicator(activity.type),
          ),
          beforeLineStyle: LineStyle(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
          ),
          endChild: _buildActivityCard(activity),
          startChild: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              activity.time,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildActivityIndicator(ActivityType type) {
    IconData icon;
    Color color;

    switch (type) {
      case ActivityType.attraction:
        icon = Icons.location_on;
        color = Colors.blue;
        break;
      case ActivityType.dining:
        icon = Icons.restaurant;
        color = Colors.orange;
        break;
      case ActivityType.activity:
        icon = Icons.local_activity;
        color = Colors.green;
        break;
    }

    return Container(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 20,
      ),
    );
  }

  Widget _buildActivityCard(ScheduleActivity activity) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              activity.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              activity.description,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.access_time,
                  size: 16,
                  color: Colors.grey,
                ),
                const SizedBox(width: 4),
                Text(
                  activity.duration,
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _showAddActivityDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Activity'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Activity Title',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Description',
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Time',
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Duration',
                    ),
                  ),
                ),
              ],
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
              // TODO: Handle activity addition
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _generateSchedule() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Generate Schedule'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Generate a personalized schedule based on:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              title: const Text('Popular Attractions'),
              value: true,
              onChanged: (value) {},
            ),
            CheckboxListTile(
              title: const Text('Local Cuisine'),
              value: true,
              onChanged: (value) {},
            ),
            CheckboxListTile(
              title: const Text('Cultural Activities'),
              value: true,
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Start Time',
                hintText: '09:00',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'End Time',
                hintText: '21:00',
              ),
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
              // TODO: Handle schedule generation
              Navigator.pop(context);
            },
            child: const Text('Generate'),
          ),
        ],
      ),
    );
  }
}

enum ActivityType {
  attraction,
  dining,
  activity,
}

class ScheduleActivity {
  final String time;
  final String title;
  final String description;
  final String duration;
  final ActivityType type;

  ScheduleActivity({
    required this.time,
    required this.title,
    required this.description,
    required this.duration,
    required this.type,
  });
}
