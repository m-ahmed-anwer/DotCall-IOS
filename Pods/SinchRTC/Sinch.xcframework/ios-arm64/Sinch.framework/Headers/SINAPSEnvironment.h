/*
 * Copyright (c) 2015-2020 Sinch AB. All rights reserved.
 *
 * See LICENSE file for license terms and information.
 */
#import <Foundation/Foundation.h>

#ifndef SIN_APS_ENVIRONMENT_H
#define SIN_APS_ENVIRONMENT_H

/**
 * SINAPSEnvironment is used to declare to which Apple Push Notification Service environment a device token is bound to.
 *
 * SINAPSEnvironment is used with `-[SINClient registerPushNotificationDeviceToken:type:apsEnvironment:]` or
 * `SINManagedPush`.
 *
 * - Example:
 *
 * An application which is codesigned and provisioned with a "Development" Provisioning Profile
 * will be tied to the APNs Development environment.
 *
 * An application which is codesigned and provisioned with a "Distribution" Provisioning Profile
 * will be tied to the APNs Production environment.
 *
 * See Apple documentation for further details:
 * https://developer.apple.com/documentation/usernotifications/registering_your_app_with_apns?language=objc
 * https://developer.apple.com/documentation/bundleresources/entitlements/aps-environment?language=objc
 */

typedef NS_ENUM(NSInteger, SINAPSEnvironment) {
  /// APNs Development environment
  SINAPSEnvironmentDevelopment = 1,
  /// APNs Production environment
  SINAPSEnvironmentProduction = 2
};

#endif  // SIN_APS_ENVIRONMENT_H
