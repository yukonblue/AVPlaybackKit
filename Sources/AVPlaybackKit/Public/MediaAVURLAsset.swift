//
//  MediaAVURLAsset.swift
//  AVPlaybackKit
//
//  Created by yukonblue on 2022-09-15.
//

import AVFoundation
import Combine

public enum MediaAssetStatus {

    case success
    case failure(error: Error)
}

public struct MediaAVURLAsset: MediaAssetProtocol {

    let asset: AVURLAsset

    let subject: PassthroughSubject<(asset: AVAsset, tracks: [AVAssetTrack]), Error>
    
    public init(url: URL) {
        self.init(url: url, options: [
            AVURLAssetAllowsCellularAccessKey: true,
            AVURLAssetAllowsConstrainedNetworkAccessKey: true,
            AVURLAssetAllowsExpensiveNetworkAccessKey: true,
            AVURLAssetPreferPreciseDurationAndTimingKey: false
        ])
    }

    init(url: URL, options: [String:Any]) {
        asset = AVURLAsset(url: url, options: [
            AVURLAssetAllowsCellularAccessKey: true,
            AVURLAssetAllowsConstrainedNetworkAccessKey: true,
            AVURLAssetAllowsExpensiveNetworkAccessKey: true,
            AVURLAssetPreferPreciseDurationAndTimingKey: false
        ])
        self.subject = PassthroughSubject<(asset: AVAsset, tracks: [AVAssetTrack]), Error>()
    }

    public func loadAsset() -> AnyPublisher<(asset: AVAsset, tracks: [AVAssetTrack]), Error> {
        // https://developer.apple.com/documentation/avfoundation/media_assets/loading_media_data_asynchronously
        self.asset.loadTracks(withMediaType: .audio, completionHandler: { tracks, error in
            if let tracks = tracks, error == nil {
                self.subject.send((asset: self.asset, tracks: tracks))
                self.subject.send(completion: .finished)
            } else if let nsError = error as? NSError {
//                Logging.by(category: .player).error("Encountered error while loading tracks for player item: \(nsError)")
                self.subject.send(completion: .failure(nsError))
            }
        })

        return self.subject.eraseToAnyPublisher()
    }
}
