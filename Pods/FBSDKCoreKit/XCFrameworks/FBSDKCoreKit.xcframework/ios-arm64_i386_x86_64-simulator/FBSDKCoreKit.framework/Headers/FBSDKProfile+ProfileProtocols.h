/*
 * Copyright (c) Facebook, Inc. and its affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

#if !TARGET_OS_TV

#import <Foundation/Foundation.h>

#import <FBSDKCoreKit/FBSDKProfile.h>
#import <FBSDKCoreKit/FBSDKProfileProtocols.h>

NS_ASSUME_NONNULL_BEGIN

// Default conformance to the profile providing protocol
@interface FBSDKProfile (ProfileProviding) <FBSDKProfileProviding>
@end

NS_ASSUME_NONNULL_END

#endif
