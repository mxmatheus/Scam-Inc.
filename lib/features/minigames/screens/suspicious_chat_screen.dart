import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme.dart';
import '../../../core/utils/number_formatter.dart';
import '../../../core/widgets/scam_button.dart';
import '../../../core/widgets/scam_card.dart';
import '../../../core/widgets/scam_icon.dart';
import '../../../services/providers/service_providers.dart';
import '../models/chat_scenario.dart';
import '../services/chat_minigame_service.dart';

class SuspiciousChatScreen extends ConsumerStatefulWidget {
  final ChatScenario? scenario;

  const SuspiciousChatScreen({super.key, this.scenario});

  @override
  ConsumerState<SuspiciousChatScreen> createState() =>
      _SuspiciousChatScreenState();
}

class _SuspiciousChatScreenState extends ConsumerState<SuspiciousChatScreen> {
  late final ChatScenario _scenario;
  Timer? _timer;
  int _secondsLeft = 20;
  ChatChoice? _selectedChoice;
  bool _isAnswered = false;

  @override
  void initState() {
    super.initState();
    _scenario = widget.scenario ?? ChatMinigameService().getRandomScenario();
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
    setState(() {
      _isAnswered = true;
      _selectedChoice = _scenario.choices.firstWhere(
        (c) => !c.isAntiScamWinner,
        orElse: () => _scenario.choices.first,
      );
    });
  }

  void _handleChoice(ChatChoice choice) {
    if (_isAnswered) return;
    _timer?.cancel();
    setState(() {
      _isAnswered = true;
      _selectedChoice = choice;
    });

    // Apply rewards or penalties via controller
    ref
        .read(gameControllerProvider.notifier)
        .applyMinigameReward(
          coins: choice.rewardCoins,
          trust: choice.trustReward,
          heatDelta: choice.heatDelta,
        );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.surfaceMuted,
              backgroundImage: AssetImage(_scenario.avatarAsset),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _scenario.contactName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    _scenario.contactRole,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _secondsLeft <= 5
                  ? AppColors.heatBg
                  : AppColors.surfaceMuted,
              borderRadius: BorderRadius.circular(AppRadius.pill),
              border: Border.all(
                color: _secondsLeft <= 5
                    ? AppColors.heatDanger
                    : AppColors.border,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.timer_outlined,
                  size: 16,
                  color: _secondsLeft <= 5
                      ? AppColors.heatDanger
                      : AppColors.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  '${_secondsLeft}s',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: _secondsLeft <= 5
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
        child: Column(
          children: [
            // Chat Message Scroll View
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  // Educational Banner
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.trustBg,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(color: AppColors.trust),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.school_outlined,
                          color: AppColors.trustDark,
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'ANTI-SCAM TRAINING: Identify suspicious requests & choose the safe response.',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: AppColors.trustDark,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Incoming Chat Bubble
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: AppColors.surfaceMuted,
                        backgroundImage: AssetImage(_scenario.avatarAsset),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.all(14.0),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(AppRadius.lg),
                              bottomLeft: Radius.circular(AppRadius.lg),
                              bottomRight: Radius.circular(AppRadius.lg),
                            ),
                            border: Border.all(color: AppColors.border),
                            boxShadow: AppShadows.card,
                          ),
                          child: Text(
                            _scenario.incomingMessage,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: AppColors.textPrimary,
                                  height: 1.4,
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Outgoing Player Response Bubble (if answered)
                  if (_isAnswered && _selectedChoice != null) ...[
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.all(14.0),
                            decoration: BoxDecoration(
                              color: _selectedChoice!.isAntiScamWinner
                                  ? AppColors.sCoinsBg
                                  : AppColors.heatBg,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(AppRadius.lg),
                                bottomLeft: Radius.circular(AppRadius.lg),
                                bottomRight: Radius.circular(AppRadius.lg),
                              ),
                              border: Border.all(
                                color: _selectedChoice!.isAntiScamWinner
                                    ? AppColors.sCoins
                                    : AppColors.heatDanger,
                              ),
                            ),
                            child: Text(
                              _selectedChoice!.text,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: _selectedChoice!.isAntiScamWinner
                                        ? AppColors.sCoinsDark
                                        : AppColors.heatDark,
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],

                  // Red Flag Educational Debrief Card
                  if (_isAnswered && _selectedChoice != null) ...[
                    const SizedBox(height: 20),
                    ScamCard(
                      backgroundColor: _selectedChoice!.isAntiScamWinner
                          ? AppColors.sCoinsBg
                          : AppColors.heatBg,
                      borderColor: _selectedChoice!.isAntiScamWinner
                          ? AppColors.sCoins
                          : AppColors.heatDanger,
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _selectedChoice!.explanation,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: _selectedChoice!.isAntiScamWinner
                                      ? AppColors.sCoinsDark
                                      : AppColors.heatDanger,
                                ),
                          ),
                          const Divider(height: 16),
                          Text(
                            _scenario.redFlagSummary,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: AppColors.textPrimary,
                                  height: 1.4,
                                ),
                          ),
                          if (_selectedChoice!.rewardCoins > 0) ...[
                            const SizedBox(height: 12),
                            Text(
                              'Reward: +${NumberFormatter.formatCurrency(_selectedChoice!.rewardCoins)} • +${_selectedChoice!.trustReward.toInt()} Trust',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: AppColors.sCoinsDark,
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Choice Buttons or Exit Action
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: _isAnswered
                  ? ScamButton(
                      label: 'RETURN TO HEADQUARTERS',
                      onPressed: () => Navigator.of(context).pop(),
                      variant: ScamButtonVariant.primary,
                      isFullWidth: true,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'SELECT YOUR RESPONSE:',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                letterSpacing: 1.0,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(height: 8),
                        ..._scenario.choices.map((choice) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: OutlinedButton(
                              onPressed: () => _handleChoice(choice),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 12,
                                ),
                                side: const BorderSide(color: AppColors.border),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppRadius.md,
                                  ),
                                ),
                                backgroundColor: AppColors.surfaceMuted,
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  choice.text,
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: AppColors.textPrimary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
