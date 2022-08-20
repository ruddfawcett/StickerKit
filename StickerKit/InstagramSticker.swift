//
//  InstagramSticker.swift
//  StickerKit
//
//  Created by Rudd Fawcett on 12/25/20.
//

import UIKit

/// An Instagram sticker object.
public struct InstagramSticker: StickerProtocol {
    
    // MARK: - Properties
    
    /// Data for an image asset in a supported format (JPG, PNG).
    /// Minimum dimensions 720x1280. Recommended image ratios 9:16 or 9:18.
    ///
    /// - Remark: Pasteboard key is com.instagram.sharedSticker.backgroundImage
    public var backgroundImage: UIImage?
    
    /// Data for an image asset in a supported format (JPG, PNG).
    /// Recommended dimensions: 640x480. This image will be placed as
    /// a sticker over the background.
    ///
    /// - Remark: Pasteboard key is com.instagram.sharedSticker.stickerImage
    public var stickerImage: UIImage
    
    /// A color value used in conjunction with the background layer
    /// bottom color value. If both values are the same, the background
    /// layer will be a solid color. If they differ, they will be used to
    /// generate a gradient instead.
    ///
    /// - Remark: Pasteboard key is com.instagram.sharedSticker.backgroundTopColor
    public var backgroundTopColor: UIColor?
    
    /// A color value used in conjunction with the background layer
    /// bottom color value. If both values are the same, the background
    /// layer will be a solid color. If they differ, they will be used to
    /// generate a gradient instead.
    ///
    /// - Remark: Pasteboard key is com.instagram.sharedSticker.backgroundBottomColor
    public var backgroundBottomColor: UIColor?
    
    /// A deep link URL to content in your app.
    /// If missing, the story will not include an attribution link.
    /// Use full URLs, including protocol (e.g. https://developers.facebok.com
    /// instead of developers.facebook.com)
    ///
    /// - Remark: com.instagram.sharedSticker.contentURL
    /// - Note: Renamed to conform to universal sticker.
    public var attachmentURL: URL?
    
    public var caption: String?
    
    // MARK: - Initializers
    
    /// Creates a new sticker for Instagram.
    ///
    /// - Parameter image: The sticker asset image.
    public init(stickerImage: UIImage) {
        self.stickerImage = stickerImage
    }
}
