//
//  StickerKitError.swift
//  StickerKit
//
//  Created by Rudd Fawcett on 12/25/20.
//

import Foundation

/// Errors for `StickerKit`.
public enum SKError: Error {
    /// The destination service isn't available.
    case notInstalled(StickerKit.SupportedService)
    /// The share failed for some reason.
    case shareFailed(StickerKit.SupportedService)
}

extension SKError: LocalizedError {
    
    public var localizedDescription: String {
        switch self {
        case .notInstalled(let service):
            return "\(service) is not installed on this device."
        case .shareFailed(let service):
            return "Unable to share sticker to \(service)."
        }
    }
}
