//
//  MediaPlayerRemoteCommandObserver.swift
//  AVPlaybackKit
//
//  Created by yukonblue on 2022-09-15.
//

import Foundation
import Combine
import MediaPlayer

public class MediaPlayerRemoteCommandObserver {

    public typealias PublisherType = AnyPublisher<MediaPlayerCommand, Never>

    public var publisher: PublisherType {
        subject.eraseToAnyPublisher()
    }

    let mediaRemoteCommandCenter: MPRemoteCommandCenter

    let subject = PassthroughSubject<MediaPlayerCommand, Never>()

    public init(mediaRemoteCommandCenter: MPRemoteCommandCenter) {
        self.mediaRemoteCommandCenter = mediaRemoteCommandCenter

        self.mediaRemoteCommandCenter.playCommand.addTarget { [unowned self] event in
            self.subject.send(.play)
            return .success
        }

        self.mediaRemoteCommandCenter.pauseCommand.addTarget { [unowned self] event in
            self.subject.send(.pause)
            return .success
        }

        self.mediaRemoteCommandCenter.stopCommand.addTarget { [unowned self] event in
            self.subject.send(.stop)
            return .success
        }

        self.mediaRemoteCommandCenter.nextTrackCommand.addTarget { [unowned self] event in
            self.subject.send(.nextTrack)
            return .success
        }
    }
}
