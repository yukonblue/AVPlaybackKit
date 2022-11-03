//
//  PlayerPlaybackNotificationsObserver.swift
//  AVPlaybackKit
//
//  Created by yukonblue on 07/10/2022.
//

import Foundation
import Combine
import AVFoundation

public class PlayerPlaybackNotificationsObserver {

    // MARK: Public interfaces

    public enum Status {
        case playedToEnd
        case failedToPlayToEnd
        case stalled
    }

    public struct PlaybackNotification {
        public let status: Status
        public let item: AVPlayerItem?

        public init(status: Status, item: AVPlayerItem?) {
            self.status = status
            self.item = item
        }
    }

    public typealias PublisherType = AnyPublisher<PlaybackNotification, Never>

    public var publisher: PublisherType {
        subject.eraseToAnyPublisher()
    }

    // MARK: Private members

    private let player: AVPlayer

    private let subject: PassthroughSubject<PlaybackNotification, Never>

    // MARK: Init and deinit

    public init(player: AVPlayer) {
        self.player = player

        self.subject = PassthroughSubject<PlaybackNotification, Never>()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(Self.handlePlayerItemDidPlayToEndTimeNotification(_:)),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: player.currentItem)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(Self.handlePlayerItemFailedToPlayToEndTimeNotification(_:)),
                                               name: .AVPlayerItemFailedToPlayToEndTime,
                                               object: player.currentItem)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: Private methods

    @objc private func handlePlayerItemDidPlayToEndTimeNotification(_ notification: NSNotification) {
        let playerItem: AVPlayerItem? = (notification.object as? AVPlayerItem?) ?? nil
        subject.send(PlaybackNotification(status: .playedToEnd, item: playerItem))
    }

    @objc private func handlePlayerItemFailedToPlayToEndTimeNotification(_ notification: NSNotification) {
        let playerItem: AVPlayerItem? = (notification.object as? AVPlayerItem?) ?? nil
        subject.send(PlaybackNotification(status: .failedToPlayToEnd, item: playerItem))
    }
}
