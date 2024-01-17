//
//  TOCropViewControllerTransitioning.swift
//  
//
//  Created by Miniakhmetov Eduard on 18.01.2024.
//

import UIKit

public final class TOCropViewControllerTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    /// Whether this animation is presenting or dismissing
    public var isDismissing: Bool
    
    /// The image that will be used in this animation
    public var image: UIImage?
    
    /// The origin view who's frame the image will be animated from
    public var fromView: UIView?
    
    /// The destination view who's frame the image will animate to
    public var toView: UIView?
    
    /// An origin frame that the image will be animated from
    public var fromFrame: CGRect
    
    /// A destination frame the image will aniamte to
    public var toFrame: CGRect
    
    /// A block called just before the transition to perform any last-second UI configuration
    public var prepareForTransitionHandler: (() -> Void)?
    
    public init(isDismissing: Bool, image: UIImage? = nil, fromView: UIView? = nil, toView: UIView? = nil, fromFrame: CGRect, toFrame: CGRect, prepareForTransitionHandler: ( () -> Void)? = nil) {
        self.isDismissing = isDismissing
        self.image = image
        self.fromView = fromView
        self.toView = toView
        self.fromFrame = fromFrame
        self.toFrame = toFrame
        self.prepareForTransitionHandler = prepareForTransitionHandler
    }
    
    /// Empties all of the properties in this object
    public func reset() {
        self.image = nil
        self.toView = nil
        self.fromView = nil
        self.fromFrame = .zero
        self.toFrame = .zero
        self.prepareForTransitionHandler = nil
    }
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.45
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // Get the master view where the animation takes place
        let containerView = transitionContext.containerView
        
        // Get the origin/destination view controllers
        let fromViewController = transitionContext.viewController(forKey: .from)
        let toViewController = transitionContext.viewController(forKey: .to)
        
        // Work out which one is the crop view controller
        let cropViewController = self.isDismissing ? fromViewController : toViewController
        let previousViewController = self.isDismissing ? toViewController : fromViewController
        
        // Just in case, match up the frame sizes
        cropViewController?.view.frame = containerView.bounds
        if self.isDismissing {
            previousViewController?.view.frame = containerView.bounds
        }
        
        // Add the view layers beforehand as this will trigger the initial sets of layouts
        if !self.isDismissing {
            if let cropViewController {
                containerView.addSubview(cropViewController.view)
                
                //Force a relayout now that the view is in the view hierarchy (so things like the safe area insets are now valid)
                cropViewController.viewDidLayoutSubviews()
            }
        } else {
            if let previousViewController, let cropViewController {
                containerView.insertSubview(previousViewController.view, belowSubview: cropViewController.view)
            }
        }
        
        // Perform any last UI updates now so we can potentially factor them into our calculations, but after
        // the container views have been set up
        if let prepareForTransitionHandler = self.prepareForTransitionHandler {
            prepareForTransitionHandler()
        }
        
        // If origin/destination views were supplied, use them to supplant the frames
        if !self.isDismissing, let fromView = self.fromView, let fromViewSuperview = fromView.superview {
            self.fromFrame = fromViewSuperview.convert(fromView.frame, to: containerView)
        } else if self.isDismissing, let toView = self.toView, let toViewSuperview = toView.superview {
            self.toFrame = toViewSuperview.convert(toView.frame, to: containerView)
        }
        
        var imageView: UIImageView?
        
        if self.isDismissing && !self.toFrame.isEmpty || !self.isDismissing && !self.fromFrame.isEmpty {
            imageView = UIImageView(image: self.image)
            if let imageView {
                imageView.frame = self.fromFrame
                containerView.addSubview(imageView)
                imageView.accessibilityIgnoresInvertColors = true
            }
        }
        
        cropViewController?.view.alpha = self.isDismissing ? 1 : 0
        if let imageView {
            UIView.animate(
                withDuration: self.transitionDuration(using: transitionContext),
                delay: 0,
                usingSpringWithDamping: 1,
                initialSpringVelocity: 0.7,
                options: [],
                animations: {
                    imageView.frame = self.toFrame
                },
                completion: { _ in
                    UIView.animate(
                        withDuration: 0.25,
                        animations: {
                            imageView.alpha = 0
                        },
                        completion: { _ in
                            imageView.removeFromSuperview()
                        })
                }
            )
        }
        
        UIView.animate(
            withDuration: self.transitionDuration(using: transitionContext),
            animations: {
                cropViewController?.view.alpha = self.isDismissing ? 0 : 1
            },
            completion: { _ in
                self.reset()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
    }
}
