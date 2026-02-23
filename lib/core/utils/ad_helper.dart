import 'dart:io';

/// AdMob helper with placeholder unit IDs.
/// Replace these with real AdMob IDs before publishing.
class AdHelper {
  // ─── Banner Ad ──────────────────────────────────────────────────
  /* TODO: Replace with real AdMob ID */
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111'; // Test ID
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716'; // Test ID
    }
    throw UnsupportedError('Unsupported platform');
  }

  // ─── Interstitial Ad ───────────────────────────────────────────
  /* TODO: Replace with real AdMob ID */
  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/1033173712'; // Test ID
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/4411468910'; // Test ID
    }
    throw UnsupportedError('Unsupported platform');
  }

  // ─── Native Ad ──────────────────────────────────────────────────
  /* TODO: Replace with real AdMob ID */
  static String get nativeAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/2247696110'; // Test ID
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/3986624511'; // Test ID
    }
    throw UnsupportedError('Unsupported platform');
  }
}
