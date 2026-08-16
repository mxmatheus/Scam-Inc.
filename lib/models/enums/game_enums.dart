/// SCAM INC. — Domain Enums
/// Core game enumerations for resources, operation tiers, events, achievements, etc.
library;

enum ResourceType { sCoins, trustPoints, heat, launderedCash, gems, influence }

enum OperationTier {
  tier1Basement,
  tier2Garage,
  tier3Coworking,
  tier4Suburban,
  tier5Downtown,
  tier6GlassTower,
  tier7Penthouse,
  tier8OffshoreIsland,
}

enum EventType {
  journalistInvestigation,
  viralTrend,
  serverRaid,
  influencerCollab,
  bankFreeze,
  whistleblowerLeak,
  systemBlackout,
  offshoreOpportunity,
}

enum AchievementCategory {
  wealth,
  heatSurfer,
  trustEmpire,
  prestigeEscape,
  automationMaster,
  specialOperations,
}

enum GameScreen {
  home,
  operations,
  network,
  events,
  prestige,
  shop,
  achievements,
  settings,
}

enum PrestigeBranch { stealthOffshore, cryptoSyndicate, politicalInfluence }
