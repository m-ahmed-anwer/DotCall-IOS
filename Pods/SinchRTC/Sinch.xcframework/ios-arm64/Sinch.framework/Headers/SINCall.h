/*
 * Copyright (c) 2015-2020 Sinch AB. All rights reserved.
 *
 * See LICENSE file for license terms and information.
 */

#import <Foundation/Foundation.h>

@protocol SINCallDelegate;
@protocol SINCallDetails;

#pragma mark - Call State

/// Describes states call can be in
typedef NS_ENUM(NSInteger, SINCallState) {
  SINCallStateInitiating = 0,
  /// Only applicable to outgoing calls
  SINCallStateProgressing,
  SINCallStateEstablished,
  SINCallStateEnded
};

#pragma mark - Call Direction

/// Describes direction of the call
typedef NS_ENUM(NSInteger, SINCallDirection) { SINCallDirectionIncoming = 0, SINCallDirectionOutgoing };

#pragma mark - SINCall

/**
 * The SINCall represents a call.
 *
 * - Important: Thread safety notes: All interaction should be done on main thread/main GCD queue.
 */
@protocol SINCall <NSObject>

/**
 * The object that acts as the delegate of the call.
 *
 * The delegate object handles call state change events and must
 * adopt the SINCallDelegate protocol.
 *
 * @see `SINCallDelegate`
 */
@property (nonatomic, weak) id<SINCallDelegate> delegate;

/** String that is used as an identifier for this particular call. */
@property (nonatomic, readonly, copy) NSString *callId;

/** The id of the remote participant in the call. */
@property (nonatomic, readonly, copy) NSString *remoteUserId;

/**
 * Metadata about a call, such as start time.
 *
 * When a call has ended, the details object contains information
 * about the reason the call ended and error information if the
 * call ended unexpectedly.
 *
 * @see `SINCallDetails`
 */
@property (nonatomic, readonly, strong) id<SINCallDetails> details;

/**
 * The state the call is currently in. It may be one of the following:
 *
 *  - `SINCallStateInitiating`
 *  - `SINCallStateProgressing`
 *  - `SINCallStateEstablished`
 *  - `SINCallStateEnded`
 *
 * Initially, the call will be in the `SINCallStateInitiating` state.
 */
@property (nonatomic, readonly, assign) SINCallState state;

/**
 * The direction of the call. It may be one of the following:
 *
 *  - `SINCallDirectionIncoming`
 *  - `SINCallDirectionOutgoing`
 */
@property (nonatomic, readonly, assign) SINCallDirection direction;

/**
 * Call headers.
 *
 * Any application-defined call meta-data can be passed via headers.
 *
 * E.g. a human-readable "display name / username" can be convenient
 * to send as an application-defined header.
 *
 * - IMPORTANT: If a call is initially received via remote push
 * notifications, headers may not be immediately available due to
 * push payload size limitations (especially pre- iOS 8).
 * If it's not immediately available, it will be available after the
 * event callbacks `-[SINCallDelegate callDidProgress:]` or
 * `-[SINCallDelegate callDidEstablish:]` .
 *
 **/
@property (nonatomic, readonly) NSDictionary *headers;

/**
 * The user data property may be used to associate an arbitrary
 * contextual object with a particular instance of a call.
 */
@property (nonatomic, strong) id userInfo;

/** Answer an incoming call.
 *
 * - Important: Thread safety notes: Should be called on main thread/main GCD queue.
 */
- (void)answer;

/**
 * Ends the call, regardless of what state it is in. If the call is
 * an incoming call that has not yet been answered, the call will
 * be reported as denied to the caller.
 *
 * - Important: Thread safety notes: Should be called on main thread/main GCD queue.
 */
- (void)hangup;

/**
 * Sends a DTMF tone for tone dialing. (Only applicable for calls terminated
 * to PSTN (Publicly Switched Telephone Network)).
 *
 * @param key DTMF key must be in [0-9, #, *, A-D].
 *
 * @return YES if DTMF was sent correctly, NO otherwise
 *
 * - Important: Thread safety notes: Should be called on main thread/main GCD queue.
 */
- (BOOL)sendDTMF:(NSString *)key;

/**
 * Pause video track for this call
 *
 * - Important: Thread safety notes: Should be called on main thread/main GCD queue.
 */
- (void)pauseVideo;

/**
 * Start video track for this call
 *
 * - Important: Thread safety notes: Should be called on main thread/main GCD queue.
 */
- (void)resumeVideo;

@end

#pragma mark - SINCallDelegate

/**
 * The delegate of a SINCall object must adopt the SINCallDelegate
 * protocol. The required methods handle call state changes.
 *
  ### Call State Progression
 *
 * For a complete outgoing call, the delegate methods will be called
 * in the following order:
 *
 *  - `callDidProgress:`
 *  - `callDidEstablish:`
 *  - `callDidEnd:`
 *
 * For a complete incoming call, the delegate methods will be called
 * in the following order, after the client delegate method
 * `[SINClientDelegate client:didReceiveIncomingCall:]` has been called:
 *
 *  - `callDidEstablish:`
 *  - `callDidEnd:`
 *
 * - Important: Thread safety notes: Should be called on main thread/main GCD queue.
 */
@protocol SINCallDelegate <NSObject>

@optional

/**
 * Tells the delegate that the call ended.
 *
 * The call has entered the `SINCallStateEnded` state.
 *
 * @param call The call that ended.
 *
 * @see `SINCall`
 *
 * - Important: Thread safety notes: Should be called on main thread/main GCD queue.
 */
- (void)callDidEnd:(id<SINCall>)call;

/**
 * Tells the delegate that the outgoing call is progressing and a progress tone can be played.
 *
 * The call has entered the `SINCallStateProgressing` state.
 *
 * @param call The outgoing call to the client on the other end.
 *
 * @see `SINCall`
 *
 * - Important: Thread safety notes: Should be called on main thread/main GCD queue.
 */
- (void)callDidProgress:(id<SINCall>)call;

/**
 * Tells the delegate that the call was established.
 *
 * The call has entered the `SINCallStateEstablished` state.
 *
 * @param call The call that was established.
 *
 * @see `SINCall`
 *
 * - Important: Thread safety notes: Should be called on main thread/main GCD queue.
 */
- (void)callDidEstablish:(id<SINCall>)call;

/**
 * Tells the delegate that a video track has been added to the call.
 * (A delegate can use `SINVideoController` to manage rendering views.)
 *
 * @see `SINVideoController`
 *
 * - Important: Thread safety notes: Should be called on main thread/main GCD queue.
 */
- (void)callDidAddVideoTrack:(id<SINCall>)call;

/**
 * Tells the delegate that a video track has been paused in the call.
 * (A delegate can use `SINVideoController` to manage rendering views.)
 *
 * @see `SINVideoController`
 *
 * - Important: Thread safety notes: Should be called on main thread/main GCD queue.
 */
- (void)callDidPauseVideoTrack:(id<SINCall>)call;

/**
 * Tells the delegate that a video track has been resumed in the call.
 * (A delegate can use `SINVideoController` to manage rendering views.)
 *
 * @see `SINVideoController`
 *
 * - Important: Thread safety notes: Should be called on main thread/main GCD queue.
 */
- (void)callDidResumeVideoTrack:(id<SINCall>)call;

@end
