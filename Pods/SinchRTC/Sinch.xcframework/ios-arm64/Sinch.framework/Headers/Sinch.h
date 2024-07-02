/*
 * Copyright (c) 2015-2020 Sinch AB. All rights reserved.
 *
 * See LICENSE file for license terms and information.
 */

#import <Foundation/Foundation.h>

#import <Sinch/SINExport.h>

#import <Sinch/SINClient.h>
#import <Sinch/SINClientRegistration.h>

#import <Sinch/SINCallClient.h>
#import <Sinch/SINCall.h>
#import <Sinch/SINCallDetails.h>

#import <Sinch/SINAudioController.h>

#import <Sinch/SINVideoController.h>
#import <Sinch/SINUIView+Fullscreen.h>
#import <Sinch/SINVideoFrameCallback.h>

#import <Sinch/SINManagedPush.h>
#import <Sinch/SINAPSEnvironment.h>

#import <Sinch/SINNotificationResult.h>
#import <Sinch/SINCallNotificationResult.h>

#import <Sinch/SINLogSeverity.h>
#import <Sinch/SINLogCallback.h>
#import <Sinch/SINError.h>

/**
 * The Sinch class is used to instantiate a SINClient.
 *
 * This is the starting point for an app that wishes to use the Sinch SDK.
 *
 * To construct a SINClient, the required configuration parameters are:
 *
 *  - Application Key
 *  - Environment host (default is 'ocra.api.sinch.com')
 *  - UserID
 *
 * It is optional to specify:
 *
 *  - CLI (Calling-Line Identifier / Caller-ID) that will be used for calls
 *    terminated to PSTN (Publicly Switched Telephone Network).
 *
 * - Important: Thread safety notes: All interactions with SDK must be done on main thread/main GCD queue.
 */
SIN_EXPORT
@interface Sinch : NSObject

#pragma mark - Basic factory methods

// Sinch should not be used with alloc/init. Use the available class factory methods instead.
- (instancetype)init NS_UNAVAILABLE;

/**
 * Instantiate a new client.
 * The creation of the client may fail, as a result of input parameters being nil or not matching length criteria,
 * or because of internal failure when creating application support directory.
 * If any failure occurs, the returned value will be nil, and `error` parameter will contain relevant information.
 *
 * @return The newly instantiated client.
 *
 * @param applicationKey Application Key identifying the application.
 *
 * @param environmentHost Host for base URL for the Sinch RTC API environment to be used. E.g. 'ocra.api.sinch.com'
 *
 * @param userId ID of the local user.
 *
 * @param error Error object that describes the problem in case the method returns NO. It can
 *              be nil.
 *
 * @return a SINClient object, or nil if creation of SINClient failed.
 *         If return value is nil, the value of error will contain more specific info about
 *         the failure.
 *
 * @see `SINClient`
 * @see `SINClientRegistration`
 *
 * - Important: Thread safety notes: Should be called on main thread/main GCD queue.
 */

+ (id<SINClient>)clientWithApplicationKey:(NSString *)applicationKey
                          environmentHost:(NSString *)environmentHost
                                   userId:(NSString *)userId
                                    error:(NSError **)error;

#pragma mark - Factory methods with support for CLI / PSTN

/**
 * Instantiate a new client with a CLI (may be used for PSTN-terminated calls).
 * The creation of the client may fail, as a result of input parameters being nil or not matching length criteria,
 * or because of internal failure when creating application support directory.
 * If any failure occurs, the returned value will be nil, and `error` parameter will contain relevant information.
 *
 * @return The newly instantiated client.
 *
 * @param applicationKey Application key identifying the application.
 *
 * @param environmentHost Host for base URL for the Sinch RTC API environment to be used. E.g. 'ocra.api.sinch.com'
 *
 * @param userId ID of the local user.
 *
 * @param cli Caller-ID when terminating calls to PSTN. Must be a valid phone number.
 *
 * @param error Error object that describes the problem in case the method returns NO. It can
 *              be nil.
 *
 * @return a SINClient object, or nil if creation of SINClient failed.
 *         If return value is nil, the value of error will contain more specific info about
 *         the failure.
 *
 * @see `SINClient`
 * @see `SINClientRegistration`
 *
 * - Important: Thread safety notes: Should be called on main thread/main GCD queue.
 */

+ (id<SINClient>)clientWithApplicationKey:(NSString *)applicationKey
                          environmentHost:(NSString *)environmentHost
                                   userId:(NSString *)userId
                                      cli:(NSString *)cli
                                    error:(NSError **)error;

#pragma mark - Push Notifications

/**
 * Instantiate a new `SINManagedPush` instance to enable Push Notifications
 * managed by the Sinch SDK and platform. When using managed push notifications,
 * push notifications will be sent by the Sinch platform provided that Apple
 * Push Notification Certificates for your application have been uploaded to Sinch.
 *
 * @param apsEnvironment Specification of which Apple Push Notification Service environment
 *                       the application is bound to (via code signing and Provisioning Profile).
 *
 * @see `SINAPSEnvironment`
 *
 * - Important: Thread safety notes: Should be called on main thread/main GCD queue.
 */
+ (SINManagedPush *)managedPushWithAPSEnvironment:(SINAPSEnvironment)apsEnvironment;

#pragma mark - Miscellaneous

/**
 * Set a log callback block.
 *
 * The Sinch SDK will emit all it's logging by invoking the specified block.
 *
 * - Important: Only log messages with severity level `SINLogSeverityWarn`
 * or higher to the console in release builds, to avoid flooding the
 * device console with debugging messages.
 *
 * @param block log callback block. IMPORTANT: The block may be invoked on any thread / GCD queue.
 *
 * - Important: Thread safety notes: Should be called on main thread/main GCD queue.
 */
+ (void)setLogCallback:(SINLogCallback)block;

/**
 * Specify the data protection type (NSFileProtectionType) for the files created and used by the Sinch SDK.
 * If not set specifically, the files will inherit the data protection level defined in your Application.
 *
 * Method should be called before creation any instances of Sinch SDK classes, e.g. `SINClient`, `SINManagedPush` etc.
 *
 * @param type the data protection type applied to the files created by the Sinch SDK.
 *
 * - Important: Thread safety notes: Should be called on main thread/main GCD queue.
 */
+ (void)setDataProtectionType:(NSFileProtectionType)type;

/**
 * @return Sinch SDK version.
 */
+ (NSString *)versionString;

@end
