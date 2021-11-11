/*
 * Copyright (c) Facebook, Inc. and its affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#if TARGET_OS_TV

// This is an unfortunate hack for Swift Package Manager support.
// SPM does not allow us to conditionally exclude Swift files for compilation by platform.
//
// So to support tvOS with SPM we need to use runtime availability checks in the Swift files.
// This means that even though the code in `LoginManager.swift` will never be run for tvOS
// targets, it still needs to be able to compile. Hence we need to declare it here.
//
// The way to fix this is to remove extensions of ObjC types in Swift.

@interface LoginManagerLoginResult : NSObject

@property (nullable, nonatomic, copy) FBSDKAccessToken *token;
@property (nullable, nonatomic, copy) FBSDKAuthenticationToken *authenticationToken;
@property (nonatomic, readonly) BOOL isCancelled;
@property (nonatomic, copy) NSSet<NSString *> *grantedPermissions;
@property (nonatomic, copy) NSSet<NSString *> *declinedPermissions;

@end

#else

@class FBSDKAccessToken;
@class FBSDKAuthenticationToken;

/**
  Describes the result of a login attempt.
 */
NS_SWIFT_NAME(LoginManagerLoginResult)
@interface FBSDKLoginManagerLoginResult : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

/**
  the access token.
 */
@property (nullable, nonatomic, copy) FBSDKAccessToken *token;

/**
  the authentication token.
 */
@property (nullable, nonatomic, copy) FBSDKAuthenticationToken *authenticationToken;

/**
  whether the login was cancelled by the user.
 */
@property (nonatomic, readonly) BOOL isCancelled;

/**
  the set of permissions granted by the user in the associated request.

 inspect the token's permissions set for a complete list.
 */
@property (nonatomic, copy) NSSet<NSString *> *grantedPermissions;

/**
  the set of permissions declined by the user in the associated request.

 inspect the token's permissions set for a complete list.
 */
@property (nonatomic, copy) NSSet<NSString *> *declinedPermissions;

/**
  Initializes a new instance.
 @param token the access token
 @param authenticationToken the authentication token
 @param isCancelled whether the login was cancelled by the user
 @param grantedPermissions the set of granted permissions
 @param declinedPermissions the set of declined permissions
 */
- (instancetype)initWithToken:(nullable FBSDKAccessToken *)token
          authenticationToken:(nullable FBSDKAuthenticationToken *)authenticationToken
                  isCancelled:(BOOL)isCancelled
           grantedPermissions:(NSSet<NSString *> *)grantedPermissions
          declinedPermissions:(NSSet<NSString *> *)declinedPermissions
  NS_DESIGNATED_INITIALIZER;
@end

#endif

NS_ASSUME_NONNULL_END
