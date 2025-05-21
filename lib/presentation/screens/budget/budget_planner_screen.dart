import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BudgetPlannerScreen extends ConsumerStatefulWidget {
  const BudgetPlannerScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<BudgetPlannerScreen> createState() => _BudgetPlannerScreenState();
}

class _BudgetPlannerScreenState extends ConsumerState<BudgetPlannerScreen> {
  final List<BudgetCategory> _categories = [
    BudgetCategory(
      name: 'Accommodation',
      amount: 500.0,
      spent: 350.0,
      color: Colors.blue,
      icon: Icons.hotel,
    ),
    BudgetCategory(
      name: 'Transportation',
      amount: 300.0,
      spent: 150.0,
      color: Colors.green,
      icon: Icons.directions_car,
    ),
    BudgetCategory(
      name: 'Food & Dining',
      amount: 400.0,
      spent: 280.0,
      color: Colors.orange,
      icon: Icons.restaurant,
    ),
    BudgetCategory(
      name: 'Activities',
      amount: 200.0,
      spent: 120.0,
      color: Colors.purple,
      icon: Icons.local_activity,
    ),
    BudgetCategory(
      name: 'Shopping',
      amount: 150.0,
      spent: 80.0,
      color: Colors.red,
      icon: Icons.shopping_bag,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final totalBudget = _categories.fold<double>(
      0,
      (sum, category) => sum + category.amount,
    );
    final totalSpent = _categories.fold<double>(
      0,
      (sum, category) => sum + category.spent,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget Planner'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddExpenseDialog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBudgetOverview(totalBudget, totalSpent),
            const SizedBox(height: 24),
            _buildPieChart(),
            const SizedBox(height: 24),
            const Text(
              'Budget Categories',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildCategoryList(),
            const SizedBox(height: 24),
            _buildRecentTransactions(),
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetOverview(double totalBudget, double totalSpent) {
    final remaining = totalBudget - totalSpent;
    final progress = totalSpent / totalBudget;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Budget',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '\$${totalBudget.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[200],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildBudgetStat(
                  'Spent',
                  '\$${totalSpent.toStringAsFixed(2)}',
                  Colors.orange,
                ),
                _buildBudgetStat(
                  'Remaining',
                  '\$${remaining.toStringAsFixed(2)}',
                  Colors.green,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetStat(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildPieChart() {
    return SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(
          sections: _categories.map((category) {
            return PieChartSectionData(
              value: category.spent,
              color: category.color,
              title: '',
              radius: 80,
            );
          }).toList(),
          sectionsSpace: 2,
          centerSpaceRadius: 40,
        ),
      ),
    );
  }

  Widget _buildCategoryList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _categories.length,
      itemBuilder: (context, index) {
        final category = _categories[index];
        final progress = category.spent / category.amount;

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: category.color,
              child: Icon(
                category.icon,
                color: Colors.white,
              ),
            ),
            title: Text(category.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey[200],
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${category.spent.toStringAsFixed(2)} / \$${category.amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: progress > 1 ? Colors.red : Colors.grey[600],
                  ),
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _showEditCategoryDialog(category),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRecentTransactions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Transactions',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 5,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: _categories[index].color,
                  child: Icon(
                    _categories[index].icon,
                    color: Colors.white,
                  ),
                ),
                title: Text('Transaction ${index + 1}'),
                subtitle: Text(_categories[index].name),
                trailing: Text(
                  '-\$${(index + 1) * 10.0}',
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  void _showAddExpenseDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Expense'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Category',
              ),
              items: _categories.map((category) {
                return DropdownMenuItem(
                  value: category.name,
                  child: Text(category.name),
                );
              }).toList(),
              onChanged: (String? value) {
                // TODO: Handle category selection
              },
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Amount',
                prefixText: '\$',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Description',
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
              // TODO: Handle expense addition
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditCategoryDialog(BudgetCategory category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit ${category.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Budget Amount',
                prefixText: '\$',
              ),
              keyboardType: TextInputType.number,
              controller: TextEditingController(
                text: category.amount.toString(),
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
              // TODO: Handle category update
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

class BudgetCategory {
  final String name;
  final double amount;
  final double spent;
  final Color color;
  final IconData icon;

  BudgetCategory({
    required this.name,
    required this.amount,
    required this.spent,
    required this.color,
    required this.icon,
  });
}
