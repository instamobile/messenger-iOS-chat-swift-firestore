//
//  DFPInterstitial.h
//  Google Mobile Ads SDK
//
//  Copyright 2012 Google Inc. All rights reserved.
//

#import <GoogleMobileAds/DFPCustomRenderedInterstitialDelegate.h>
#import <GoogleMobileAds/GADAppEventDelegate.h>
#import <GoogleMobileAds/GADCorrelator.h>
#import <GoogleMobileAds/GADInterstitial.h>
#import <GoogleMobileAds/GoogleMobileAdsDefines.h>

NS_ASSUME_NONNULL_BEGIN

/// Google Ad Manager interstitial ad, a full-screen advertisement shown at natural
/// transition points in your application such as between game levels or news stories.
GAD_SUBCLASSING_RESTRICTED
@interface DFPInterstitial : GADInterstitial

/// Required value created on the Ad Manager website. Create a new ad unit for every unique
/// placement of an
/// ad in your application. Set this to the ID assigned for this placement. Ad units are important
/// for targeting and stats.
///
/// Example Ad Manager ad unit ID: @"/6499/example/interstitial"
@property(nonatomic, readonly, copy) NSString *adUnitID;

/// Correlator object for correlating this object to other ad objects.
@property(nonatomic, strong, nullable) GADCorrelator *correlator;

/// Optional delegate that is notified when creatives send app events.
@property(nonatomic, weak, nullable) id<GADAppEventDelegate> appEventDelegate;

/// Optional delegate object for custom rendered ads.
@property(nonatomic, weak, nullable)
    id<DFPCustomRenderedInterstitialDelegate> customRenderedInterstitialDelegate;

@end

NS_ASSUME_NONNULL_END
