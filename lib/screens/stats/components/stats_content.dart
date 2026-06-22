import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:othello/screens/stats/data/usage_log_providers.dart';
import 'package:othello/screens/stats/data/usage_log_repository.dart';

/// Actual Android-only stats content.
///
/// This widget is only ever built on Android (see [StatsScreen]), so it is the
/// safe place to import and use Android-only plugins.
class StatsContent extends ConsumerWidget {
  const StatsContent({super.key});

  Future<void> _openAccessibilitySettings() async {
    const intent = AndroidIntent(
      action: 'android.settings.ACCESSIBILITY_SETTINGS',
    );
    await intent.launch();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncSnapshot = ref.watch(usageLogsProvider);

    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(usageLogsProvider),
      child: asyncSnapshot.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _MessageList(
          message: 'Could not read usage logs:\n$error',
        ),
        data: (snapshot) => _StatsView(
          snapshot: snapshot,
          onRefresh: () => ref.invalidate(usageLogsProvider),
          onOpenSettings: _openAccessibilitySettings,
        ),
      ),
    );
  }
}

class _StatsView extends StatelessWidget {
  const _StatsView({
    required this.snapshot,
    required this.onRefresh,
    required this.onOpenSettings,
  });

  final UsageSnapshot snapshot;
  final VoidCallback onRefresh;
  final Future<void> Function() onOpenSettings;

  @override
  Widget build(BuildContext context) {
    final events = snapshot.events;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _StatusBanner(enabled: snapshot.serviceEnabled),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onOpenSettings,
                  icon: const Icon(Icons.settings_accessibility),
                  label: const Text('Accessibility settings'),
                ),
              ),
              const SizedBox(width: 12),
              FilledButton.icon(
                onPressed: onRefresh,
                icon: const Icon(Icons.refresh),
                label: const Text('Refresh'),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '${events.length} events',
              style: const TextStyle(color: Colors.white54, fontSize: 12),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: events.isEmpty
              ? _MessageList(
                  message: snapshot.serviceEnabled
                      ? 'No events recorded yet. Switch between a few apps, then pull to refresh.'
                      : 'Enable the accessibility service, then switch between apps and refresh.',
                )
              : ListView.separated(
                  itemCount: events.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1, color: Colors.white12),
                  itemBuilder: (context, index) =>
                      _EventTile(event: events[index]),
                ),
        ),
      ],
    );
  }
}

class _StatusBanner extends StatelessWidget {
  const _StatusBanner({required this.enabled});

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final color = enabled ? Colors.green : Colors.orange;
    return Container(
      width: double.infinity,
      color: color.withValues(alpha: 0.15),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(enabled ? Icons.check_circle : Icons.warning_amber_rounded,
              color: color, size: 20),
          const SizedBox(width: 8),
          Text(
            enabled
                ? 'Accessibility service: ON'
                : 'Accessibility service: OFF',
            style: TextStyle(color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _EventTile extends StatelessWidget {
  const _EventTile({required this.event});

  final UsageEvent event;

  @override
  Widget build(BuildContext context) {
    final time = DateFormat('MMM d, HH:mm:ss').format(event.timestamp);
    return ListTile(
      dense: true,
      leading: Icon(_iconFor(event.type), color: Colors.white70, size: 20),
      title: Text(
        _labelFor(event),
        style: const TextStyle(color: Colors.white),
      ),
      subtitle: Text(time, style: const TextStyle(color: Colors.white54)),
    );
  }

  String _labelFor(UsageEvent event) {
    switch (event.type) {
      case 'foreground':
        return event.package ?? 'Unknown app';
      case 'screen_on':
        return 'Screen on';
      case 'screen_off':
        return 'Screen off';
      case 'user_present':
        return 'Unlocked';
      case 'shutdown':
        return 'Shutdown';
      default:
        return event.type;
    }
  }

  IconData _iconFor(String type) {
    switch (type) {
      case 'foreground':
        return Icons.apps;
      case 'screen_on':
        return Icons.light_mode;
      case 'screen_off':
        return Icons.dark_mode;
      case 'user_present':
        return Icons.lock_open;
      case 'shutdown':
        return Icons.power_settings_new;
      default:
        return Icons.circle;
    }
  }
}

class _MessageList extends StatelessWidget {
  const _MessageList({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    // Wrap in a scrollable so RefreshIndicator works even when empty.
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(32, 64, 32, 32),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white54),
          ),
        ),
      ],
    );
  }
}
