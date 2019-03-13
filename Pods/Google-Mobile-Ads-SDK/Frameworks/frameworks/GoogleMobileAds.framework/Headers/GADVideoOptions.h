//
//  GADVideoOptions.h
//  Google Mobile Ads SDK
//
//  Copyright 2016 Google Inc. All rights reserved.
//

#import <GoogleMobileAds/GADAdLoader.h>
#import <GoogleMobileAds/GoogleMobileAdsDefines.h>

NS_ASSUME_NONNULL_BEGIN

/// Video ad options.
GAD_SUBCLASSING_RESTRICTED
@interface GADVideoOptions : GADAdLoaderOptions

/// Indicates if videos should start muted. By default this property value is YES.
@property(nonatomic, assign) BOOL startMuted;

/// Indicates if the requested video should have custom controls enabled for play/pause/mute/unmute.
@property(nonatomic, assign) BOOL customControlsRequested;

/// Indicates whether the requested video should have the click to expand behavior.
@property(nonatomic, assign) BOOL clickToExpandRequested;

@end

NS_ASSUME_NONNULL_END
