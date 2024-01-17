//
//  TOCroppedImageAttributes.swift
//
//
//  Created by Miniakhmetov Eduard on 18.01.2024.
//

import UIKit

public final class TOCroppedImageAttributes {
    
    public private(set) var angle: Int
    public private(set) var croppedFrame: CGRect
    public private(set) var originalImageSize: CGSize
    
    public init(angle: Int, croppedFrame: CGRect, originalImageSize: CGSize) {
        self.angle = angle
        self.croppedFrame = croppedFrame
        self.originalImageSize = originalImageSize
    }
}
