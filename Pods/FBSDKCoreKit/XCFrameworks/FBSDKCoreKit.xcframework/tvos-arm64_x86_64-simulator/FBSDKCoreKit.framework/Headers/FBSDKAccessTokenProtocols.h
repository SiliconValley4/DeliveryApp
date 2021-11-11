/*
 * Copyright (c) Facebook, Inc. and its affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class FBSDKAccessToken;
@protocol FBSDKTokenCaching;

/**
 Internal Type exposed to facilitate transition to Swift.
 API Subject to change or removal without warning. Do not use.

 @warning UNSAFE - DO NOT USE
 */
NS_SWIFT_NAME(AccessTokenProviding)
@protocol FBSDKAccessTokenProviding

@property (class, nullable, nonatomic, readonly, copy) FBSDKAccessToken *currentAccessToken;
@property (class, nullable, nonatomic, copy) id<FBSDKTokenCaching> tokenCache;

@end

/**
 Internal Type exposed to facilitate transition to Swift.
 API Subject to change or removal without warning. Do not use.

 @warning UNSAFE - DO NOT USE
 */
NS_SWIFT_NAME(AccessTokenSetting)
@protocol FBSDKAccessTokenSetting

@property (class, nullable, nonatomic, copy) FBSDKAccessToken *currentAccessToken;

@end

NS_ASSUME_NONNULL_END
