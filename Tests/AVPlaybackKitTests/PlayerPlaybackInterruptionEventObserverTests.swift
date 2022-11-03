//
//  PlayerPlaybackInterruptionEventObserverTests.swift
//  AVPlaybackKitTests
//
//  Created by yukonblue on 08/31/2022.
//

import Foundation
import AVFoundation
import Combine

import XCTest
@testable import AVPlaybackKit

class PlayerPlaybackInterruptionEventObserverTests: XCTestCase {

    var assetURL: URL!
    var cancellable: AnyCancellable!

    override func setUpWithError() throws {
        self.assetURL = TestHelper().bundleUrl(forResource: "sample-3s", withExtension: "mp3")
    }

    func testPlaybackPauseInterruptionObservation() throws {
        let player = AVPlayer(url: self.assetURL)

        let observer = PlayerPlaybackInterruptionEventObserver()

        let expectation = XCTestExpectation(description: "Playback pause interruption handled")

        self.cancellable = observer.publisher.sink { playbackInterruption in
            if case .toBePaused = playbackInterruption {
                expectation.fulfill()
            }
        }

        let queue = OperationQueue()
        queue.addOperation({
            player.play()
        })

        queue.waitUntilAllOperationsAreFinished()

        NotificationCenter.default.post(name: AVAudioSession.interruptionNotification,
                                        object: nil,
                                        userInfo: [
                                            AVAudioSessionInterruptionTypeKey: AVAudioSession.InterruptionType.began.rawValue
                                        ])

        wait(for: [expectation], timeout: 1.0)
    }

    func testPlaybackResumePlayInterruptionObservation() throws {
        let player = AVPlayer(url: self.assetURL)

        let observer = PlayerPlaybackInterruptionEventObserver()

        let expectation = XCTestExpectation(description: "Playback resume play interruption handled")

        self.cancellable = observer.publisher.sink { playbackInterruption in
            if case .resumePlay = playbackInterruption {
                expectation.fulfill()
            }
        }

        let queue = OperationQueue()
        queue.addOperation({
            player.play()
            player.pause()
        })

        queue.waitUntilAllOperationsAreFinished()

        NotificationCenter.default.post(name: AVAudioSession.interruptionNotification,
                                        object: nil,
                                        userInfo: [
                                            AVAudioSessionInterruptionTypeKey: AVAudioSession.InterruptionType.ended.rawValue,
                                            AVAudioSessionInterruptionOptionKey: AVAudioSession.InterruptionOptions.shouldResume.rawValue,
                                        ])

        wait(for: [expectation], timeout: 1.0)
    }
}
