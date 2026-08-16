import 'dart:math' as math;
import '../../../core/constants/asset_constants.dart';
import '../models/scam_baiter_scenario.dart';

class ScamBaiterService {
  static List<ScamBaiterScenario> getScenarios() {
    return const [
      ScamBaiterScenario(
        id: 'sb_crypto_guru',
        profileName: 'Elena "100x" Petrova',
        handle: '@official_elena_crypto_vip',
        avatarAsset: AppAssets.chatInvestmentBroker,
        bio:
            'Certified Binary Hedge Arbitrageur | DM for guaranteed 400% daily ROI in decentralized liquidity pools 🚀📈',
        directMessage:
            'Hey handsome! I noticed your profile. My VIP quantitative trading bot made \$48,000 this morning. Want me to trade your balance for free?',
        isMalicious: true,
        redFlagExplanation:
            '🚩 RED FLAGS: Promises of "guaranteed high returns", unsolicited romantic flattery, and asking to control your crypto funds.',
      ),
      ScamBaiterScenario(
        id: 'sb_darkweb_seller',
        profileName: 'CipherZeroX',
        handle: '@cipher_dumps_0day',
        avatarAsset: AppAssets.chatDarkwebContact,
        bio:
            'Database broker | 0-day exploits | Untraceable SIM cloners | Telegram escrow only 🔒',
        directMessage:
            'Yo, I have 50,000 leaked corporate executive logins for your city. Send 0.05 BTC before midnight or I sell to your competitors.',
        isMalicious: true,
        redFlagExplanation:
            '🚩 RED FLAGS: Darknet extortion, artificial midnight countdowns, and demanding irreversible cryptocurrency payments.',
      ),
      ScamBaiterScenario(
        id: 'sb_legit_journalist',
        profileName: 'Sarah Jenkins',
        handle: '@s_jenkins_investigates',
        avatarAsset: AppAssets.chatJournalist,
        bio:
            'Senior Cybercrime Tech Reporter @ Global Daily News | Verified press credentials at press.globalnews.com/jenkins',
        directMessage:
            'Hello, I am writing an article on online safety and would like an on-the-record comment regarding cyber awareness campaigns.',
        isMalicious: false,
        redFlagExplanation:
            '✅ SAFE CONTACT: Clear verifiable press credentials, professional inquiry, no suspicious links or urgent payment demands.',
      ),
    ];
  }

  ScamBaiterScenario getRandomScenario({math.Random? random}) {
    final rand = random ?? math.Random();
    final all = getScenarios();
    return all[rand.nextInt(all.length)];
  }
}
