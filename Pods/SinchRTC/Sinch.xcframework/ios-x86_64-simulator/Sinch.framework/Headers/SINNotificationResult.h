/*
 * Copyright (c) 2015-2020 Sinch AB. All rights reserved.
 *
 * See LICENSE file for license terms and information.
 */

#import <Foundation/Foundation.h>

@protocol SINCallNotificationResult;

/**
 * SINNotificationResult is used to indicate the result of `-[SINClient relayPushNotification:]` and
 * `+[SINManagedPush queryPushNotificationPayload:]`.
 *
 * - Important: Thread safety notes: All interaction should be done on main thread/main GCD queue.
 *
 * - Example:
 *
 * ```ObjC
 * id<SINNotificationResult> result = [self.client relayPushNotification:payload];
 *
 * if ([result isCall] && [result callResult].isTimedOut) {
 *     NSString* remoteUserId = [result callResult].remoteUserId;
 *     // Present UI indicating user missed the call.
 * }
 * ```
 *
 * It can be especially useful for scenarios which will not result in
 * the SINClientDelegate receiving any callback for an incoming call as a result
 * of calling the methods mentioned above. One such scenario is when a user
 * have been attempted to be reached, but not acted on the notification directly.
 * In that case, the notification result object can indicate that the
 * notification is too old (`isTimedOut`), and also contains the `remoteUserId` which can be
 * used for display purposes.
 *
 * @see `SINCallNotificationResult`
 */
@protocol SINNotificationResult <NSObject>

/** Indicates whether the notification is valid or not. */
@property (nonatomic, readonly, assign) BOOL isValid;

/** Indicates whether the notification is call related */
- (BOOL)isCall;

/** If the notification is call related (isCall is true), callResult contains the notification result */
- (id<SINCallNotificationResult>)callResult;

@end
