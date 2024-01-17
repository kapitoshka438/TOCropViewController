//
//  TOActivityCroppedImageProvider.swift
//  
//
//  Created by Miniakhmetov Eduard on 17.01.2024.
//

import UIKit

public final class TOActivityCroppedImageProvider: UIActivityItemProvider {
    
    public private(set) var image: UIImage
    public var cropFrame: CGRect?
    public var angle: Int
    public var circular: Bool
    
    private var croppedImage: UIImage!
    
    public required init(_ image: UIImage, cropFrame: CGRect?, angle: Int, circular: Bool) {
        self.image = image
        self.cropFrame = cropFrame
        self.angle = angle
        self.circular = circular
        super.init(placeholderItem: UIImage())
    }
    
    public override func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return UIImage()
    }
    
    public override func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return self.croppedImage
    }
    
    public override var item: Any {
        if self.angle == 0 && self.cropFrame?.equalTo(CGRect(origin: .zero, size: self.image.size)) == true {
            self.croppedImage = self.image
            return self.croppedImage
        }
        
        let image = self.image.croppedImage(withFrame: self.cropFrame, angle: self.angle, circularClip: self.circular)
        self.croppedImage = image
        return self.croppedImage
    }
}
