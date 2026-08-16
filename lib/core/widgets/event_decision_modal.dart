import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../models/game_event.dart';
import '../../models/event_choice.dart';
import '../utils/number_formatter.dart';
import 'scam_card.dart';
import 'scam_button.dart';

/// Interactive modal for resolving narrative random events.
class EventDecisionModal extends StatelessWidget {
  final GameEvent event;
  final double currentCoins;
  final ValueChanged<EventChoice> onSelectChoice;

  const EventDecisionModal({
    super.key,
    required this.event,
    required this.currentCoins,
    required this.onSelectChoice,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 24.0,
      ),
      child: ScamCard(
        padding: const EdgeInsets.all(20.0),
        backgroundColor: AppColors.surface,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Event Illustration
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.md),
                child: Image.asset(
                  event.illustrationPath,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 140,
                    color: AppColors.surfaceMuted,
                    child: const Icon(Icons.emergency_outlined, size: 48),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title & Description
              Text(
                event.title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                event.description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),

              // Choices List
              ...event.choices.map((choice) {
                final canAfford = currentCoins >= choice.sCoinsCost;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceMuted,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                choice.label,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                            ),
                            if (choice.sCoinsCost > 0)
                              Text(
                                'Cost: ${NumberFormatter.formatCurrency(choice.sCoinsCost)}',
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(
                                      color: canAfford
                                          ? AppColors.heatDark
                                          : AppColors.textMuted,
                                      fontWeight: FontWeight.w800,
                                    ),
                              ),
                          ],
                        ),
                        if (choice.description.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            choice.description,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                ),
                          ),
                        ],
                        const SizedBox(height: 8),
                        ScamButton(
                          label: 'EXECUTE DECISION',
                          onPressed: canAfford
                              ? () => onSelectChoice(choice)
                              : null,
                          variant: canAfford
                              ? ScamButtonVariant.primary
                              : ScamButtonVariant.secondary,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
