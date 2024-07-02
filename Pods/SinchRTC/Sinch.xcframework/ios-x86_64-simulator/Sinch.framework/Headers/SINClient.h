/*
 * Copyright (c) 2015-2020 Sinch AB. All rights reserved.
 *
 * See LICENSE file for license terms and information.
 */

#import <Foundation/Foundation.h>

#import <Sinch/SINForwardDeclarations.h>
#import <Sinch/SINExport.h>
#import <Sinch/SINAPSEnvironment.h>

#pragma mark - SINClient

/**
 * The SINClient is the Sinch SDK entry point.
 *
 * - Important: Thread safety notes: All interaction should be done on main thread/main GCD queue.
 *
 * It provides access to the feature classes in the Sinch SDK:
 * SINCallClient and SINAudioController. It is also used to configure
 * the user's and device's capabilities.
 *
  ### User Identification
 *
 * The user IDs that are used to identify users application specific.
 * - Important: user IDs are restricted to the character set
 * "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghjiklmnopqrstuvwxyz0123456789-_=",
 * and must be no longer than 255 bytes.
 *
 * - Example:
 * ```ObjC
 * 	// Instantiate a client object using the client factory.
 * 	NSError *error;
 * 	id<SINClient> client = [Sinch clientWithApplicationKey:@"<APPLICATION KEY>"
 * 	                                       environmentHost:@"ocra.api.sinch.com"
 * 	                                                userId:@"<USERID>"
 *  	                                               error:&error];
 *
 * 	// Enable push notifications
 * 	[client enableManagedPushNotifications];
 *
 * 	// Assign delegate. It is required to implement
 * 	// -[SINClientDelegate client:requiresRegistrationCredentials:]
 * 	// and provide a authorization token (JWT) to allow the User to register
 * 	// and the client to successfully start.
 * 	client.delegate = ... ;
 *
 * 	// Start the client
 * 	[client start];
 *
 * 	// Use SINCallClient to place and receive calls
 *  [client.callClient callUserWithId:...]
 * ```
 */
@protocol SINClient <NSObject>

/**
 * The object that acts as the delegate of the receiving client.
 *
 * The delegate object handles call state change events and must
 * adopt the SINClientDelegate protocol.
 *
 * @see `SINClientDelegate`
 */
@property (nonatomic, weak) id<SINClientDelegate> delegate;

/**
 * ID of the local user
 */
@property (nonatomic, readonly, copy) NSString *userId;

/**
 * Specify whether this device should receive incoming calls via push
 * notifications.
 *
 * Method should be called before calling `-[SINClient start]`.
 *
 * @param supported Enable or disable support for push notifications.
 *
 * @see `-[SINClient enableManagedPushNotifications]`
 *
 * - Important: Thread safety notes: Should be called on main thread/main GCD queue.
 */
- (void)setSupportPushNotifications:(BOOL)supported;

/**
 * Specify that the Sinch SDK and platform should take care of
 * sending the push notification to the other device via the appropriate
 * push notification gateway (i.e. Apple Push Notification Service for iOS devices,
 * and Firebase Cloud Messaging (FCM) for Android devices).
 *
 * (This require that you have uploaded your Apple Push Notification
 * Certificate(s) on the Sinch website)
 *
 * This method will internally also invoke `-[SINClient setSupportPushNotifications:YES]`
 *
 * Method should be called before calling `-[SINClient start]`.
 *
 * @see `-[SINClient registerPushNotificationDeviceToken:type:apsEnvironment:]`
 * @see `-[SINClient unregisterPushNotificationDeviceToken]`
 * @see `-[SINClient relayPushNotificationPayload:]`
 *
 * - Throws:
 *    - NSInternalInconsistencyException if the method is invoked after Sinch client has
 *    already been started
 *
 * - Important: Thread safety notes: Should be called on main thread/main GCD queue.
 */
- (void)enableManagedPushNotifications;

/**
 * Start client to enable the calling functionality.
 *
 * The client delegate should be set before calling the start method to
 * guarantee that delegate callbacks are received as expected.
 *
 * - Important: Thread safety notes: Should be called on main thread/main GCD queue.
 */
- (void)start;

/**
 * Terminate client when the Sinch functionality is no longer
 * needed. Note that this will terminate the client gracefully in the
 * sense that the client will even after this method is invoked be
 * allowed some time to complete currently pending tasks, for example
 * completing pending HTTP requests.
 *
 * It is strongly recommended to initiate the Sinch client, start it,
 * but not terminate it, during the lifetime of the running
 * application. The reason is that initializing and (re-)starting the
 * client is relatively resource intensive both in terms of CPU, as
 * well as there is potentially network requests involved in stopping
 * and re-starting the client.
 *
 * If desired to dispose the client, it is required to explicitly
 * invoke -[SINClient terminateGracefully] to relinquish certain
 * resources. This method should always be called before the
 * application code releases its last reference to the client.
 *
 * - Important: Thread safety notes: Should be called on main thread/main GCD queue.
 */
- (void)terminateGracefully;

