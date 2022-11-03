//
//  MediaPlayerSession.swift
//  AVPlaybackKit
//
//  Created by yukonblue on 07/18/2022.
//

import Foundation
import AVFoundation
import MediaPlayer

public struct ControlCenterNowPlayingInfo {

    public let title: String
    public let author: String
    public let artwork: MPMediaItemArtwork

    public init(title: String, author: String, artwork: MPMediaItemArtwork) {
        self.title = title
        self.author = author
        self.artwork = artwork
    }
}

public protocol MediaPlayerSessionProtocol {

    func handleMediaPlaybackSessionStart() throws

    func handleMediaPlaybackSessionEnd() throws

    func setControlCenterNowPlayingInfo(_ playingInfo: ControlCenterNowPlayingInfo)

    func clearControlCenterNowPlayingInfo()

    func setControlCenterNextTrackCommandEnabled(_: Bool)

    func setControlCenterPlayPauseCommandEnabled(_: Bool)
}

public class MediaPlayerSession: MediaPlayerSessionProtocol {

    static public let shared = MediaPlayerSession()

    public func handleMediaPlaybackSessionStart() throws {
        try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: .default)
        try AVAudioSession.sharedInstance().setActive(true)
    }

    public func handleMediaPlaybackSessionEnd() throws {
        try AVAudioSession.sharedInstance().setActive(false)
    }

    public func setControlCenterNowPlayingInfo(_ playingInfo: ControlCenterNowPlayingInfo) {
        let nowPlayingInfoCenter = MPNowPlayingInfoCenter.default()
        var nowPlayingInfo = [String: Any]()

        nowPlayingInfo[MPMediaItemPropertyTitle] = playingInfo.title
        nowPlayingInfo[MPMediaItemPropertyArtist] = playingInfo.author
        nowPlayingInfo[MPMediaItemPropertyArtwork] = playingInfo.artwork

        nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo
    }

    public func clearControlCenterNowPlayingInfo() {
        let nowPlayingInfoCenter = MPNowPlayingInfoCenter.default()
        nowPlayingInfoCenter.nowPlayingInfo = [String: Any]()
    }

    public func setControlCenterNextTrackCommandEnabled(_ isEnabled: Bool) {
        MPRemoteCommandCenter.shared().nextTrackCommand.isEnabled = isEnabled
    }

    public func setControlCenterPlayPauseCommandEnabled(_ isEnabled: Bool) {
        MPRemoteCommandCenter.shared().togglePlayPauseCommand.isEnabled = isEnabled
        MPRemoteCommandCenter.shared().playCommand.isEnabled = isEnabled
        MPRemoteCommandCenter.shared().pauseCommand.isEnabled = isEnabled
    }
}
