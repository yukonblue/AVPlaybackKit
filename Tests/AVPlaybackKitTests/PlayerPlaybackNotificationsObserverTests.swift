//
//  PlayerPlaybackNotificationsObserverTests.swift
//  AVPlaybackKitTests
//
//  Created by yukonblue on 07/10/2022.
//

import Foundation
import AVFoundation
import Combine

import XCTest
@testable import AVPlaybackKit

class PlayerPlaybackNotificationsObserverTests: XCTestCase {

    var assetURL: URL!
    var cancellable: AnyCancellable!

    override func setUpWithError() throws {
        self.assetURL = TestHelper().bundleUrl(forResource: "sample-3s", withExtension: "mp3")
    }

    func testAVPlayerItemDidPlayToEndTimeNotificationDeliveredOnSuccessfulFullPlayback() throws {
        let player = AVPlayer(url: self.assetURL)

        let observer = PlayerPlaybackNotificationsObserver(player: player)

        let expectation = XCTestExpectation(description: "Notification delivered")

        self.cancellable = observer.publisher.sink { playbackNotification in
            if case .playedToEnd = playbackNotification.status {
                expectation.fulfill()
            }
        }

        let queue = OperationQueue()
        queue.addOperation({
            player.play()
        })

        queue.waitUntilAllOperationsAreFinished()

        wait(for: [expectation], timeout: 5)
    }
}
