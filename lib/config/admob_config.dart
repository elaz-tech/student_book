import 'package:flutter/foundation.dart';

class AdMobConfig {
  static const bool useTestAds = false;

  // Google's official test ad unit IDs
  static const String _testBannerAdUnitIdAndroid =
      'ca-app-pub-3940256099942544/6300978111';
  static const String _testBannerAdUnitIdIOS =
      'ca-app-pub-3940256099942544/2934735716';
  static const String _testAppId = 'ca-app-pub-3940256099942544~3347511713';

  // Production Ad Unit IDs
  static const String _productionBannerAdUnitIdAndroid =
      'ca-app-pub-6327439040530504/2738040985';
  static const String _productionBannerAdUnitIdIOS =
      'ca-app-pub-6327439040530504/2738040985';
  static const String _productionAppId =
      'ca-app-pub-6327439040530504~7681365571';

  static bool get _isIOS =>
      defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.macOS;

  static String get bannerAdUnitId {
    if (useTestAds) {
      return _isIOS ? _testBannerAdUnitIdIOS : _testBannerAdUnitIdAndroid;
    }
    return _isIOS
        ? _productionBannerAdUnitIdIOS
        : _productionBannerAdUnitIdAndroid;
  }

  static String get appId {
    return useTestAds ? _testAppId : _productionAppId;
  }

  static bool get adsEnabled => true;
  static const double bannerHeight = 50.0;
}
