import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpful_components/helpful_components.dart';
import 'package:othello/components/empty_placeholder.dart';
import 'package:othello/screens/logs/data/log_providers.dart';
import 'package:othello/utils/background_service/backup_log.dart';

/// Shows the persisted diagnostic logs emitted by the background backup job.
class LogsScreen extends ConsumerWidget {
  static const kPath = '/logs';

  const LogsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Already sorted newest-first by the provider's SortConfig.
    final logs = ref.watch(backupLogsProvider).values.toList();

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black87,
        appBar: AppBar(
          title: Text('Background Logs', style: GoogleFonts.montserrat()),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              tooltip: 'Copy',
              icon: const Icon(Icons.copy),
              onPressed: logs.isEmpty ? null : () => _copy(context, logs),
            ),
            IconButton(
              tooltip: 'Clear all',
              icon: const Icon(Icons.delete_outline),
              onPressed: logs.isEmpty ? null : () => _confirmClear(context, ref),
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () => ref.read(backupLogsProvider.notifier).reload(),
          child: logs.isEmpty
              ? const EmptyPlaceholder(
                  icon: Icons.receipt_long,
                  message: 'No background logs yet',
                )
              : ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: logs.length,
                  separatorBuilder: (_, __) =>
                      const Divider(color: Colors.white12, height: 1),
                  itemBuilder: (_, i) => _LogTile(entry: logs[i]),
                ),
        ),
      ),
    );
  }

  Future<void> _copy(BuildContext context, List<LogEntry> logs) async {
    final text = logs.map((e) => e.toFormattedString()).join('\n');
    await Clipboard.setData(ClipboardData(text: text));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logs copied to clipboard')),
      );
    }
  }

  Future<void> _confirmClear(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => BooleanDialog(
        'Clear all stored background logs? This cannot be undone.',
      ),
    );
    if (confirmed == true) {
      await ref.read(backupLogsProvider.notifier).clear();
    }
  }
}

class _LogTile extends StatelessWidget {
  const _LogTile({required this.entry});

  final LogEntry entry;

  @override
  Widget build(BuildContext context) {
    final (icon, color) = switch (entry.level) {
      'error' => (Icons.error_outline, Colors.redAccent),
      'warn' => (Icons.warning_amber_outlined, Colors.orangeAccent),
      _ => (Icons.info_outline, Colors.blueAccent),
    };
    final subtitle = StringBuffer(entry.formattedDate);
    if (entry.formattedRunId.isNotEmpty) {
      subtitle.write('  ·  ${entry.formattedRunId}');
    }
    if (entry.task != null) subtitle.write('  ·  ${entry.task}');

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        entry.message,
        style: GoogleFonts.robotoMono(color: Colors.white, fontSize: 13),
      ),
      subtitle: Text(
        subtitle.toString(),
        style: GoogleFonts.montserrat(color: Colors.white54, fontSize: 11),
      ),
    );
  }
}
