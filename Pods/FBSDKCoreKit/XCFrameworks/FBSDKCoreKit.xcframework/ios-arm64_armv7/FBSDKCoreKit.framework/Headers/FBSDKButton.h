/*
 * Copyright (c) Facebook, Inc. and its affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <UIKit/UIKit.h>

#import <FBSDKCoreKit/FBSDKImpressionTrackingButton.h>
@class FBSDKIcon;

NS_ASSUME_NONNULL_BEGIN

/**
  A base class for common SDK buttons.
 */
NS_SWIFT_NAME(FBButton)
@interface FBSDKButton : FBSDKImpressionTrackingButton

@property (nonatomic, readonly, getter = isImplicitlyDisabled) BOOL implicitlyDisabled;

- (void)checkImplicitlyDisabled;
- (void)configureWithIcon:(nullable FBSDKIcon *)icon
                    title:(nullable NSString *)title
          backgroundColor:(nullable UIColor *)backgroundColor
         highlightedColor:(nullable UIColor *)highlightedColor;

/**
 Internal method exposed to facilitate transition to Swift.
 API Subject to change or removal without warning. Do not use.

 @warning UNSAFE - DO NOT USE
 */
- (void) configureWithIcon:(nullable FBSDKIcon *)icon
                     title:(nullable NSString *)title
           backgroundColor:(nullable UIColor *)backgroundColor
          highlightedColor:(nullable UIColor *)highlightedColor
             selectedTitle:(nullable NSString *)selectedTitle
              selectedIcon:(nullable FBSDKIcon *)selectedIcon
             selectedColor:(nullable UIColor *)selectedColor
  selectedHighlightedColor:(nullable UIColor *)selectedHighlightedColor;

/**
 Internal method exposed to facilitate transition to Swift.
 API Subject to change or removal without warning. Do not use.

 @warning UNSAFE - DO NOT USE
 */
- (UIColor *)defaultBackgroundColor;

/**
 Internal method exposed to facilitate transition to Swift.
 API Subject to change or removal without warning. Do not use.

 @warning UNSAFE - DO NOT USE
 */
- (CGSize)sizeThatFits:(CGSize)size title:(NSString *)title;

/**
 Internal method exposed to facilitate transition to Swift.
 API Subject to change or removal without warning. Do not use.

 @warning UNSAFE - DO NOT USE
 */
- (CGSize)textSizeForText:(NSString *)text font:(UIFont *)font constrainedSize:(CGSize)constrainedSize lineBreakMode:(NSLineBreakMode)lineBreakMode;

/**
 Internal method exposed to facilitate transition to Swift.
 API Subject to change or removal without warning. Do not use.

 @warning UNSAFE - DO NOT USE
 */
- (void)logTapEventWithEventName:(NSString *)eventName
                      parameters:(nullable NSDictionary<NSString *, id> *)parameters;
@end

NS_ASSUME_NONNULL_END
