import 'dart:math';

import 'package:flutter/material.dart';
import 'package:storage_info/storage_info.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Storage Info Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const StorageInfoPage(),
    );
  }
}

class StorageInfoPage extends StatefulWidget {
  const StorageInfoPage({super.key});

  @override
  State<StorageInfoPage> createState() => _StorageInfoPageState();
}

class _StorageInfoPageState extends State<StorageInfoPage> {
  final StorageInfo _storageInfo = const StorageInfo();
  StorageInfoData? _storageData;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadStorageInfo();
  }

  Future<void> _loadStorageInfo() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final storageData = await _storageInfo.getStorageInfo();
      setState(() {
        _storageData = storageData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Storage Info Example'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                ? StorageErrorWidget(
                  errorMessage: _errorMessage!,
                  onRetry: _loadStorageInfo,
                )
                : _storageData != null
                ? RefreshIndicator(
                  onRefresh: _loadStorageInfo,
                  child: ListView(
                    children: [
                      const Text(
                        'Device Storage Information',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      StorageIndicator(
                        usedPercentage: _storageData!.usedPercentage,
                      ),
                      const SizedBox(height: 32),
                      StorageDetailsCard(storageData: _storageData!),
                    ],
                  ),
                )
                : const Center(child: Text('No storage data available')),
      ),
    );
  }
}

class StorageErrorWidget extends StatelessWidget {
  const StorageErrorWidget({
    super.key,
    required this.errorMessage,
    required this.onRetry,
  });

  final String errorMessage;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Error: $errorMessage',
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}

class StorageIndicator extends StatelessWidget {
  const StorageIndicator({super.key, required this.usedPercentage});

  final double usedPercentage;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: usedPercentage,
            backgroundColor: Colors.grey.shade200,
            minHeight: 20,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${(usedPercentage * 100).toStringAsFixed(1)}% used',
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}

class StorageDetailsCard extends StatelessWidget {
  const StorageDetailsCard({super.key, required this.storageData});

  final StorageInfoData storageData;

  String _formatBytes(int bytes) {
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    if (bytes == 0) return '0 B';

    final i = (log(bytes) / log(1024)).floor();
    final size = bytes / pow(1024, i);

    return '${size.toStringAsFixed(2)} ${suffixes[i]}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StorageDetailRow(
              title: 'Total Storage:',
              value: _formatBytes(storageData.totalBytes),
            ),
            const Divider(),
            StorageDetailRow(
              title: 'Used Storage:',
              value: _formatBytes(storageData.usedBytes),
            ),
            const Divider(),
            StorageDetailRow(
              title: 'Free Storage:',
              value: _formatBytes(storageData.freeBytes),
            ),
          ],
        ),
      ),
    );
  }
}

class StorageDetailRow extends StatelessWidget {
  const StorageDetailRow({super.key, required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
