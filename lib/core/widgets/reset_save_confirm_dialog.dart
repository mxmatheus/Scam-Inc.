import 'package:flutter/material.dart';
import '../../app/theme.dart';
import 'scam_card.dart';
import 'scam_button.dart';

/// Safety modal to prevent accidental deletion of save data.
class ResetSaveConfirmDialog extends StatelessWidget {
  final VoidCallback onConfirmReset;

  const ResetSaveConfirmDialog({super.key, required this.onConfirmReset});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 24.0,
      ),
      child: ScamCard(
        borderColor: AppColors.heatDanger,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: AppColors.heatDanger,
              size: 48,
            ),
            const SizedBox(height: 12),
            Text(
              'SHRED ALL EVIDENCE?',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
                color: AppColors.heatDanger,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'This will completely eradicate your local save file, company schemes, Prestige perks, and revenue history. This action CANNOT be undone.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            ScamButton(
              label: 'CONFIRM: WIPE EVERYTHING',
              onPressed: () {
                onConfirmReset();
                Navigator.of(context).pop();
              },
              variant: ScamButtonVariant.danger,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'CANCEL & KEEP EVIDENCE',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
