
/*
 * Copyright (c) 2015-2020 Sinch AB. All rights reserved.
 *
 * See LICENSE file for license terms and information.
 */

#import <Foundation/Foundation.h>

#pragma once

/// Defines different types of log severity
typedef NS_ENUM(NSInteger, SINLogSeverity) {
  SINLogSeverityTrace = 0,
  SINLogSeverityInfo,
  SINLogSeverityWarn,
  SINLogSeverityCritical
};
