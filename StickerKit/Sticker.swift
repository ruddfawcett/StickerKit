//
//  Sticker.swift
//  StickerKit
//
//  Created by Rudd Fawcett on 12/25/20.
//

import UIKit

/// Generic sticker protocol for all stickers.
public protocol StickerProtocol {
    /// The sticker image.
    var stickerImage: UIImage { get set }
    
    /// The URL for the sticker to go to.
    var attachmentURL: URL? { get set }
    
    /// The caption for the sticker.
    var caption: String? { get set }
    
    /// Initializer for a generic sticker object.
    ///
    /// - Parameter stickerImage: The sticker image.
    init(stickerImage: UIImage)
}

public struct Sticker: StickerProtocol {
    
    // MARK: - Properties
    
    public var stickerImage: UIImage
    public var attachmentURL: URL?
    public var caption: String?
    
    // MARK: - Initializers
    
    public init(stickerImage: UIImage) {
        self.stickerImage = stickerImage
    }
}
