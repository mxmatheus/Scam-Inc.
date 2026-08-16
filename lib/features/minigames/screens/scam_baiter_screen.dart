import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme.dart';
import '../../../core/utils/number_formatter.dart';
import '../../../core/widgets/scam_button.dart';
import '../../../core/widgets/scam_card.dart';
import '../../../services/providers/service_providers.dart';
import '../models/scam_baiter_scenario.dart';
import '../services/scam_baiter_service.dart';

class ScamBaiterScreen extends ConsumerStatefulWidget {
  final ScamBaiterScenario? scenario;

  const ScamBaiterScreen({super.key, this.scenario});

  @override
  ConsumerState<ScamBaiterScreen> createState() => _ScamBaiterScreenState();
}

class _ScamBaiterScreenState extends ConsumerState<ScamBaiterScreen> {
  late final ScamBaiterScenario _scenario;
  Timer? _timer;
  int _secondsLeft = 10;
  bool _isAnswered = false;
  bool _isSuccess = false;

  @override
  void initState() {
    super.initState();
    _scenario = widget.scenario ?? ScamBaiterService().getRandomScenario();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft > 1) {
        setState(() {
          _secondsLeft--;
        });
      } else {
        _timer?.cancel();
        if (!_isAnswered) {
          _handleTimeout();
        }
      }
    });
  }

  void _handleTimeout() {
    _handleDecision(disconnect: false);
  }

  void _handleDecision({required bool disconnect}) {
    if (_isAnswered) return;
    _timer?.cancel();

    // Success if player disconnected from malicious profile OR accepted legitimate inquiry
    final success =
        (disconnect && _scenario.isMalicious) ||
        (!disconnect && !_scenario.isMalicious);

    setState(() {
      _isAnswered = true;
      _isSuccess = success;
    });

    if (success) {
      ref
          .read(gameControllerProvider.notifier)
          .applyMinigameReward(
            coins: _scenario.sCoinsReward,
            trust: _scenario.trustReward,
            heatDelta: _scenario.heatDelta,
          );
    } else {
      ref
          .read(gameControllerProvider.notifier)
          .applyMinigameReward(coins: 0, trust: -5, heatDelta: 15);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardTheme.color,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Scam Baiter Drill',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _secondsLeft <= 4
                  ? AppColors.heatBg
                  : AppColors.surfaceMuted,
              borderRadius: BorderRadius.circular(AppRadius.pill),
              border: Border.all(
                color: _secondsLeft <= 4
                    ? AppColors.heatDanger
                    : AppColors.border,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.timer_outlined,
                  size: 16,
                  color: _secondsLeft <= 4
                      ? AppColors.heatDanger
                      : AppColors.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  '${_secondsLeft}s',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: _secondsLeft <= 4
                        ? AppColors.heatDanger
                        : AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Educational Header
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.trustBg,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: AppColors.trust),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.security,
                      color: AppColors.trustDark,
                      size: 22,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'PROFILE RADAR: Inspect the contact bio and direct message. Disconnect if malicious!',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.trustDark,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Suspicious Social Profile Card
              ScamCard(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: AppColors.surfaceMuted,
                      backgroundImage: AssetImage(_scenario.avatarAsset),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _scenario.profileName,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      _scenario.handle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkSurfaceMuted
                            : AppColors.surfaceMuted,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      child: Text(
                        _scenario.bio,
                        textAlign: TextAlign.center,
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Direct Message Bubble
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.border,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'INCOMING DIRECT MESSAGE:',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        letterSpacing: 1.0,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _scenario.directMessage,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(height: 1.4),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Educational Debrief Result (Shown after decision)
              if (_isAnswered) ...[
                ScamCard(
                  backgroundColor: _isSuccess
                      ? (isDark ? AppColors.darkSCoinsBg : AppColors.sCoinsBg)
                      : (isDark ? AppColors.darkHeatBg : AppColors.heatBg),
                  borderColor: _isSuccess
                      ? AppColors.sCoins
                      : AppColors.heatDanger,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isSuccess
                            ? '✅ EXCELLENT INSTINCTS! Correct Decision.'
                            : '❌ COMPROMISED! Inappropriate Reaction.',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: _isSuccess
                                  ? AppColors.sCoins
                                  : AppColors.heatDanger,
                            ),
                      ),
                      const Divider(height: 16),
                      Text(
                        _scenario.redFlagExplanation,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(height: 1.4),
                      ),
                      if (_isSuccess) ...[
                        const SizedBox(height: 10),
                        Text(
                          'Reward: +${NumberFormatter.formatCurrency(_scenario.sCoinsReward)} • +${_scenario.trustReward.toInt()} Trust • ${_scenario.heatDelta.toInt()}% Heat',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: AppColors.sCoins,
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ScamButton(
                  label: 'RETURN TO HEADQUARTERS',
                  onPressed: () => Navigator.of(context).pop(),
                  variant: ScamButtonVariant.primary,
                  isFullWidth: true,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ] else ...[
                // Reaction Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ScamButton(
                        label: 'DISCONNECT / REPORT',
                        onPressed: () => _handleDecision(disconnect: true),
                        variant: ScamButtonVariant.danger,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ScamButton(
                        label: 'ENGAGE / ACCEPT',
                        onPressed: () => _handleDecision(disconnect: false),
                        variant: ScamButtonVariant.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
