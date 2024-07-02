/*
 * Copyright (c) 2015-2020 Sinch AB. All rights reserved.
 *
 * See LICENSE file for license terms and information.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Sinch/SINExport.h>
#import <Sinch/SINAPSEnvironment.h>
#import <Sinch/SINForwardDeclarations.h>

/// VoIP push type constant
SIN_EXPORT SIN_EXTERN NSString *const SINPushTypeVoIP NS_AVAILABLE_IOS(8_0);

/// SINPushTypeKey, userInfo contains this key with value SINPushTypeVoIP
SIN_EXPORT SIN_EXTERN NSString *const SINPushTypeKey;

@protocol SINManagedPushDelegate;

/**
 * SINManagedPush is a helper class to manage push notification credentials
 * for VoIP Push Notifications.
 *
 * SINManagedPush acts as a facade for registering for device token for
 * VoIP notifications, and can also automatically register any received push
 * credentials to any active SINClient.
 *
 * SINManagedPush simplifies scenarios such as when receiving a device token
 * occur before creating a SINClient. In such a case, SINManagedPush can
 * automatically register the device token when the SINClient is created and
 * started.
 *
 * ```ObjC
 * 	-(BOOL)application:(UIApplication *)application
 * 	  didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
 * 	    self.push = [Sinch managedPushWithAPSEnvironment:SINAPSEnvironmentDevelopment]
 * 	    [self.push setDesiredPushType:SINPushTypeVoIP];
 * 	}
 * ```
 */

SIN_EXPORT
@interface SINManagedPush : NSObject

@property (nonatomic, readwrite, weak) id<SINManagedPushDelegate> delegate;

/**
 *  Requests registration of VoIP push notifications (similar to PushKit's -[PKPushRegistry setDesiredPushTypes:]).
 *
 *  - Note: It is strongly recommended to link PushKit framework and use SINPushTypeVoIP.
 *
 * @param pushType Desired SINPushType NSString constant, e.g. `SINPushTypeVoIP`
 *
 * - Important: Thread safety notes: Should be called on main thread/main GCD queue.
 */
- (void)setDesiredPushType:(NSString *)pushType;

/**
 * Specify a display name to be used when Sinch sends a push notification on
 * behalf of the local user (e.g. for an outgoing call). This method will
 * automatically invoke `-[SINClient setPushNotificationDisplayName:error:]` when a
 * new Sinch client is started.
 *
 * @param displayName Display name that will be injected into push notification alert message.
 *
 * Display name will be passed along in Firebase Cloud Messaging push notifications if a remote
 * user's device is an Android device.
 *
 * @see `SINClient`
 *
 * - Important: Thread safety notes: Should be called on main thread/main GCD queue.
 */
- (BOOL)setDisplayName:(NSString *)displayName error:(NSError **)error;

/**
 * This method may be used to indicate to the Sinch SDK that processing of a VoIP push payload is completed
 * in case it was for some reason not relayed to a SINClient instance.
 *
 * @param payload Push payload
 *
 * This will invoke the completion handler block provided to
 * -[PKPushRegistry pushRegistry:didReceiveIncomingPushWithPayload:forType:completion:].
 *
 * - Important: Thread safety notes: Should be called on main thread/main GCD queue.
 */
- (void)didCompleteProcessingPushPayload:(NSDictionary *)payload;

/**
 * Method used to extract call information contained in raw push notification payload.
 *
 * @return Result of initial inspection of push notification.
 *
 * @param payload Remote notification payload which was transferred with an Apple Push Notification.
 *
 * @see `SINNotificationResult`
 * @see `SINCallNotificationResult`
 *
 */
+ (id<SINNotificationResult>)queryPushNotificationPayload:(NSDictionary *)payload;

/**
 * Determine whether a push notification payload is carrying a Sinch payload.
 * @return true if sinch payload, false otherwise
 * @param payload Push payload
 *
 * - Important: Thread safety notes: Should be called on main thread/main GCD queue.
 */
+ (BOOL)isSinchPushPayload:(NSDictionary *)payload;

@end

/**
 * SINManagedPushDelegate
 */
@protocol SINManagedPushDelegate <NSObject>

/**
 * Tells the delegate that a push notification was received. The push notification is a VoIP push notification.
 *
 * @param managedPush managed push instance that received the push notification
 * @param payload The dictionary payload that the push notification carried.
 * @param pushType SINPushTypeVoIP
 */
- (void)managedPush:(SINManagedPush *)managedPush
    didReceiveIncomingPushWithPayload:(NSDictionary *)payload
                              forType:(NSString *)pushType;
@end
