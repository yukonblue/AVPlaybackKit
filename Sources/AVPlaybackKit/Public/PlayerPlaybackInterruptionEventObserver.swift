//
//  PlayerPlaybackInterruptionEventObserver.swift
//  AVPlaybackKit
//
//  Created by yukonblue on 07/18/2022.
//

import Foundation
import Combine
import AVFoundation

public class PlayerPlaybackInterruptionEventObserver {

    // MARK: Public interfaces

    public enum Interruption {
        case resumePlay
        case toBePaused
    }

    public typealias PublisherType = AnyPublisher<Interruption, Never>

    public var publisher: PublisherType {
        subject.eraseToAnyPublisher()
    }

    // MARK: Private members

    private let subject: PassthroughSubject<Interruption, Never>

    // MARK: Init and deinit

    public init() {
        self.subject = PassthroughSubject<Interruption, Never>()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(Self.handleInterruption(notification:)),
                                               name: AVAudioSession.interruptionNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: Private methods

    @objc
    func handleInterruption(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let typeInt = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
                let type = AVAudioSession.InterruptionType(rawValue: typeInt) else {
                return
        }

        switch type {
        case .began:
            // Pause player
            subject.send(.toBePaused)
        case .ended:
            if let optionInt = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt {
                let options = AVAudioSession.InterruptionOptions(rawValue: optionInt)
                if options.contains(.shouldResume) {
                    // Resume player
                    subject.send(.resumePlay)
                }
            }
        @unknown default:
            break
        }
    }
}
