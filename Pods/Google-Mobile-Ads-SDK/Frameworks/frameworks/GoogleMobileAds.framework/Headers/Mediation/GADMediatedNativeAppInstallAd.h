//
//  GADMediatedNativeAppInstallAd.h
//  Google Mobile Ads SDK
//
//  Copyright 2015 Google Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <GoogleMobileAds/GADNativeAdImage.h>
#import <GoogleMobileAds/GoogleMobileAdsDefines.h>
#import <GoogleMobileAds/Mediation/GADMediatedNativeAd.h>

NS_ASSUME_NONNULL_BEGIN

/// Provides methods used for constructing native app install ads. The adapter must return an object
/// conforming to this protocol for native app install requests.
GAD_DEPRECATED_MSG_ATTRIBUTE("Use GADMediatedUnifiedNativeAd instead.")
@protocol GADMediatedNativeAppInstallAd<GADMediatedNativeAd>

/// App title.
- (nullable NSString *)headline;

/// Array of GADNativeAdImage objects related to the advertised application.
- (nullable NSArray *)images;

/// App description.
- (nullable NSString *)body;

/// Application icon.
- (nullable GADNativeAdImage *)icon;

/// Text that encourages user to take some action with the ad. For example "Install".
- (nullable NSString *)callToAction;

/// App store rating (0 to 5).
- (nullable NSDecimalNumber *)starRating;

/// The app store name. For example, "App Store".
- (nullable NSString *)store;

/// String representation of the app's price.
- (nullable NSString *)price;

@optional

/// AdChoices view.
- (nullable UIView *)adChoicesView;

/// Media view.
- (nullable UIView *)mediaView;

/// Returns YES if the ad has video content.
- (BOOL)hasVideoContent;

@end

NS_ASSUME_NONNULL_END
