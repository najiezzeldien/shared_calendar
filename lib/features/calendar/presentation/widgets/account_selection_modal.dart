import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_calendar/features/calendar/presentation/providers/calendar_account_controller.dart';

class AccountSelectionModal extends ConsumerWidget {
  const AccountSelectionModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch logic can be added here if we want to show global loading overlay
    // or we can just pass ref to the options.

    // Listen for errors
    ref.listen<AsyncValue<void>>(calendarAccountControllerProvider, (
      previous,
      next,
    ) {
      if (next.hasError) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${next.error}')));
      } else if (next.hasValue &&
          !next.isLoading &&
          previous?.isLoading == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account connected successfully!')),
        );
        context.pop();
      }
    });

    final state = ref.watch(calendarAccountControllerProvider);
    final isLoading = state.isLoading;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with Close Button
            Stack(
              children: [
                const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Select your calendar account type',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: InkWell(
                    onTap: () => context.pop(),
                    borderRadius: BorderRadius.circular(20),
                    child: const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Icon(Icons.close, color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            if (isLoading)
              const Padding(
                padding: EdgeInsets.only(bottom: 20.0),
                child: CircularProgressIndicator(),
              )
            else ...[
              // Account Options
              _buildAccountOption(
                context,
                ref,
                icon: Icons.apple,
                label: 'iCloud',
                color: Colors.black,
                accountType: 'iCloud',
              ),
              const SizedBox(height: 16),
              _buildAccountOption(
                context,
                ref,
                // No exact Google logo in Material Icons, simplifying with a G style or general cloud
                icon: Icons.language,
                label: 'Google',
                color: const Color(0xFF4285F4), // Google Blue
                isGoogle: true,
                accountType: 'Google',
              ),
              const SizedBox(height: 16),
              _buildAccountOption(
                context,
                ref,
                icon: Icons.mail_outline,
                label: 'Outlook.com',
                color: const Color(0xFF0078D4), // Outlook Blue
                accountType: 'Outlook',
              ),
              const SizedBox(height: 16),
              _buildAccountOption(
                context,
                ref,
                icon: Icons.sync_alt,
                label: 'Exchange',
                color: const Color(0xFF0078D4),
                accountType: 'Exchange',
              ),
            ],
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountOption(
    BuildContext context,
    WidgetRef ref, {
    required IconData icon,
    required String label,
    required Color color,
    required String accountType,
    bool isGoogle = false,
  }) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28), // Pill shape
        border: Border.all(color: Colors.grey.shade200, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: () {
            ref
                .read(calendarAccountControllerProvider.notifier)
                .connectAccount(accountType);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isGoogle)
                // Custom multi-color G placeholder if strictly needed,
                // but for now keeping it simple with Icon to avoid complex custom painting code.
                Icon(icon, color: color, size: 28)
              else
                Icon(icon, color: color, size: 28),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
