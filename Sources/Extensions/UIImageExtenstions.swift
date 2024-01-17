//
//  UIImageExtensions.swift
//  
//
//  Created by Miniakhmetov Eduard on 17.01.2024.
//

import UIKit

internal extension UIImage {
    
    var hasAlpha -> Bool {
        switch self.cgImage?.alphaInfo {
        case .first, .last, .premultipliedFirst, .premultipliedLast:
            return true
        default:
            return false
        }
    }
    
    func croppedImageWith(_ frame: CGRect, angle: Int, circular: Bool) -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.opaque = !self.hasAlpha && !circular
        format.scale = self.scale
        let renderer = UIGraphicsImageRenderer(size: .zero, format: format)
        let croppedImage = renderer.image { context in
            if circular {
                context.cgContext.addEllipse(in: CGRect(origin: .zero, size: frame.size))
                context.cgContext.clip()
            }
            
            //To conserve memory in not needing to completely re-render the image re-rotated,
            //map the image to a view and then use Core Animation to manipulate its rotation
            if angle != 0 {
                let imageView = UIImageView(image: self)
                imageView.layer.minificationFilter = .nearest
                imageView.layer.magnificationFilter = .nearest
                imageView.transform = CGAffineTransformRotate(
                    .identity,
                    CGFloat(angle) * (CGFloat.pi / 180)
                )
                let rotatedRect = CGRectApplyAffineTransform(imageView.bounds, imageView.transform)
                let containerView = UIView(frame: CGRect(origin: .zero, size: rotatedRect.size))
                containerView.addSubview(imageView)
                imageView.center = containerView.center
                context.cgContext.translateBy(x: -frame.origin.x, y: -frame.origin.y)
                containerView.layer.render(in: context.cgContext)
            } else {
                context.cgContext.translateBy(x: -frame.origin.x, y: -frame.origin.y)
                self.draw(at: .zero)
            }
        }
        
        if let cgImage = croppedImage.cgImage {
            return UIImage(cgImage: cgImage, scale: self.scale, orientation: .up)
        } else {
            return croppedImage
        }
    }
}
