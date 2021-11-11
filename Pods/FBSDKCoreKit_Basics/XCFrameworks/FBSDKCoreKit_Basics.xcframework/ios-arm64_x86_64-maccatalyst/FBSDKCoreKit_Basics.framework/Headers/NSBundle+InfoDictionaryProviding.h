/*
 * Copyright (c) Facebook, Inc. and its affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <Foundation/Foundation.h>

#import "FBSDKInfoDictionaryProviding.h"

NS_ASSUME_NONNULL_BEGIN

/// Default conformance to the info dictionary providing protocol
@interface NSBundle (InfoDictionaryProviding) <FBSDKInfoDictionaryProviding>
@end

NS_ASSUME_NONNULL_END
