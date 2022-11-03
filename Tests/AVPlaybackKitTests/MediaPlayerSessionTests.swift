//
//  MediaPlayerSessionTests.swift
//  AVPlaybackKitTests
//
//  Created by yukonblue on 08/31/2022.
//

import Foundation
import MediaPlayer

import XCTest
@testable import AVPlaybackKit

class MediaPlayerSessionTests: XCTestCase {

    func testHandleMediaPlayerSessionStartAndEnd() throws {
        let session = MediaPlayerSession.shared

        try session.handleMediaPlaybackSessionStart()

        try session.handleMediaPlaybackSessionEnd()
    }

    func testSetAndClearControlCenterNowPlayingInfo() throws {
        let session = MediaPlayerSession.shared

        try session.handleMediaPlaybackSessionStart()

        let mediaItemArtwork = MPMediaItemArtwork(boundsSize: CGSize.zero,
                                                  requestHandler: { _ in
                                                    UIImage()
                                                })

        session.setControlCenterNowPlayingInfo(ControlCenterNowPlayingInfo(title: "Til The End",
                                                                           author: "MACO",
                                                                           artwork: mediaItemArtwork))

        session.clearControlCenterNowPlayingInfo()

        try session.handleMediaPlaybackSessionEnd()
    }
}
