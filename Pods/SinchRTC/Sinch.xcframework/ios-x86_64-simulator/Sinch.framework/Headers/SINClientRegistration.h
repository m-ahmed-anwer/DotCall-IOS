/*
 * Copyright (c) 2015-2020 Sinch AB. All rights reserved.
 *
 * See LICENSE file for license terms and information.
 */

#import <Foundation/Foundation.h>

/**
 * Callback object to be used to proceed in user registration process when
 * registration credentials for the user in question have been obtained.
 */
@protocol SINClientRegistration <NSObject>

/**
 * Proceed with user registration by providing a signed JWT (JSON Web Token).
 *
 * The JWT should contain the following JWT header parameters:
 *
 * - 'alg': 'HS256',
 * - 'kid': 'hkdfv1-{date}', where date is in UTC on the format YYYYMMDD.
 *
 *
 * The JWT should contain the following claims:
 *
 * - 'iss': '//rtc.sinch.com/applications/{applicationKey}'
 * - 'sub': '//rtc.sinch.com/applications/{applicationKey}/users/{userId}'
 * - 'iat': See https://tools.ietf.org/html/rfc7519#section-4.1.1
 * - 'exp': See https://tools.ietf.org/html/rfc7519#section-4.1.4
 * - 'nonce': A unique cryptographic nonce. E.g. a random string that
 *          has been generated using a cryptographically strong PRNG.
 *
 *  The JWT should be signed using a signing key derived from the Sinch
 *  Application Secret as follows. Given a function `HMAC256(key, message)`,
 *  a date-formatting function `FormatDate(date, format)`, and
 *  the current date as variable `now`, derive the signing key as
 *  follows:
 *
 *    signingKey = HMAC256(applicationSecret, UTF8-ENCODE(FormatDate(now, "YYYYMMDD")));
 *
 * @param jwt signed JWT (JSON Web Token)
 *
 * @see `SINClient`, `SINClientDelegate`
 *
 */
- (void)registerWithJWT:(NSString *)jwt;

/**
 * If the application fails to provide a signed user registration
 * token (JWT), it must notify the Sinch client via this method.
 *
 * Calling this method will have the effect that the client delegate will
 * receive a call to `-[SINClientDelegate clientDidFail:error:]`.
 *
 * @param error Error that prevented obtaining a user registration token (JWT).
 *
 * @see SINClient, SINClientDelegate
 *
 */
- (void)registerDidFail:(NSError *)error;

@end
