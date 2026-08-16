import 'dart:async';

/// Available in-app purchase product definitions.
enum IapProduct {
  noAds(
    id: 'scam_inc_no_ads',
    title: 'Immunity Pass (No Ads)',
    priceString: '\$2.99',
    description:
        'Permanently eliminates forced ads while keeping voluntary boosts free.',
  ),
  offshoreVipPack(
    id: 'scam_inc_offshore_vip',
    title: 'Offshore Executive Starter',
    priceString: '\$4.99',
    description: 'Instant +50 Laundered Cash & +500 Gems.',
  );

  final String id;
  final String title;
  final String priceString;
  final String description;

  const IapProduct({
    required this.id,
    required this.title,
    required this.priceString,
    required this.description,
  });
}

/// Abstract contract for In-App Purchases and store billing.
abstract class IapService {
  bool get isNoAdsPurchased;
  Set<String> get purchasedProductIds;

  Future<bool> purchaseProduct(IapProduct product);
  Future<bool> restorePurchases();
}

/// Standalone testable IAP implementation.
class StandardIapService implements IapService {
  final Set<String> _purchasedIds = {};

  StandardIapService({Set<String>? initialPurchases}) {
    if (initialPurchases != null) {
      _purchasedIds.addAll(initialPurchases);
    }
  }

  @override
  bool get isNoAdsPurchased => _purchasedIds.contains(IapProduct.noAds.id);

  @override
  Set<String> get purchasedProductIds => Set.unmodifiable(_purchasedIds);

  @override
  Future<bool> purchaseProduct(IapProduct product) async {
    // Simulate safe transaction processing
    await Future.delayed(const Duration(milliseconds: 300));
    _purchasedIds.add(product.id);
    return true;
  }

  @override
  Future<bool> restorePurchases() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }
}
