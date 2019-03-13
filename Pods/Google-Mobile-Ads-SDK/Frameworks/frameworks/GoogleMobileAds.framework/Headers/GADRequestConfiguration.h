//
//  GADRequestConfiguration.h
//  Google Mobile Ads SDK
//
//  Copyright 2018 Google Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <GoogleMobileAds/GoogleMobileAdsDefines.h>

/// Maximum ad content rating.
typedef NSString *GADMaxAdContentRating GAD_STRING_ENUM;

/// Rating for content suitable for general audiences, including families.
GAD_EXTERN GADMaxAdContentRating _Nonnull const GADMaxAdContentRatingGeneral;
/// Rating for content suitable for most audiences with parental guidance.
GAD_EXTERN GADMaxAdContentRating _Nonnull const GADMaxAdContentRatingParentalGuidance;
/// Rating for content suitable for teen and older audiences.
GAD_EXTERN GADMaxAdContentRating _Nonnull const GADMaxAdContentRatingTeen;
/// Rating for content suitable only for mature audiences.
GAD_EXTERN GADMaxAdContentRating _Nonnull const GADMaxAdContentRatingMatureAudience;

/// Request configuration. The settings in this class will apply to all ad requests.
GAD_SUBCLASSING_RESTRICTED
@interface GADRequestConfiguration : NSObject

/// The maximum ad content rating. All Google ads will have this content rating or lower.
@property(nonatomic, strong, nullable) GADMaxAdContentRating maxAdContentRating;

/// This method allows you to specify whether the user is under the age of consent. If you call this
/// method with YES, a TFUA parameter will be included in all ad requests. This parameter disables
/// personalized advertising, including remarketing, for all ad requests. It also disables requests
/// to third-party ad vendors, such as ad measurement pixels and third-party ad servers.
- (void)tagForUnderAgeOfConsent:(BOOL)underAgeOfConsent;

@end
