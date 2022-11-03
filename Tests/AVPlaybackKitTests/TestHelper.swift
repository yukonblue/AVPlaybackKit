//
//  TestHelper.swift
//  AVPlaybackKitTests
//
//  Created by yukonblue on 08/31/2022.
//

import Foundation

class TestHelper {
    func bundleUrl(forResource fileName: String, withExtension ext: String) -> URL? {
        Bundle(for: type(of: self)).url(forResource: "AVPlaybackKit_AVPlaybackKitTests.bundle/\(fileName)", withExtension: ext)
    }
}
