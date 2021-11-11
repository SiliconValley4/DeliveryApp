/*
 * Copyright (c) Facebook, Inc. and its affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "TargetConditionals.h"

#if !TARGET_OS_TV

 #import <UIKit/UIKit.h>

 #import <FBSDKCoreKit/FBSDKBridgeAPIProtocol.h>
 #import <FBSDKCoreKit/FBSDKBridgeAPIProtocolType.h>
 #import <FBSDKCoreKit/FBSDKBridgeAPIRequest.h>
 #import <FBSDKCoreKit/FBSDKBridgeAPIRequestOpening.h>
 #import <FBSDKCoreKit/FBSDKBridgeAPIResponse.h>
 #import <FBSDKCoreKit/FBSDKConstants.h>
 #import <FBSDKCoreKit/FBSDKURLOpening.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Internal Type exposed to facilitate transition to Swift.
 API Subject to change or removal without warning. Do not use.

 @warning UNSAFE - DO NOT USE
 */
typedef void (^FBSDKAuthenticationCompletionHandler)(NSURL *_Nullable callbackURL, NSError *_Nullable error);

/**
 Internal Type exposed to facilitate transition to Swift.
 API Subject to change or removal without warning. Do not use.

 @warning UNSAFE - DO NOT USE
 */
NS_SWIFT_NAME(BridgeAPI)
@interface FBSDKBridgeAPI : NSObject <FBSDKBridgeAPIRequestOpening>

@property (class, nonatomic, readonly, strong) FBSDKBridgeAPI *sharedInstance
NS_SWIFT_NAME(shared);
@property (nonatomic, readonly, getter = isActive) BOOL active;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (void)openURL:(NSURL *)url
         sender:(nullable id<FBSDKURLOpening>)sender
        handler:(FBSDKSuccessBlock)handler;

@end

NS_ASSUME_NONNULL_END

#endif
