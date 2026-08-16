import 'dart:math' as math;
import '../../../core/constants/asset_constants.dart';
import '../models/chat_scenario.dart';

/// Service managing educational Suspicious Chat scenarios and evaluation.
class ChatMinigameService {
  static List<ChatScenario> getScenarios() {
    return const [
      ChatScenario(
        id: 'sc_phishing_2fa',
        contactName: 'Security Desk #440',
        contactRole: 'Alleged Account Security',
        avatarAsset: AppAssets.chatVerifiedSupport,
        incomingMessage:
            'URGENT: Unauthorized login detected from Geneva! To prevent account deletion, send your 6-digit SMS code right now!',
        redFlagSummary:
            '🚩 RED FLAGS: Artificial urgency, fear tactics, and requesting a 2FA one-time code. Legitimate institutions never ask for your SMS verification code.',
        choices: [
          ChatChoice(
            id: 'c1',
            text: 'Here is my code: 492-108. Please don\'t delete my account!',
            isAntiScamWinner: false,
            rewardCoins: 0,
            trustReward: -10,
            heatDelta: 20,
            explanation:
                '❌ Critical Mistake! Sharing 2FA codes gives attackers instant full account access.',
          ),
          ChatChoice(
            id: 'c2',
            text:
                'I will log into the official portal directly to check my security logs.',
            isAntiScamWinner: true,
            rewardCoins: 5000,
            trustReward: 10,
            heatDelta: -15,
            explanation:
                '✅ Perfect Response! Always navigate directly to official websites rather than replying to unsolicited messages.',
          ),
          ChatChoice(
            id: 'c3',
            text:
                'Can you tell me your employee badge number and manager\'s phone?',
            isAntiScamWinner: false,
            rewardCoins: 500,
            trustReward: 0,
            heatDelta: 5,
            explanation:
                '⚠️ Risky: Scammers readily forge fake badge numbers and credentials.',
          ),
        ],
      ),
      ChatScenario(
        id: 'sc_lottery_prize',
        contactName: 'Lucky Draw Concierge',
        contactRole: 'Prize Notification Bot',
        avatarAsset: AppAssets.chatLotteryGamer,
        incomingMessage:
            'CONGRATULATIONS! You won \$250,000 in the Global Telecom Sweepstakes! Just send \$250 upfront courier insurance fee to claim.',
        redFlagSummary:
            '🚩 RED FLAGS: Winning a contest you never entered, and requiring an upfront deposit or wire fee to release your "prize".',
        choices: [
          ChatChoice(
            id: 'c1',
            text:
                'Where do I send the \$250 courier fee? Wire transfer or Crypto?',
            isAntiScamWinner: false,
            rewardCoins: 0,
            trustReward: -5,
            heatDelta: 15,
            explanation:
                '❌ You just paid an advance fee fraud scheme. Real prizes never require upfront fees.',
          ),
          ChatChoice(
            id: 'c2',
            text:
                'Deduct the \$250 fee from the \$250,000 prize and send the rest.',
            isAntiScamWinner: false,
            rewardCoins: 1000,
            trustReward: 0,
            heatDelta: 0,
            explanation:
                '⚠️ Humorous, but engaging with sweepstakes scammers confirms your number is active.',
          ),
          ChatChoice(
            id: 'c3',
            text: 'I never entered any sweepstakes. Block and report as spam.',
            isAntiScamWinner: true,
            rewardCoins: 5000,
            trustReward: 10,
            heatDelta: -15,
            explanation:
                '✅ Correct Action! Unsolicited prize claims are 100% advance-fee fraud schemes.',
          ),
        ],
      ),
      ChatScenario(
        id: 'sc_tax_urgency',
        contactName: 'Inspector Vance',
        contactRole: 'Federal Revenue Agent',
        avatarAsset: AppAssets.chatTaxEnforcer,
        incomingMessage:
            'WARRANT PENDING: You owe \$1,420 in unpaid federal taxes. Immediate arrest warrants will execute unless settled via Apple Gift Cards.',
        redFlagSummary:
            '🚩 RED FLAGS: Government agencies never demand payments via retail Gift Cards or cryptocurrencies, nor do they notify arrests via instant chat.',
        choices: [
          ChatChoice(
            id: 'c1',
            text: 'Running to the store now! Please hold off the police squad!',
            isAntiScamWinner: false,
            rewardCoins: 0,
            trustReward: -15,
            heatDelta: 25,
            explanation:
                '❌ Government agencies never accept retail gift cards as legal tender.',
          ),
          ChatChoice(
            id: 'c2',
            text:
                'Official tax disputes are handled via postal mail and audited notices. Block sender.',
            isAntiScamWinner: true,
            rewardCoins: 5000,
            trustReward: 15,
            heatDelta: -20,
            explanation:
                '✅ Expert Response! Government agencies communicate legal tax issues through registered postal mail.',
          ),
          ChatChoice(
            id: 'c3',
            text: 'Do you accept Steam wallet codes instead?',
            isAntiScamWinner: false,
            rewardCoins: 500,
            trustReward: 0,
            heatDelta: 5,
            explanation:
                '⚠️ Playing with scammers wastes time; reporting and blocking is the safest protocol.',
          ),
        ],
      ),
    ];
  }

  ChatScenario getRandomScenario({math.Random? random}) {
    final rand = random ?? math.Random();
    final all = getScenarios();
    return all[rand.nextInt(all.length)];
  }
}
