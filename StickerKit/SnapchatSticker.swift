//
//  SnapchatSticker.swift
//  StickerKit
//
//  Created by Rudd Fawcett on 12/25/20.
//

import UIKit

/// A Snapchat sticker object.
public struct SnapchatSticker: StickerProtocol {
    
    // MARK: - Properties
    
    public var stickerImage: UIImage
    
    public var attachmentURL: URL?
     
    public var caption: String?
    
    // MARK: - Initializers
    
    /// Creates a new sticker for Snapchat.
    ///
    /// - Parameter image: The sticker asset image.
    public init(stickerImage: UIImage) {
        self.stickerImage = stickerImage
    }
}
