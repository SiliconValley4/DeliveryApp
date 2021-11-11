//
//  STPError.swift
//  Stripe
//
//  Created by Saikat Chakrabarti on 11/4/12.
//
//

import Foundation

// These must line up with the codes in _stpobjc_STPError.swift.
/// Possible error code values for NSErrors with the `StripeDomain` domain
public enum STPErrorCode: Int {
    /// Trouble connecting to Stripe.
    case connectionError = 40
    /// Your request had invalid parameters.
    case invalidRequestError = 50
    /// General-purpose API error.
    case apiError = 60
    /// Something was wrong with the given card details.
    case cardError = 70
    /// The operation was cancelled.
    case cancellationError = 80
    /// The ephemeral key could not be decoded. Make sure your backend is sending
    /// the unmodified JSON of the ephemeral key to your app.
    /// https://stripe.com/docs/mobile/ios/standard#prepare-your-api
    case ephemeralKeyDecodingError = 1000
}

// MARK: - STPError

/// Top-level class for Stripe error constants.
public class STPError {
    // MARK: userInfo keys
    /// All Stripe iOS errors will be under this domain.
    public static let stripeDomain = "com.stripe.lib"

    /// A human-readable message providing more details about the error.
    /// For card errors, these messages can be shown to your users.
    /// - seealso: https://stripe.com/docs/api/errors#errors-message
    public static let errorMessageKey = "com.stripe.lib:ErrorMessageKey"
    /// An SDK-supplied "hint" that is intended to help you, the developer, fix the error
    public static let hintKey = "com.stripe.lib:hintKey"
    /// What went wrong with your STPCard (e.g., STPInvalidCVC. See below for full list).
    public static let cardErrorCodeKey = "com.stripe.lib:CardErrorCodeKey"
    /// Which parameter on the STPCard had an error (e.g., "cvc"). Useful for marking up the
    /// right UI element.
    public static let errorParameterKey = "com.stripe.lib:ErrorParameterKey"
    /// The error code returned by the Stripe API.
    /// - seealso: https://stripe.com/docs/api#errors-code
    /// - seealso: https://stripe.com/docs/error-codes
    public static let stripeErrorCodeKey = "com.stripe.lib:StripeErrorCodeKey"
    /// The error type returned by the Stripe API.
    /// - seealso: https://stripe.com/docs/api#errors-type
    public static let stripeErrorTypeKey = "com.stripe.lib:StripeErrorTypeKey"
    /// If the value of `userInfo[stripeErrorCodeKey]` is `STPError.cardDeclined`,
    /// the value for this key contains the decline code.
    /// - seealso: https://stripe.com/docs/declines/codes
    public static let stripeDeclineCodeKey = "com.stripe.lib:DeclineCodeKey"
}

/// NSError extensions for creating error objects from Stripe API responses.
extension NSError {
    @_spi(STP) public static func stp_error(
        fromStripeResponse jsonDictionary: [AnyHashable: Any]?, httpResponse: HTTPURLResponse?
    ) -> NSError? {
        guard let dict = (jsonDictionary as NSDictionary?),
            let errorDictionary = dict["error"] as? NSDictionary
        else {
            return nil
        }
        let errorType = errorDictionary["type"] as? String
        let errorParam = errorDictionary["param"] as? String
        let stripeErrorMessage = errorDictionary["message"] as? String
        let stripeErrorCode = errorDictionary["code"] as? String
        var code = 0

        var userInfo: [AnyHashable: Any] = [
            NSLocalizedDescriptionKey: self.stp_unexpectedErrorMessage()
        ]
        userInfo[STPError.stripeErrorCodeKey] = stripeErrorCode ?? ""
        userInfo[STPError.stripeErrorTypeKey] = errorType ?? ""
        if let errorParam = errorParam {
            userInfo[STPError.errorParameterKey] = URLEncoder.stringByReplacingSnakeCase(
                withCamelCase: errorParam)
        }
        if let stripeErrorMessage = stripeErrorMessage {
            userInfo[STPError.errorMessageKey] = stripeErrorMessage
            userInfo[STPError.hintKey] = ServerErrorMapper.mobileErrorMessage(from: stripeErrorMessage,
                                                                              httpResponse: httpResponse)
        } else {
            userInfo[STPError.errorMessageKey] =
                "Could not interpret the error response that was returned from Stripe."
        }
        if errorType == "api_error" {
            code = STPErrorCode.apiError.rawValue
        } else {
            if errorType == "invalid_request_error" {
                code = STPErrorCode.invalidRequestError.rawValue
            } else if errorType == "card_error" {
                code = STPErrorCode.cardError.rawValue
                userInfo[NSLocalizedDescriptionKey] = stripeErrorMessage  // see https://stripe.com/docs/api/errors#errors-message
            } else {
                code = STPErrorCode.apiError.rawValue
            }
            let codeMap = [
                "incorrect_number": [
                    "code": STPCardErrorCode.incorrectNumber.rawValue,
                    "message": self.stp_cardErrorInvalidNumberUserMessage(),
                ],
                "invalid_number": [
                    "code": STPCardErrorCode.invalidNumber.rawValue,
                    "message": self.stp_cardErrorInvalidNumberUserMessage(),
                ],
                "invalid_expiry_month": [
                    "code": STPCardErrorCode.invalidExpMonth.rawValue,
                    "message": self.stp_cardErrorInvalidExpMonthUserMessage(),
                ],
                "invalid_expiry_year": [
                    "code": STPCardErrorCode.invalidExpYear.rawValue,
                    "message": self.stp_cardErrorInvalidExpYearUserMessage(),
                ],
                "invalid_cvc": [
                    "code": STPCardErrorCode.invalidCVC.rawValue,
                    "message": self.stp_cardInvalidCVCUserMessage(),
                ],
                "expired_card": [
                    "code": STPCardErrorCode.expiredCard.rawValue,
                    "message": self.stp_cardErrorExpiredCardUserMessage(),
                ],
                "incorrect_cvc": [
                    "code": STPCardErrorCode.invalidCVC.rawValue,
                    "message": self.stp_cardInvalidCVCUserMessage(),
                ],
                "card_declined": [
                    "code": STPCardErrorCode.cardDeclined.rawValue,
                    "message": self.stp_cardErrorDeclinedUserMessage(),
                ],
                "processing_error": [
                    "code": STPCardErrorCode.processingError.rawValue,
                    "message": self.stp_cardErrorProcessingErrorUserMessage(),
                ],
                "incorrect_zip": [
                    "code": STPCardErrorCode.incorrectZip.rawValue
                ],
                "invalid_owner_name": [
                    "message": self.stp_invalidOwnerName,
                ],
                "invalid_bank_account_iban": [
                    "message": self.stp_invalidBankAccountIban,
                ],
            ]
            let codeMapEntry = codeMap[stripeErrorCode ?? ""]
            let cardErrorCode = codeMapEntry?["code"]
            let localizedMessage = codeMapEntry?["message"]
            if let cardErrorCode = cardErrorCode {
                if cardErrorCode == STPCardErrorCode.cardDeclined.rawValue,
                   let decline_code = errorDictionary["decline_code"] {
                    userInfo[STPError.stripeDeclineCodeKey] = decline_code
                }
                userInfo[STPError.cardErrorCodeKey] = cardErrorCode
            }
            if localizedMessage != nil {
                if let aCodeMapEntry = codeMapEntry?["message"] {
                    userInfo[NSLocalizedDescriptionKey] = aCodeMapEntry
                }
            }
        }

        // Hack (we should overhaul this file): some errors can be supplemented with better messages than the client-agnostic JSON returned
        if httpResponse?.statusCode == 401 && stripeErrorCode == nil {
            userInfo[STPError.errorMessageKey] =
                "No valid API key provided. Set `STPAPIClient.shared().publishableKey` to your publishable key, which you can find here: https://stripe.com/docs/keys"
        }

        return NSError(
            domain: STPError.stripeDomain, code: code, userInfo: userInfo as? [String: Any])
    }

