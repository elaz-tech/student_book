import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../config/admob_config.dart';

class AdBannerHome {
  static BannerAd? _banner;
  static bool _isLoaded = false;

  static BannerAd get myBanner {
    _banner ??= BannerAd(
      adUnitId: AdMobConfig.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _isLoaded = true;
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          _banner = null;
          _isLoaded = false;
        },
      ),
    );
    return _banner!;
  }

  static void load() {
    if (AdMobConfig.adsEnabled && !_isLoaded) {
      try {
        myBanner.load();
      } catch (e) {
        _isLoaded = false;
      }
    }
  }

  static void dispose() {
    _banner?.dispose();
    _banner = null;
    _isLoaded = false;
  }
}

class AdOpenBook {
  static BannerAd? _banner;
  static bool _isLoaded = false;

  static BannerAd get myBanner {
    _banner ??= BannerAd(
      adUnitId: AdMobConfig.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _isLoaded = true;
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          _banner = null;
          _isLoaded = false;
        },
      ),
    );
    return _banner!;
  }

  static void load() {
    if (AdMobConfig.adsEnabled && !_isLoaded) {
      try {
        myBanner.load();
      } catch (e) {
        _isLoaded = false;
      }
    }
  }

  static void dispose() {
    _banner?.dispose();
    _banner = null;
    _isLoaded = false;
  }
}
