//
//  GADMediatedNativeContentAd.h
//  Google Mobile Ads SDK
//
//  Copyright 2015 Google Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <GoogleMobileAds/GADNativeAdImage.h>
#import <GoogleMobileAds/GoogleMobileAdsDefines.h>
#import <GoogleMobileAds/Mediation/GADMediatedNativeAd.h>

NS_ASSUME_NONNULL_BEGIN

/// Provides methods used for constructing native content ads.
GAD_DEPRECATED_MSG_ATTRIBUTE("Use GADMediatedUnifiedNativeAd instead.")
@protocol GADMediatedNativeContentAd<GADMediatedNativeAd>

/// Primary text headline.
- (nullable NSString *)headline;

/// Secondary text.
- (nullable NSString *)body;

/// List of large images. Each object is an instance of GADNativeAdImage.
- (nullable NSArray *)images;

/// Small logo image.
- (nullable GADNativeAdImage *)logo;

/// Text that encourages user to take some action with the ad.
- (nullable NSString *)callToAction;

/// Identifies the advertiser. For example, the advertiser’s name or visible URL.
- (nullable NSString *)advertiser;

@optional

/// AdChoices view.
- (nullable UIView *)adChoicesView;

/// Media view.
- (nullable UIView *)mediaView;

/// Returns YES if the ad has video content.
- (BOOL)hasVideoContent;

@end

NS_ASSUME_NONNULL_END