    /// Creates an NSError object from a given Stripe API json response.
    /// - Parameter jsonDictionary: The root dictionary from the JSON response.
    /// - Returns: An NSError object with the error information from the JSON response,
    /// or nil if there was no error information included in the JSON dictionary.
    public static func stp_error(fromStripeResponse jsonDictionary: [AnyHashable: Any]?)
        -> NSError?
    {
        stp_error(fromStripeResponse: jsonDictionary, httpResponse: nil)
    }
}

// MARK: STPCardErrorCodeKeys -

/// Possible string values you may receive when there was an error tokenizing
/// a card. These values will come back in the error `userInfo` dictionary
/// under the `STPCardErrorCodeKey` key.
public enum STPCardErrorCode: String {
    /// The card number is not a valid credit card number.
    case invalidNumber = "com.stripe.lib:InvalidNumber"
    /// The card has an invalid expiration month.
    case invalidExpMonth = "com.stripe.lib:InvalidExpiryMonth"
    /// The card has an invalid expiration year.
    case invalidExpYear = "com.stripe.lib:InvalidExpiryYear"
    /// The card has an invalid CVC.
    case invalidCVC = "com.stripe.lib:InvalidCVC"
    /// The card number is incorrect.
    case incorrectNumber = "com.stripe.lib:IncorrectNumber"
    /// The card is expired.
    case expiredCard = "com.stripe.lib:ExpiredCard"
    /// The card was declined.
    case cardDeclined = "com.stripe.lib:CardDeclined"
    /// The card has an incorrect CVC.
    case incorrectCVC = "com.stripe.lib:IncorrectCVC"
    /// An error occured while processing this card.
    case processingError = "com.stripe.lib:ProcessingError"
    /// The postal code is incorrect.
    case incorrectZip = "com.stripe.lib:IncorrectZip"
}

@objc extension STPError {
    /// The card number is not a valid credit card number.
    @objc public static let invalidNumber = STPCardErrorCode.invalidNumber.rawValue
    /// The card has an invalid expiration month.
    @objc public static let invalidExpMonth = STPCardErrorCode.invalidExpMonth.rawValue
    /// The card has an invalid expiration year.
    @objc public static let invalidExpYear = STPCardErrorCode.invalidExpYear.rawValue
    /// The card has an invalid CVC.
    @objc public static let invalidCVC = STPCardErrorCode.invalidCVC.rawValue
    /// The card number is incorrect.
    @objc public static let incorrectNumber = STPCardErrorCode.incorrectNumber.rawValue
    /// The card is expired.
    @objc public static let expiredCard = STPCardErrorCode.expiredCard.rawValue
    /// The card was declined.
    @objc public static let cardDeclined = STPCardErrorCode.cardDeclined.rawValue
    /// An error occured while processing this card.
    @objc public static let processingError = STPCardErrorCode.processingError.rawValue
    /// The card has an incorrect CVC.
    @objc public static let incorrectCVC = STPCardErrorCode.incorrectCVC.rawValue
    /// The postal code is incorrect.
    @objc public static let incorrectZip = STPCardErrorCode.incorrectZip.rawValue
}
