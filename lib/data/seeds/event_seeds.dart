import '../../core/constants/asset_constants.dart';
import '../../models/enums/game_enums.dart';
import '../../models/event_choice.dart';
import '../../models/game_event.dart';

/// Master seed definitions for all 8 narrative random events in SCAM INC.
class EventSeeds {
  static List<GameEvent> getAllEvents() {
    return [
      const GameEvent(
        id: 'ev_police_raid',
        title: 'Server Room Police Raid',
        description:
            'Federal agents and cyber forensic inspectors are breaching your offshore VPN proxy datacenter!',
        illustrationPath: AppAssets.eventServerRoomPoliceRaid,
        eventType: EventType.serverRaid,
        durationSeconds: 45,
        choices: [
          EventChoice(
            id: 'raid_c1',
            label: 'Emergency Hard Drive Degauss',
            description:
                'Instantly wipe physical server drives. Eliminates 30% Heat.',
            heatDelta: -30.0,
            trustCost: 5.0,
            successRate: 0.95,
          ),
          EventChoice(
            id: 'raid_c2',
            label: 'Dispatch Elite Corporate Lawyers',
            description:
                'Pay 2,500 S-Coins in emergency legal retainers to block search warrants.',
            sCoinsCost: 2500.0,
            heatDelta: -45.0,
            trustReward: 5.0,
            successRate: 0.85,
          ),
        ],
      ),
      const GameEvent(
        id: 'ev_journalist_investigation',
        title: 'Investigative Journalist Dossier',
        description:
            'A renowned tech reporter is publishing a scathing exposé revealing your delivery SMS tracking networks.',
        illustrationPath: AppAssets.eventJournalistInvestigation,
        eventType: EventType.journalistInvestigation,
        durationSeconds: 60,
        choices: [
          EventChoice(
            id: 'journ_c1',
            label: 'Issue Cease & Desist Warning',
            description:
                'Threaten immediate multi-million defamation litigation.',
            trustCost: 10.0,
            heatDelta: -15.0,
            successRate: 0.75,
          ),
          EventChoice(
            id: 'journ_c2',
            label: 'Hire Top PR Crisis Agency',
            description:
                'Flood news outlets with fabricated charity donations (Cost: 5,000 S-Coins).',
            sCoinsCost: 5000.0,
            trustReward: 15.0,
            heatDelta: -20.0,
            successRate: 0.90,
          ),
        ],
      ),
      const GameEvent(
        id: 'ev_viral_trend',
        title: 'Viral Social Media Surge',
        description:
            'A meme regarding your fake giveaway campaign went viral on TikTok, multiplying user traffic!',
        illustrationPath: AppAssets.eventViralTrendExplosion,
        eventType: EventType.viralTrend,
        durationSeconds: 30,
        choices: [
          EventChoice(
            id: 'viral_c1',
            label: 'Monetize the Surge',
            description:
                'Aggressively capture incoming traffic. Payout +10,000 S-Coins at +15% Heat.',
            sCoinsReward: 10000.0,
            heatDelta: 15.0,
            successRate: 1.0,
          ),
          EventChoice(
            id: 'viral_c2',
            label: 'Build Organic Brand Trust',
            description: 'Provide legitimate discounts to boost Trust by +10.',
            trustReward: 10.0,
            heatDelta: -5.0,
            successRate: 1.0,
          ),
        ],
      ),
      const GameEvent(
        id: 'ev_influencer_collab',
        title: 'High-Profile Influencer Deal',
        description:
            'A famous lifestyle vlogger offers to promote your AI wellness supplements on live stream.',
        illustrationPath: AppAssets.eventInfluencerCollabDeal,
        eventType: EventType.influencerCollab,
        durationSeconds: 45,
        choices: [
          EventChoice(
            id: 'infl_c1',
            label: 'Sponsor the Broadcast',
            description:
                'Pay 15,000 S-Coins sponsorship fee for expected 50,000 S-Coins yield.',
            sCoinsCost: 15000.0,
            sCoinsReward: 50000.0,
            trustReward: 8.0,
            successRate: 0.80,
          ),
          EventChoice(
            id: 'infl_c2',
            label: 'Decline Sponsorship',
            description: 'Keep a low profile to prevent regulator scrutiny.',
            heatDelta: -10.0,
            successRate: 1.0,
          ),
        ],
      ),
      const GameEvent(
        id: 'ev_bank_freeze',
        title: 'International Account Freeze',
        description:
            'European AML compliance algorithms flagged several merchant accounts for suspicious activity!',
        illustrationPath: AppAssets.eventBankAccountFreeze,
        eventType: EventType.bankFreeze,
        durationSeconds: 60,
        choices: [
          EventChoice(
            id: 'bank_c1',
            label: 'Reroute Through Crypto Tumbler',
            description:
                'Convert stuck capital to privacy tokens (+20,000 S-Coins, +10 Heat).',
            sCoinsReward: 20000.0,
            heatDelta: 10.0,
            successRate: 0.85,
          ),
          EventChoice(
            id: 'bank_c2',
            label: 'Submit Fabricated Invoices',
            description:
                'Provide fake vendor receipts to unlock accounts cleanly.',
            trustReward: 10.0,
            heatDelta: -10.0,
            successRate: 0.70,
          ),
        ],
      ),
      const GameEvent(
        id: 'ev_whistleblower_leak',
        title: 'Disgruntled Intern Leak',
        description:
            'An unpaid customer support intern leaked internal chat scripts on a darknet forum!',
        illustrationPath: AppAssets.eventWhistleblowerLeak,
        eventType: EventType.whistleblowerLeak,
        durationSeconds: 40,
        choices: [
          EventChoice(
            id: 'leak_c1',
            label: 'Offer Golden Handshake',
            description:
                'Pay 8,000 S-Coins hush money with strict non-disclosure terms.',
            sCoinsCost: 8000.0,
            heatDelta: -25.0,
            trustReward: 5.0,
            successRate: 0.95,
          ),
          EventChoice(
            id: 'leak_c2',
            label: 'Discredit the Whistleblower',
            description: 'Claim leaked logs were generated by competitor bots.',
            trustCost: 15.0,
            heatDelta: 5.0,
            successRate: 0.60,
          ),
        ],
      ),
      const GameEvent(
        id: 'ev_system_blackout',
        title: 'Global Cloud Infrastructure Outage',
        description:
            'A major cloud hosting provider experienced worldwide downtime, temporarily halting bot swarms.',
        illustrationPath: AppAssets.eventSystemBlackoutCrash,
        eventType: EventType.systemBlackout,
        durationSeconds: 30,
        choices: [
          EventChoice(
            id: 'blackout_c1',
            label: 'Switch to Backup Shadow Servers',
            description:
                'Spend 12,000 S-Coins to restore full automation immediately.',
            sCoinsCost: 12000.0,
            trustReward: 12.0,
            successRate: 1.0,
          ),
          EventChoice(
            id: 'blackout_c2',
            label: 'Wait for Cloud Provider Fix',
            description:
                'Cool down servers and reduce investigation heat (-20 Heat).',
            heatDelta: -20.0,
            successRate: 1.0,
          ),
        ],
      ),
      const GameEvent(
        id: 'ev_offshore_opportunity',
        title: 'Offshore Sovereign Island Tender',
        description:
            'A tiny Pacific island nation invites VIP international investors to purchase sovereign citizenship.',
        illustrationPath: AppAssets.eventOffshoreInvestmentOpportunity,
        eventType: EventType.offshoreOpportunity,
        durationSeconds: 60,
        choices: [
          EventChoice(
            id: 'offshore_c1',
            label: 'Acquire Diplomatic Passport',
            description:
                'Pay 50,000 S-Coins for permanent immunity (-50 Heat, +20 Trust).',
            sCoinsCost: 50000.0,
            heatDelta: -50.0,
            trustReward: 20.0,
            successRate: 0.90,
          ),
          EventChoice(
            id: 'offshore_c2',
            label: 'Pass on the Offer',
            description: 'Save capital for local operation upgrades.',
            successRate: 1.0,
          ),
        ],
      ),
    ];
  }
}
