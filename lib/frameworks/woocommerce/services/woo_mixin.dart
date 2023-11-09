import '../../../common/config.dart';
import '../../../common/config/models/review/review_service_type.dart';
import '../../../modules/judge_me/judge_review_service.dart';
import '../../../services/index.dart';
import '../../../services/service_config.dart';
import '../../../services/wallet/tera_wallet_service_locator.dart'
    show TeraWalletServiceLocator;
import '../index.dart';
import 'woo_commerce.dart';
import 'woo_review_service.dart';
import 'woocommerce_api.dart';

mixin WooMixin on ConfigMixin {
  @override
  void configWoo(appConfig) {
    final domain = appConfig['url'];
    final consumerKey = appConfig['consumerKey'];
    final consumerSecret = appConfig['consumerSecret'];

    final wcApi = WooCommerceAPI(domain, consumerKey, consumerSecret);
    final reviewService = switch (kReviewConfig.service) {
      ReviewServiceType.native => WooReviewService(wcApi),
      ReviewServiceType.judge =>
        JudgeReviewService(apiKey: kReviewConfig.judgeConfig.apiKey),
    };

    final wooService = WooCommerceService(
      domain: appConfig['url'],
      blogDomain: appConfig['blog'],
      consumerSecret: appConfig['consumerSecret'],
      consumerKey: appConfig['consumerKey'],
      reviewService: reviewService,
    );
    TeraWalletServiceLocator.setup(appConfig['url']);
    api = wooService;
    widget = WooWidget();
  }
}
