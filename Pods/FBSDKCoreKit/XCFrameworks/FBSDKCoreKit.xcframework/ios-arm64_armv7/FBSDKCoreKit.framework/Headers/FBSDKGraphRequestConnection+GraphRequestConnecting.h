/*
 * Copyright (c) Facebook, Inc. and its affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <Foundation/Foundation.h>

#import <FBSDKCoreKit/FBSDKGraphRequestConnecting.h>

NS_ASSUME_NONNULL_BEGIN

// Default conformance to the FBSDKGraphRequestConnecting protocol
@interface FBSDKGraphRequestConnection (ConnectionProviding) <FBSDKGraphRequestConnecting>
@end

NS_ASSUME_NONNULL_END
