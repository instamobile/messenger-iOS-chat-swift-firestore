//
//  GADCorrelatorAdLoaderOptions.h
//  Google Mobile Ads SDK
//
//  Copyright 2015 Google Inc. All rights reserved.
//

#import <GoogleMobileAds/GADAdLoader.h>
#import <GoogleMobileAds/GADCorrelator.h>
#import <GoogleMobileAds/GoogleMobileAdsDefines.h>

NS_ASSUME_NONNULL_BEGIN

/// Ad loader options for adding a correlator to a native ad request.
GAD_SUBCLASSING_RESTRICTED
@interface GADCorrelatorAdLoaderOptions : GADAdLoaderOptions

/// Correlator object for correlating ads loaded by an ad loader to other ad objects.
@property(nonatomic, strong, nullable) GADCorrelator *correlator;

@end

NS_ASSUME_NONNULL_END
