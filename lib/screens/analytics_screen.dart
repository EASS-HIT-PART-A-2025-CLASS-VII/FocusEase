import 'package:flutter/material.dart';

class AnalyticsScreen extends StatelessWidget {
  final int totalTasks;
  final int completedTasks;
  final int totalMinutes;

  const AnalyticsScreen({
    super.key,
    required this.totalTasks,
    required this.completedTasks,
    required this.totalMinutes,
  });

  @override
  Widget build(BuildContext context) {
    final completionRate = totalTasks == 0
        ? 0
        : (completedTasks / totalTasks * 100).toStringAsFixed(1);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Focus Summary 📊'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              "📈 Your Productivity Stats",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            _buildStatItem('Total Tasks', totalTasks.toString()),
            const Divider(),
            _buildStatItem('Completed Tasks', completedTasks.toString()),
            const Divider(),
            _buildStatItem('Completion Rate', '$completionRate%'),
            const Divider(),
            _buildStatItem('Total Focus Time', '$totalMinutes min'),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back to Tasks'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
        ],
      ),
    );
  }
}
