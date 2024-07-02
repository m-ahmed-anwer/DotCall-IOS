/*
 * Copyright (c) 2015-2020 Sinch AB. All rights reserved.
 *
 * See LICENSE file for license terms and information.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <Sinch/SINExport.h>
#import <Sinch/SINForwardDeclarations.h>

/**
 * The SINVideoController provides methods for controlling video related functionality.
 *
 * - Important: Thread safety notes: All interaction should be done on main thread/main GCD queue.
 */
@protocol SINVideoController <NSObject>

/**
 * Indicates the capture device position (front-facing or back-facing
 * camera) currently in use. This property may be set to to change
 * which capture device should be used.
 */
@property (nonatomic, assign, readwrite) AVCaptureDevicePosition captureDevicePosition;

/**
 * Automatically set/unset UIApplication.idleTimerDisabled when video capturing is started / stopped.
 * Default is YES.
 */
@property (nonatomic, assign, readwrite) BOOL disableIdleTimerOnCapturing;

/**
 * View into which the remote peer video stream is rendered.
 *
 * Use -[UIView contentMode] to control how the video frame is rendered.
 * (Note that only UIViewContentModeScaleAspectFit and UIViewContentModeScaleAspectFill will be respected)
 *
 * Use -[UIView backgroundColor] to specify color for potential "empty" regions
 * when UIViewContentModeScaleAspectFit is used.
 *
 * @see `SINUIViewFullscreenAdditions` (SINUIView+Fullscreen.h) for helpers to toggle full screen.
 *
 * - Important: Thread safety notes: Should be called on main thread/main GCD queue.
 */
- (UIView *)remoteView;

/**
 * View into which the locally captured video stream is rendered.
 *
 * Use -[UIView contentMode] to control how the video frame is rendered.
 * (Note that only UIViewContentModeScaleAspectFit and UIViewContentModeScaleAspectFill will be respected)
 *
 * Use -[UIView backgroundColor] to specify color for potential "empty" regions
 * when UIViewContentModeScaleAspectFit is used.
 *
 * @see `SINUIViewFullscreenAdditions` (SINUIView+Fullscreen.h) for helpers to toggle full screen.
 *
 * - Important: Thread safety notes: Should be called on main thread/main GCD queue.
 */
- (UIView *)localView;

/**
 * Set a callback for handling video frames for remote video streams.
 *
 * This callback can be used to process the video frame before it is rendered and displayed in a view.
 *
 * @param callback The callback object that will receive frames.
 *
 * @see `SINVideoFrameCallback`
 *
 * - Important: Thread safety notes: Should be called on main thread/main GCD queue.
 */
- (void)setRemoteVideoFrameCallback:(id<SINVideoFrameCallback>)callback;

/**
 * Set a callback for listening to video frames captured from the local camera.
 *
 * This callback can be used to process the locally captured video frame before
 * it is sent to the remote peer(s).
 *
 * @param callback The callback object that will receive frames.
 *
 * @see `SINVideoFrameCallback`
 *
 * - Important: Thread safety notes: Should be called on main thread/main GCD queue.
 */

- (void)setLocalVideoFrameCallback:(id<SINVideoFrameCallback>)callback;

@end

/**
 * If input position is front-facing camera, returns back-facing camera.
 * If input position is back-facing camera, returns front-facing camera.
 * If input is AVCaptureDevicePositionUnspecified, returns input.
 * @param position Capture position
 * @return New capture position
 */
SIN_EXPORT AVCaptureDevicePosition SINToggleCaptureDevicePosition(AVCaptureDevicePosition position);

/**
 * Convert a CVPixelBufferRef to an UIImage.
 * @param pixelBuffer Buffer from which to make an image
 * @return Prepared image
 */
SIN_EXPORT UIImage *SINUIImageFromPixelBuffer(CVPixelBufferRef pixelBuffer);
