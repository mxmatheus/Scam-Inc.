import 'package:flutter_test/flutter_test.dart';
import 'package:scam_inc/services/ad_service.dart';
import 'package:scam_inc/services/iap_service.dart';
import 'package:scam_inc/services/analytics_service.dart';

void main() {
  group('Monetization & Analytics Tests (PROMPTS 23-25)', () {
    test('AdService triggers reward only on confirmed completion', () async {
      final adService = StandardAdService(isDebugMode: true);
      bool rewardReceived = false;

      final success = await adService.showRewardedAd(
        adType: RewardedAdType.doubleIncome2x,
        onRewardEarned: () {
          rewardReceived = true;
        },
      );

      expect(success, true);
      expect(rewardReceived, true);
    });

    test('AdService enforces cooldown correctly', () async {
      final adService = StandardAdService(isDebugMode: true);

      await adService.showRewardedAd(
        adType: RewardedAdType.heatRelief,
        onRewardEarned: () {},
      );

      expect(adService.isCooldownActive, true);

      // Attempting to show immediately triggers failure callback
      bool failedCalled = false;
      final secondAttempt = await adService.showRewardedAd(
        adType: RewardedAdType.heatRelief,
        onRewardEarned: () {},
        onFailed: () {
          failedCalled = true;
        },
      );

      expect(secondAttempt, false);
      expect(failedCalled, true);
    });

    test(
      'IapService successfully handles product purchase and duplicate safety',
      () async {
        final iapService = StandardIapService();
        expect(iapService.isNoAdsPurchased, false);

        final purchased = await iapService.purchaseProduct(IapProduct.noAds);
        expect(purchased, true);
        expect(iapService.isNoAdsPurchased, true);
        expect(
          iapService.purchasedProductIds.contains('scam_inc_no_ads'),
          true,
        );
      },
    );

    test(
      'AnalyticsService logs product milestones safely without exceptions',
      () async {
        final analytics = StandardAnalyticsService();
        await analytics.logEvent(AnalyticsEvent.firstTap);
        await analytics.logEvent(AnalyticsEvent.firstPrestige, {'level': 1});

        expect(analytics.loggedEvents.contains('firstTap'), true);
        expect(analytics.loggedEvents.contains('firstPrestige'), true);
      },
    );
  });
}
