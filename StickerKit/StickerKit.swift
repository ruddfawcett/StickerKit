//
//  StickerKit.swift
//  StickerKit
//
//  Created by Rudd Fawcett on 12/25/20.
//

import UIKit
import SCSDKCreativeKit
import MessageUI

public final class StickerKit: NSObject, MFMessageComposeViewControllerDelegate {

    // MARK: - Static Properties
    
    /// Singleton to use for `StickerKit`.
    static let shared = StickerKit()
    
    /// A reference to the `Snapchat` SDK.
    fileprivate lazy var snapchatSDK = {
        return SCSDKSnapAPI()
    }()
    
    // MARK: - Enums
    
    /// The supported sticker services.
    public enum SupportedService: String, CaseIterable {
        /// A service for Snapchat.
        case snapchat = "Snapchat"
        /// A service for Instagram.
        case instagram = "Instagram"
        /// A service for iMessage.
        case imessage = "iMessage"
    }
    
    // MARK: - Utiltiy
    
    /// Share sticker to supported service.
    ///
    /// - Parameters:
    ///   - sticker: The sticker to share.
    ///   - completion: Completion handler upon failure or success of the share.
    ///   
    /// - Returns: An optional `StickerKitError`.
    public func share(sticker: StickerProtocol, completion: ((SKError?) -> ())? = nil) {
        switch sticker {
        case let snapchatSticker as SnapchatSticker:
            shareToSnapchat(sticker: snapchatSticker, completion: completion)
        case let instagramSticker as InstagramSticker:
            shareToInstagram(sticker: instagramSticker, completion: completion)
        case let iMessageSticker as Sticker:
            shareToiMessage(sticker: iMessageSticker)
        default: return
        }
    }
    
    /// Shares a universal Sticker to the service in question
    ///
    /// - Parameters:
    ///   - sticker: The sticker with only two properties.
    ///   - service: The service with which to distribute the sticker.
    ///   - completion: Completion handler upon failure or success of the share.
    ///
    /// - Returns: An optional `StickerKitError`.
    public func share(sticker: Sticker, to service: StickerKit.SupportedService, completion: ((SKError?) -> ())? = nil) {
        switch service {
        case .snapchat:
            var snapchatSticker = SnapchatSticker(stickerImage: sticker.stickerImage)
            snapchatSticker.attachmentURL = sticker.attachmentURL
            shareToSnapchat(sticker: snapchatSticker, completion: completion)
            return
        case .instagram:
            var instagramSticker = InstagramSticker(stickerImage: sticker.stickerImage)
            instagramSticker.attachmentURL = sticker.attachmentURL
            instagramSticker.backgroundTopColor = UIColor(red: 0.043, green: 0.047, blue: 0.184, alpha: 1)
            instagramSticker.backgroundBottomColor = UIColor(red: 0.043, green: 0.047, blue: 0.184, alpha: 1)
            shareToInstagram(sticker: instagramSticker, completion: completion)
        default:
            shareToiMessage(sticker: sticker, completion: completion)
        }
    }
    /// Shares a sticker to Snapchat through the SCSDKCreativeKit.
    ///
    /// - Note: For more information, read:
    /// https://docs.snapchat.com/docs/tutorials/creative-kit/ios/
    ///
    /// - Parameters:
    ///   - sticker: The Instagram sticker to share.
    ///   - completion: Completion handler upon failure or success of the share.
    ///
    /// - Returns: An optional `StickerKitError`.
    private func shareToSnapchat(sticker: SnapchatSticker, completion: ((SKError?) -> ())? = nil) {
        let snapchatSticker = SCSDKSnapSticker(stickerImage: sticker.stickerImage)
        snapchatSticker.width = 350
        snapchatSticker.height = 350
        let snap = SCSDKNoSnapContent()
        snap.sticker = snapchatSticker
        snap.attachmentUrl = sticker.attachmentURL?.absoluteString
        //        snap.caption = ""

        snapchatSDK.startSending(snap, completionHandler: { (error) in
            if let completion = completion {
                if error != nil {
                    completion(.shareFailed(.snapchat))
                }
                else {
                    completion(nil)
                }
            }
        })
    }
    
    /// Shares a sticker to Insatgram through the UIApplication link.
    ///
    /// - Note: For more information, read:
    /// https://developers.facebook.com/docs/instagram/sharing-to-stories/
    ///
    /// - Parameters:
    ///   - sticker: The Instagram sticker to share.
    ///   - completion: Completion handler upon failure or success of the share.
    ///
    /// - Returns: An optional `StickerKitError`.
    private func shareToInstagram(sticker: InstagramSticker, completion: ((SKError?) -> ())? = nil) {
        guard let urlScheme = URL(string: "instagram-stories://share"), UIApplication.shared.canOpenURL(urlScheme) else {
            completion?(.notInstalled(.instagram))
            return
        }
    
        guard let stickerPNG = sticker.stickerImage.pngData() else {
            print("Invalid sticker image.")
            return
        }
        
        let pasteboardItems: [[String: Any]] = [[
            "com.instagram.sharedSticker.stickerImage": stickerPNG,
            "com.instagram.sharedSticker.backgroundTopColor": sticker.backgroundTopColor?.sk_hexValue ?? "",
            "com.instagram.sharedSticker.backgroundBottomColor": sticker.backgroundBottomColor?.sk_hexValue ?? "",
            "com.instagram.sharedSticker.contentURL": sticker.attachmentURL?.absoluteString ?? ""
        ]]
        
        let pasteboardOptions = [
            UIPasteboard.OptionsKey.expirationDate: Date().addingTimeInterval(60 * 5)
        ]
        
        UIPasteboard.general.setItems(pasteboardItems, options: pasteboardOptions)
        UIApplication.shared.open(urlScheme, options: [:], completionHandler: { (success) in
            completion?(success ? nil : .shareFailed(.instagram))
        })
    }
    
    private func shareToiMessage(sticker: Sticker, completion: ((SKError?) -> ())? = nil) {
        guard MFMessageComposeViewController.canSendAttachments(), MFMessageComposeViewController.canSendText() else {
            completion?(.shareFailed(.imessage))
            return
        }
        
        let messageController = MFMessageComposeViewController()
        messageController.body = sticker.caption ?? ""
        messageController.messageComposeDelegate = self
        
        if let stickerPNG = sticker.stickerImage.pngData() {
            messageController.addAttachmentData(stickerPNG, typeIdentifier: "png", filename: "saturn-yearbook.png")
            
            if let controller = UIApplication.sk_getTopViewController() {
                controller.present(messageController, animated: true, completion: {
                    completion?(nil)
                })
            }
        } else {
            completion?(.shareFailed(.imessage))
        }
    }
    
    // MARK: - MFMessageComposeViewControllerDelegate

    public func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension UIApplication {
    fileprivate class func sk_getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return sk_getTopViewController(base: nav.visibleViewController)
        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return sk_getTopViewController(base: selected)
        } else if let presented = base?.presentedViewController {
            return sk_getTopViewController(base: presented)
        }
        
        return base
    }
}

extension UIColor {
    fileprivate var sk_hexValue: String? {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb: Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}