/**
 * Check whether client is successfully started.
 *
 * @return A boolean value indicating whether the client has successfully
 *         started and is ready to perform calling functionality.
 *
 * - Important: Thread safety notes: Should be called on main thread/main GCD queue.
 */
- (BOOL)isStarted;

/**
 * Method used to forward a push notification dictionary when using "Sinch Managed Push Notifications"
 * (-[SINClient enableManagedPushNotifications])
 *
 * @return Value indicating initial inspection of push notification.
 *
 * @param userInfo VoIP push notification payload which was transferred with an Apple Push Notification.
 *
 * @see `SINNotificationResult`
 *
 * - Important: Thread safety notes: Should be called on main thread/main GCD queue.
 */
- (id<SINNotificationResult>)relayPushNotification:(NSDictionary *)userInfo;

/**
 * Register push notification device token for using "Sinch Managed Push Notifications".
 * The preferred way of enabling push notifications is to use `SINManagedPush` which
 * will automatically register the device token with the client, but this method can
 * also be used directly.
 *
 * @param deviceToken A token that identifies the device to APNs.
 * @param pushType SINPushType NSString constant, i.e. `SINPushTypeVoIP`
 * @param apsEnvironment Specification of which Apple Push Notification Service environment
 *                       the device token is bound to.
 * - Throws:
 *    - NSInternalInconsistencyException if support for push notification has not been previously
 *    enabled with -[SINClient setSupportPushNotifications:]
 *    - NSInvalidArgumentException if deviceToken or pushType are nil
 *
 * @see `SINAPSEnvironment`
 * @see `SINPushTypeVoIP`
 *
 * - Important: Thread safety notes: Should be called on main thread/main GCD queue.
 */
- (void)registerPushNotificationDeviceToken:(NSData *)deviceToken
                                       type:(NSString *)pushType
                             apsEnvironment:(SINAPSEnvironment)apsEnvironment;

/**
 * Unregister push notification device token when using "Sinch Managed Push Notifications"
 * Example if the user log out, the device token should be unregistered.
 *
 * - Important: Thread safety notes: Should be called on main thread/main GCD queue.
 */
- (void)unregisterPushNotificationDeviceToken;

/**
 * Specify a display name to be used when the Sinch client sends a push notification on
 * behalf of the local user (e.g. for an outgoing call).
 * This will only be used when using `-[SINClient enableManagedPushNotifications]`.
 *
 * @param displayName display name may at most be 255 bytes (UTF-8 encoded) long.
 * @param error Error object that describes the problem in case the method returns NO. It can
 *              be nil.
 *
 * @return A boolean value indicating whether the display name was set successfully.
 *         If return value is NO, the value of error will contain more specific info about
 *         the failure.
 *
 * - Important: Thread safety notes: Should be called on main thread/main GCD queue.
 */
- (BOOL)setPushNotificationDisplayName:(NSString *)displayName error:(NSError **)error;

/**
 * Returns the call client object for placing and receiving calls.
 *
 * - Important: Thread safety notes: Should be called on main thread/main GCD queue.
 */
- (id<SINCallClient>)callClient;

/**
 * Retrieve the interface for the audio controller, which provides access
 * to various audio related functionality, such as muting the microphone,
 * enabling the speaker, and playing ring tones.
 *
 * - Important: Thread safety notes: Should be called on main thread/main GCD queue.
 */
- (id<SINAudioController>)audioController;

/**
 * Retrieve the interface for the video controller, which provides
 * access to video related functionality.
 *
 * - Important: Thread safety notes: Should be called on main thread/main GCD queue.
 */
- (id<SINVideoController>)videoController;

@end

/**
 * The delegate of a SINClient object must adopt the SINClientDelegate
 * protocol. The required methods allows responding to client state
 * changes (start and stop), and providing user registration
 * credentials (JWT).
 */
@protocol SINClientDelegate <NSObject>

/**
 * Tells the delegate that it is required to provide additional registration
 * credentials.
 *
 * @param client The client informing the delegate that it requires additional registration details.
 *
 * @param registrationCallback The callback object that is to be called when registration credentials have been fetched.
 *
 * @see `SINClientRegistration`
 * @see `SINClient`
 *
 * - Important: Thread safety notes: Should be called on main thread/main GCD queue.
 */
- (void)client:(id<SINClient>)client requiresRegistrationCredentials:(id<SINClientRegistration>)registrationCallback;

/**
 * Tells the delegate that the client started the calling functionality.
 *
 * @param client The client informing the delegate that the calling
 *               functionality started successfully.
 *
 * @see `SINClient`
 *
 * - Important: Thread safety notes: Should be called on main thread/main GCD queue.
 */
- (void)clientDidStart:(id<SINClient>)client;

/**
 * Tells the delegate that a client failure occurred.
 *
 * @param client The client informing the delegate that it
 *               failed to start or start listening.
 *
 * @param error Error object that describes the problem.
 *
 * @see `SINClient`
 *
 * - Important: Thread safety notes: Should be called on main thread/main GCD queue.
 */
- (void)clientDidFail:(id<SINClient>)client error:(NSError *)error;

@end
