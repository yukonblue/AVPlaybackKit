//
//  PlayerPeriodicTimeObserver.swift
//  AVPlaybackKit
//
//  Created by yukonblue on 07/09/2022.
//

import Combine
import AVFoundation

public class PlayerPeriodicTimeObserver {

    // MARK: Private members

    private let player: AVPlayer

    private let subject: PassthroughSubject<CMTime, Never>

    private let queue = DispatchQueue.init(label: "com.yukonblue.AVPlaybackKit.AVPlayerQueue")

    private var observer: Any? = nil

    // MARK: Init and deinit

    public init(player: AVPlayer) {
        self.player = player

        self.subject = PassthroughSubject<CMTime, Never>()

        self.observer = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1.0, preferredTimescale: CMTimeScale(NSEC_PER_SEC)),
                                                            queue: self.queue,
                                                            using: { cmTime in
                                                                self.subject.send(cmTime)
                                                            })
    }

    deinit {
        if let observer = observer {
            self.player.removeTimeObserver(observer)
        }
    }

    // MARK: Publisher interface

    public var publisher: AnyPublisher<CMTime, Never> {
        subject.eraseToAnyPublisher()
    }
}
