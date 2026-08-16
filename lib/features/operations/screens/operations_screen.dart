import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/operation_card.dart';
import '../../../core/widgets/upgrade_card.dart';
import '../../../models/enums/game_enums.dart';
import '../../../services/providers/service_providers.dart';

class OperationsScreen extends ConsumerStatefulWidget {
  const OperationsScreen({super.key});

  @override
  ConsumerState<OperationsScreen> createState() => _OperationsScreenState();
}

class _OperationsScreenState extends ConsumerState<OperationsScreen> {
  int _buyMultiplier = 1; // 1, 10, 100
  OperationTier? _selectedTierFilter; // null = All

  static const List<OperationTier> _tiers = OperationTier.values;

  String _formatTierName(OperationTier tier) {
    switch (tier) {
      case OperationTier.tier1Basement:
        return 'T1 Basement';
      case OperationTier.tier2Garage:
        return 'T2 Garage';
      case OperationTier.tier3Coworking:
        return 'T3 Coworking';
      case OperationTier.tier4Suburban:
        return 'T4 Suburban';
      case OperationTier.tier5Downtown:
        return 'T5 Downtown';
      case OperationTier.tier6GlassTower:
        return 'T6 Glass Tower';
      case OperationTier.tier7Penthouse:
        return 'T7 Penthouse';
      case OperationTier.tier8OffshoreIsland:
        return 'T8 Offshore Island';
    }
  }

  @override
  Widget build(BuildContext context) {
    final coins = ref.watch(playerStateProvider.select((s) => s.coins));
    final trust = ref.watch(playerStateProvider.select((s) => s.trust));
    final operations = ref.watch(operationsProvider);
    final upgrades = ref.watch(upgradesProvider);

    final filteredOps = _selectedTierFilter == null
        ? operations
        : operations.where((op) => op.tier == _selectedTierFilter).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header with Multiplier Switcher
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Digital Schemes',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    'Scale automated income pipelines',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              Row(
                children: [1, 10, 100].map((multiplier) {
                  final isSelected = _buyMultiplier == multiplier;
                  return Padding(
                    padding: const EdgeInsets.only(left: 6.0),
                    child: ChoiceChip(
                      label: Text('${multiplier}x'),
                      selected: isSelected,
                      onSelected: (_) {
                        setState(() {
                          _buyMultiplier = multiplier;
                        });
                      },
                      selectedColor: AppColors.sCoins,
                      labelStyle: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Horizontal Tier Filter Tabs
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: const Text('All Tiers'),
                    selected: _selectedTierFilter == null,
                    onSelected: (_) {
                      setState(() {
                        _selectedTierFilter = null;
                      });
                    },
                    selectedColor: AppColors.corporateNavy,
                    labelStyle: TextStyle(
                      color: _selectedTierFilter == null
                          ? Colors.white
                          : AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
                ..._tiers.map((tier) {
                  final isSelected = _selectedTierFilter == tier;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: FilterChip(
                      label: Text(_formatTierName(tier)),
                      selected: isSelected,
                      onSelected: (_) {
                        setState(() {
                          _selectedTierFilter = isSelected ? null : tier;
                        });
                      },
                      selectedColor: AppColors.corporateNavy,
                      labelStyle: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Upgrades Market Section (Shown when on "All" filter)
          if (_selectedTierFilter == null &&
              upgrades.any((u) => !u.isPurchased)) ...[
            const SectionHeader(
              title: 'Available Upgrades',
              subtitle: 'Multipliers and automation boosts',
            ),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: upgrades.where((u) => !u.isPurchased).length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, idx) {
                final up = upgrades.where((u) => !u.isPurchased).toList()[idx];
                return UpgradeCard(
                  upgrade: up,
                  currentCoins: coins,
                  onBuy: () {
                    ref.read(gameControllerProvider.notifier).buyUpgrade(up.id);
                  },
                );
              },
            ),
            const SizedBox(height: 20),
          ],

          // Operations List
          SectionHeader(
            title: _selectedTierFilter == null
                ? 'All Schemes (${operations.length})'
                : '${_formatTierName(_selectedTierFilter!)} (${filteredOps.length})',
            subtitle: 'Automated income generation',
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredOps.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, idx) {
              final op = filteredOps[idx];
              return OperationCard(
                operation: op,
                currentCoins: coins,
                currentTrust: trust,
                buyMultiplier: _buyMultiplier,
                onUpgrade: () {
                  ref
                      .read(gameControllerProvider.notifier)
                      .buyOperation(op.id, count: _buyMultiplier);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
