/*
 * Copyright (c) 2019 Sinch AB. All rights reserved.
 *
 * See LICENSE file for license terms and information.
 */

#import <Foundation/Foundation.h>
#import <Sinch/SINLogSeverity.h>

#pragma once

NS_ASSUME_NONNULL_BEGIN

/**
 * SINLogCallback defines a type of callback that could be used to receive debug logs from SDK
 */
typedef void (^SINLogCallback)(SINLogSeverity severity, NSString* area, NSString* message, NSDate* timestamp);

NS_ASSUME_NONNULL_END
