import 'package:flutter_test/flutter_test.dart';
import 'package:scam_inc/models/enums/game_enums.dart';
import 'package:scam_inc/models/event_choice.dart';
import 'package:scam_inc/models/game_event.dart';
import 'package:scam_inc/models/operation.dart';
import 'package:scam_inc/models/upgrade.dart';
import 'package:scam_inc/models/prestige_skill.dart';
import 'package:scam_inc/models/achievement.dart';
import 'package:scam_inc/models/daily_goal.dart';
import 'package:scam_inc/models/settings_state.dart';
import 'package:scam_inc/models/player_state.dart';
import 'package:scam_inc/models/player_save.dart';

void main() {
  group('Enums Integrity Tests', () {
    test('ResourceType has all expected values', () {
      expect(ResourceType.values.length, 6);
      expect(ResourceType.values, contains(ResourceType.sCoins));
      expect(ResourceType.values, contains(ResourceType.trustPoints));
      expect(ResourceType.values, contains(ResourceType.heat));
    });

    test('OperationTier has 8 distinct tiers', () {
      expect(OperationTier.values.length, 8);
      expect(OperationTier.values.first, OperationTier.tier1Basement);
      expect(OperationTier.values.last, OperationTier.tier8OffshoreIsland);
    });

    test('EventType has 8 distinct event types', () {
      expect(EventType.values.length, 8);
      expect(EventType.values, contains(EventType.serverRaid));
      expect(EventType.values, contains(EventType.whistleblowerLeak));
    });
  });

  group('EventChoice Model Tests', () {
    test('JSON serialization round-trip', () {
      const choice = EventChoice(
        id: 'choice_bribe',
        label: 'Bribe the Inspector',
        description: 'Pay 500 S-Coins to eliminate 20 Heat',
        sCoinsCost: 500.0,
        trustCost: 5.0,
        sCoinsReward: 0.0,
        trustReward: 10.0,
        heatDelta: -20.0,
        successRate: 0.85,
      );

      final json = choice.toJson();
      final fromJson = EventChoice.fromJson(json);

      expect(fromJson, equals(choice));
      expect(fromJson.hashCode, equals(choice.hashCode));
    });

    test('copyWith works correctly', () {
      const choice = EventChoice(id: 'c1', label: 'Option A');
      final updated = choice.copyWith(label: 'Option B', sCoinsCost: 100.0);

      expect(updated.id, 'c1');
      expect(updated.label, 'Option B');
      expect(updated.sCoinsCost, 100.0);
    });
  });

  group('GameEvent Model Tests', () {
    test('JSON serialization round-trip', () {
      final event = GameEvent(
        id: 'ev_raid_01',
        title: 'Server Room Police Raid',
        description: 'Federal agents are knocking on the door!',
        illustrationPath:
            'assets/illustrations/events/event_server_room_police_raid.png',
        eventType: EventType.serverRaid,
        choices: const [
          EventChoice(id: 'c1', label: 'Shred Hard Drives', heatDelta: -30.0),
          EventChoice(id: 'c2', label: 'Call Shady Lawyer', sCoinsCost: 2000.0),
        ],
        durationSeconds: 45,
        expiresAt: DateTime.utc(2026, 12, 31, 23, 59, 59),
      );

      final json = event.toJson();
      final fromJson = GameEvent.fromJson(json);

      expect(fromJson, equals(event));
      expect(fromJson.choices.length, 2);
      expect(fromJson.eventType, EventType.serverRaid);
    });
  });

  group('Operation Model Tests', () {
    test('Cost scaling calculations', () {
      const op = Operation(
        id: 'op_sms',
        name: 'Fake Delivery SMS',
        description: 'Send parcel tracking phishing links',
        iconPath: 'assets/icons/operations/op_fake_delivery_sms.png',
        baseCost: 100.0,
        baseIncome: 5.0,
        costMultiplier: 1.15,
        level: 0,
      );

      expect(op.nextUpgradeCost, 100.0);
      expect(op.calculateUpgradeCost(1), 100.0);
      // Buying 2 levels at level 0: 100.0 + 100.0 * 1.15 = 215.0
      expect(op.calculateUpgradeCost(2), closeTo(215.0, 0.001));

      final leveledOp = op.copyWith(level: 5);
      expect(leveledOp.currentIncomePerSecond, 25.0);
    });

    test('JSON serialization round-trip', () {
      const op = Operation(
        id: 'op_bot_farm',
        name: 'Social Bot Farm',
        description: 'Automate spam comments',
        iconPath: 'assets/icons/operations/op_bot_farm_network.png',
        baseCost: 5000.0,
        baseIncome: 120.0,
        baseHeatPerSecond: 0.2,
        baseTrustPerSecond: 0.05,
        costMultiplier: 1.18,
        level: 10,
        isUnlocked: true,
        trustRequirement: 25.0,
        tier: OperationTier.tier2Garage,
      );

      final json = op.toJson();
      final fromJson = Operation.fromJson(json);

      expect(fromJson, equals(op));
    });
  });

  group('Upgrade Model Tests', () {
    test('JSON serialization round-trip', () {
      const upgrade = Upgrade(
        id: 'up_turbo_sms',
        name: 'High-Speed SMS Gateway',
        description: 'Doubles Fake Delivery SMS revenue',
        iconPath: 'assets/icons/core/core_arrow_up_circle_upgrade.png',
        cost: 2500.0,
        targetOperationId: 'op_sms',
        multiplier: 2.0,
        isPurchased: true,
        requiredOperationLevel: 10,
      );

      final json = upgrade.toJson();
      final fromJson = Upgrade.fromJson(json);

      expect(fromJson, equals(upgrade));
    });
  });

  group('PrestigeSkill Model Tests', () {
    test('Skill cost and bonus calculations', () {
      const skill = PrestigeSkill(
        id: 'skill_shell_corp',
        name: 'Shell Company Protection',
        description: 'Reduces Heat generation rate',
        iconPath: 'assets/icons/resources/res_offshore_vip_crown.png',
        baseCost: 10.0,
        costMultiplier: 2.0,
        level: 2,
        maxLevel: 5,
        branch: PrestigeBranch.stealthOffshore,
        effectValuePerLevel: 0.10,
      );

      expect(skill.isMaxed, false);
      // Cost for level 2 -> 10.0 * (2.0 ^ 2) = 40.0
      expect(skill.nextUpgradeCost, 40.0);
      expect(skill.currentBonusValue, 0.20);

      final maxedSkill = skill.copyWith(level: 5);
      expect(maxedSkill.isMaxed, true);
      expect(maxedSkill.nextUpgradeCost, 0.0);
    });

    test('JSON serialization round-trip', () {
      const skill = PrestigeSkill(
        id: 'skill_crypto',
        name: 'Crypto Tumbler',
        description: 'Boosts laundered cash yield',
        iconPath: 'assets/icons/resources/res_laundered_cash.png',
        baseCost: 5.0,
        level: 1,
        branch: PrestigeBranch.cryptoSyndicate,
      );

      final json = skill.toJson();
      final fromJson = PrestigeSkill.fromJson(json);

      expect(fromJson, equals(skill));
    });
  });

  group('Achievement Model Tests', () {
    test('Progress ratio clamp', () {
      const ach = Achievement(
        id: 'ach_millionaire',
        title: 'First Million',
        description: 'Earn 1,000,000 S-Coins',
        iconPath: 'assets/icons/achievements/ach_first_million_vault.png',
        category: AchievementCategory.wealth,
        targetValue: 1000000.0,
        currentProgress: 500000.0,
      );

      expect(ach.progressRatio, 0.5);

      final completedAch = ach.copyWith(currentProgress: 2000000.0);
      expect(completedAch.progressRatio, 1.0);
    });

    test('JSON serialization round-trip', () {
      final ach = Achievement(
        id: 'ach_godfather',
        title: 'The Godfather',
        description: 'Unlock Tier 8 Offshore Island',
        iconPath: 'assets/icons/achievements/ach_the_godfather_boss.png',
        category: AchievementCategory.prestigeEscape,
        targetValue: 1.0,
        currentProgress: 1.0,
        isUnlocked: true,
        unlockedAt: DateTime.utc(2026, 8, 16, 12, 0, 0),
        rewardGems: 50,
      );

      final json = ach.toJson();
      final fromJson = Achievement.fromJson(json);

      expect(fromJson, equals(ach));
    });
  });

  group('DailyGoal Model Tests', () {
    test('JSON serialization and progress', () {
      const goal = DailyGoal(
        id: 'goal_tap_100',
        title: 'Finger Fatigue',
        description: 'Tap 100 times',
        targetValue: 100.0,
        currentProgress: 75.0,
        rewardCoins: 5000.0,
        rewardGems: 10,
        isCompleted: false,
        isClaimed: false,
      );

      expect(goal.progressRatio, 0.75);

      final json = goal.toJson();
      final fromJson = DailyGoal.fromJson(json);

      expect(fromJson, equals(goal));
    });
  });

  group('SettingsState Model Tests', () {
    test('JSON serialization and defaults', () {
      const settings = SettingsState();
      expect(settings.soundEnabled, true);
      expect(settings.musicEnabled, true);
      expect(settings.compactNumberFormat, true);

      final customSettings = settings.copyWith(
        soundEnabled: false,
        compactNumberFormat: false,
        languageCode: 'tr',
      );

      final json = customSettings.toJson();
      final fromJson = SettingsState.fromJson(json);

      expect(fromJson, equals(customSettings));
    });
  });

  group('PlayerState Model Tests', () {
    test('Clamping behavior for trust and heat', () {
      final state = PlayerState(
        coins: 1000.0,
        trust: 120.0, // should clamp to 100
        heat: -10.0, // should clamp to 0
        lastActiveTimestamp: DateTime.utc(2026, 1, 1),
      );

      final clamped = state.copyWith(trust: 150.0, heat: 100.0);
      expect(clamped.trust, 100.0);
      expect(clamped.isMaxTrust, true);
      expect(clamped.heat, 100.0);
      expect(clamped.isBusted, true);
    });

    test('JSON serialization round-trip', () {
      final state = PlayerState(
        coins: 450000.0,
        trust: 85.5,
        heat: 42.0,
        launderedCash: 120.0,
        gems: 35,
        lifetimeRevenue: 2500000.0,
        currentOfficeTier: OperationTier.tier5Downtown,
        prestigeLevel: 2,
        prestigeMultiplier: 1.5,
        totalTaps: 4321,
        lastActiveTimestamp: DateTime.utc(2026, 8, 16, 14, 0, 0),
      );

      final json = state.toJson();
      final fromJson = PlayerState.fromJson(json);

      expect(fromJson, equals(state));
    });
  });

  group('PlayerSave Aggregate Root Tests', () {
    test('Full snapshot serialization round-trip', () {
      final save = PlayerSave(
        version: 1,
        savedAt: DateTime.utc(2026, 8, 16, 15, 30, 0),
        playerState: PlayerState(
          coins: 999999.0,
          trust: 70.0,
          heat: 30.0,
          launderedCash: 500.0,
          gems: 25,
          lifetimeRevenue: 5000000.0,
          currentOfficeTier: OperationTier.tier4Suburban,
          prestigeLevel: 1,
          prestigeMultiplier: 1.25,
          totalTaps: 850,
          lastActiveTimestamp: DateTime.utc(2026, 8, 16, 15, 30, 0),
        ),
        operations: const [
          Operation(
            id: 'op_sms',
            name: 'Fake SMS',
            description: 'SMS test',
            iconPath: 'assets/icons/operations/op_fake_delivery_sms.png',
            baseCost: 10.0,
            baseIncome: 1.0,
            level: 5,
            isUnlocked: true,
          ),
        ],
        upgrades: const [
          Upgrade(
            id: 'up_sms_1',
            name: 'Turbo SMS',
            description: '2x',
            iconPath: 'assets/icons/core/core_arrow_up_circle_upgrade.png',
            cost: 100.0,
            isPurchased: true,
          ),
        ],
        prestigeSkills: const [
          PrestigeSkill(
            id: 'ps_offshore',
            name: 'Offshore',
            description: 'Yield bonus',
            iconPath: 'assets/icons/resources/res_offshore_vip_crown.png',
            baseCost: 1.0,
            level: 1,
          ),
        ],
        achievements: [
          Achievement(
            id: 'ach_1',
            title: 'First Step',
            description: 'Test',
            iconPath: 'assets/icons/achievements/ach_first_million_vault.png',
            category: AchievementCategory.wealth,
            targetValue: 100.0,
            currentProgress: 100.0,
            isUnlocked: true,
            unlockedAt: DateTime.utc(2026, 8, 16, 12, 0, 0),
          ),
        ],
        dailyGoals: const [
          DailyGoal(
            id: 'dg_1',
            title: 'Daily Tap',
            description: 'Tap 10 times',
            targetValue: 10.0,
            currentProgress: 10.0,
            isCompleted: true,
            isClaimed: false,
          ),
        ],
        settings: const SettingsState(
          soundEnabled: false,
          musicEnabled: true,
          languageCode: 'tr',
        ),
      );

      final json = save.toJson();
      final fromJson = PlayerSave.fromJson(json);

      expect(fromJson, equals(save));
      expect(fromJson.hashCode, equals(save.hashCode));
      expect(fromJson.operations.length, 1);
      expect(fromJson.upgrades.length, 1);
      expect(fromJson.prestigeSkills.length, 1);
      expect(fromJson.achievements.length, 1);
      expect(fromJson.dailyGoals.length, 1);
      expect(fromJson.settings.soundEnabled, false);
      expect(fromJson.settings.languageCode, 'tr');
    });

    test('Initial save factory has valid defaults', () {
      final initialSave = PlayerSave.initial();
      expect(initialSave.version, 1);
      expect(initialSave.playerState.coins, 0.0);
      expect(initialSave.playerState.trust, 0.0);
      expect(initialSave.playerState.heat, 0.0);
      expect(initialSave.operations, isEmpty);
      expect(initialSave.settings.soundEnabled, true);
    });
  });
}
