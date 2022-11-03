//
//  MediaPlayerCommand.swift
//  AVPlaybackKit
//
//  Created by yukonblue on 11/03/22
//

import AVFoundation
import Combine

public protocol MediaAssetProtocol {

    init(url: URL)

    func loadAsset() -> AnyPublisher<(asset: AVAsset, tracks: [AVAssetTrack]), Error>
}
