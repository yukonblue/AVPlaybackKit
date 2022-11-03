//
//  PlayerPeriodicTimeObserverTests.swift
//  AVPlaybackKitTests
//
//  Created by yukonblue on 08/31/2022.
//

import Foundation
import AVFoundation
import Combine

import XCTest
@testable import AVPlaybackKit

class PlayerPeriodicTimeObserverTests: XCTestCase {

    var assetURL: URL!
    var cancellable: AnyCancellable!

    override func setUpWithError() throws {
        self.assetURL = TestHelper().bundleUrl(forResource: "sample-3s", withExtension: "mp3")
    }

    func testPlaybackPeriodicTimeObserverPublisher() throws {
        let mediaAsset = AVAsset(url: self.assetURL)
        let playerItem = AVPlayerItem(asset: mediaAsset)
        let player = AVPlayer(playerItem: playerItem)

        let expectedDurationInSeconds = Int(mediaAsset.duration.seconds)

        XCTAssertGreaterThan(expectedDurationInSeconds, 0)

        let observer = PlayerPeriodicTimeObserver(player: player)

        let expectation = XCTestExpectation(description: "Notification delivered")

        // Set fulfillment count to match number of seconds of media asset's duration.
        // Media asset's duration is 3 seconds in this case.
        expectation.expectedFulfillmentCount = expectedDurationInSeconds

        self.cancellable = observer.publisher.sink { elapsedTime in
            expectation.fulfill()
        }

        let queue = OperationQueue()
        queue.addOperation({
            player.play()
        })

        queue.waitUntilAllOperationsAreFinished()

        wait(for: [expectation], timeout: 3.5)
    }
}
