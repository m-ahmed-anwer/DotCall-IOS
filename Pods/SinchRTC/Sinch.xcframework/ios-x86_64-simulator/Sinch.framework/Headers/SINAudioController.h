/*
 * Copyright (c) 2015-2020 Sinch AB. All rights reserved.
 *
 * See LICENSE file for license terms and information.
 */

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol SINAudioControllerDelegate;

#pragma mark - SINAudioController

/**
 * The SINAudioController provides methods for controlling audio related
 * functionality, e.g. enabling the speaker, muting the microphone, and
 * playing sound files.
 *
 *  - Important: Thread safety notes: All interaction should be done on main thread/main GCD queue.
 *
  ### Playing Sound Files
 *
 * The audio controller provides a convenience method
 * (startPlayingSoundFile:loop:) for playing sounds
 * that are related to a call, such as ringtones and busy tones.
 *
 * - Example:
 *
 * ```ObjC
 * 	id<SINAudioController> audio = [client audioController];
 * 	NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"ringtone" ofType:@"wav"];
 * 	NSError *error;
 *
 * 	[audio startPlayingSoundFile:soundPath loop:YES error:&error];
 * ```
 *
 * Applications that prefer to use their own code for playing sounds are free
 * to do so, but they should follow a few guidelines related to audio
 * session categories and audio session activation/deactivation (see
 * Sinch SDK User Guide for details).
 *
  #### Sound File Format
 *
 *  The sound file must be a mono (1 channel), 16-bit, uncompressed (PCM)
 * .wav file with a sample rate of 8kHz, 16kHz, or 32kHz.
 */
@protocol SINAudioController <NSObject>

/**
 * The object that acts as the delegate of the audio controller.
 *
 * The delegate object handles audio related state changes.
 *
 * @see `SINAudioControllerDelegate`
 */
@property (nonatomic, weak) id<SINAudioControllerDelegate> delegate;

/**
 * Use this method to override the default AVAudioSessionCategoryOptions that will
 * be set for the duration of phone calls. The selected options will be set for each
 * call starting after the method invocation.
 *
 * - Important: Thread safety notes: Should be called on main thread/main GCD queue.
 */
- (void)setAudioSessionCategoryOptions:(AVAudioSessionCategoryOptions)options;

/**
 * Mute the microphone.
 *
 * - Important: Thread safety notes: Should be called on main thread/main GCD queue.
 */
- (void)mute;

/**
 * Unmute the microphone.
 *
 * - Important: Thread safety notes: Should be called on main thread/main GCD queue.
 */
- (void)unmute;

/**
 * Route the call audio through the speaker.
 *
 * Note that if this method is invoked at a moment when no established call
 * exists, the current AVAudioSession configuration might be affected.
 *
 * This method will affect AVAudioSessionCategoryOptions during the calls even if
 * custom options have been set via -[SINAudioController setAudioSessionCategoryOptions:]
 *
 * @see `SINCallStateEstablished`
 * @see `-[SINCallDelegate callDidEstablish:]`
 * @see `-[SINAudioController setAudioSessionCategoryOptions:]`
 *
 * - Important: Thread safety notes: Should be called on main thread/main GCD queue.
 */
- (void)enableSpeaker;

/**
 * Route the call audio through the handset earpiece.
 *
 * Note that if this method is invoked at a moment when no established call
 * exists, the current AVAudioSession configuration might be affected.
 *
 * This method will affect AVAudioSessionCategoryOptions even if custom options have been set
 * via -[SINAudioController setAudioSessionCategoryOptions:]
 *
 * @see `SINCallStateEstablished`
 * @see `-[SINCallDelegate callDidEstablish:]`
 * @see `-[SINAudioController setAudioSessionCategoryOptions:]`
 *
 * - Important: Thread safety notes: Should be called on main thread/main GCD queue.
 */
- (void)disableSpeaker;

/**
 * Play a sound file, for the purpose of playing ringtones, etc.
 *
 * This is a simple convenience method for playing sounds associated with
 * a call, such as ringtones. It can only play one sound file at a time.
 *
 * Note that if your app integrates with CallKit, the preferred way to
 * specify the ringtone for an incoming audio call is via `ringtoneSound`
 * property of CXProviderConfiguration.
 *
 * For advanced audio, apps that use the SDK should implement their own
 * methods for playing sounds.
 *
 * Regardless of whether a sound is looping or not, a corresponding call
 * to the stopPlayingSoundFile method must be done at some point after each
 * invocation of this method.
 *
 * Invoking this method could modify AVAudioSession current configuration to
 * route audio to the speakers.
 *
 * The sound file must be a mono (1 channel), 16-bit, uncompressed (PCM)
 * .wav file with a sample rate of 8kHz, 16kHz, or 32kHz.
 *
 * @param path Full path for the sound file to play.
 *
 * @param loop Specifies whether the sound should loop or not.
 *
 * @param error Error object that describes the problem in case the method returns NO. It can
 *              be nil.
 *
 * @return A boolean value indicating whether the sound file was successfully located.
 *         If return value is NO, the value of error will contain more specific info about
 *         the failure.
 *
 * - Important: Thread safety notes: Should be called on main thread/main GCD queue.
 */
- (BOOL)startPlayingSoundFile:(NSString *)path loop:(BOOL)loop error:(NSError **)error;

/**
 * Stop playing the sound file.
 *
 * - Important: Thread safety notes: Should be called on main thread/main GCD queue.
 */
- (void)stopPlayingSoundFile;

/**
 * Configure the audio session for an incoming CallKit call.
 *
 * - Important: This method should be invoked before the CXAnswerCallAction is fulfilled.
 *
 * - Important: Thread safety notes: Should be called on main thread/main GCD queue.
 */
- (void)configureAudioSessionForCallKitCall;
@end

/**
 * The delegate of a SINAudioController object must adopt the
 * SINAudioControllerDelegate protocol. The methods handle audio
 * related state changes.
 *
 * - Important: Thread safety notes: Should be called on main thread/main GCD queue.
 */
@protocol SINAudioControllerDelegate <NSObject>
@optional

/**
 * Notifies the delegate that the microphone was muted.
 *
 * @param audioController The audio controller associated with this delegate.
 *
 * @see `SINAudioController`
 *
 * - Important: Thread safety notes: Should be called on main thread/main GCD queue.
 */
- (void)audioControllerMuted:(id<SINAudioController>)audioController;

/**
 * Notifies the delegate that the microphone was unmuted.
 *
 * @param audioController The audio controller associated with this delegate.
 *
 * @see `SINAudioController`
 *
 * - Important: Thread safety notes: Should be called on main thread/main GCD queue.
 */
- (void)audioControllerUnmuted:(id<SINAudioController>)audioController;

/**
 * Notifies the delegate that the speaker was enabled.
 *
 * @param audioController The audio controller associated with this delegate.
 *
 * @see `SINAudioController`
 *
 * - Important: Thread safety notes: Should be called on main thread/main GCD queue.
 */
- (void)audioControllerSpeakerEnabled:(id<SINAudioController>)audioController;

/**
 * Notifies the delegate that the speaker was disabled.
 *
 * @param audioController The audio controller associated with this delegate.
 *
 * @see `SINAudioController`
 *
 * - Important: Thread safety notes: Should be called on main thread/main GCD queue.
 */
- (void)audioControllerSpeakerDisabled:(id<SINAudioController>)audioController;

@end
