import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:pet_care/models/banner_anuncio.dart';

class BannerComponent extends StatefulWidget {
  final VoidCallback onBannerClosed;
  const BannerComponent({super.key, required this.onBannerClosed});

  @override
  BannerComponentState createState() => BannerComponentState();
}

class BannerComponentState extends State<BannerComponent> {
  BannerAd? banner;

  @override
  void initState() {
    super.initState();

    banner = BannerAd(
      size: AdSize.banner,
      adUnitId: kReleaseMode ? BannerAnuncio.id : BannerAnuncio.testeId,
      listener: BannerAdListener(
        onAdFailedToLoad: (ad, err) {
          setState(() {
            ad.dispose();
            banner = null;
          });
        },
      ),
      request: const AdRequest(),
    )..load();
  }

  @override
  void dispose() {
    banner?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return banner != null
        ? Container(
            alignment: Alignment.bottomCenter,
            width: banner!.size.width.toDouble(),
            height: banner!.size.height.toDouble(),
            child: Stack(
              children: [
                AdWidget(ad: banner!),
                IconButton(
                  onPressed: () {
                    widget.onBannerClosed();
                    banner!.dispose();
                  },
                  icon: const Icon(
                    Icons.close,
                  ),
                ),
              ],
            ),
          )
        : Container();
  }
}
