/*
 * Copyright (c) 2015-2020 Sinch AB. All rights reserved.
 *
 * See LICENSE file for license terms and information.
 */

#import <Foundation/Foundation.h>
#import <CoreVideo/CVPixelBuffer.h>

/**
 * Video frame handler must adopt SINVideoFrameCallback protocol
 */
@protocol SINVideoFrameCallback <NSObject>

/**
 * Callback handler that can be used to post-process video frames.
 *
 * - IMPORTANT: The callback handler implementation must retain the
 * input CVPixelBuffer object using CVPixelBufferRetain, and release
 * it after invoking the completion handler, using CVPixelBufferRelease.
 *
 * - IMPORTANT: Invoking the `completionHandler` is mandatory.
 *
 * @param cvPixelBuffer The raw video frame buffer.
 * @param completionHandler Completion handler block, to be invoked with processed output pixel buffer as argument.
 */
- (void)onFrame:(CVPixelBufferRef)cvPixelBuffer completionHandler:(void (^)(CVPixelBufferRef))completionHandler;

@end
