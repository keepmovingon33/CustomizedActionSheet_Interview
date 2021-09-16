//
//  ActionSheetPresentationController.swift
//  CustomizedActionSheet
//
//  Created by Sky on 16/09/2021.
//

import Foundation
import UIKit

public class ActionSheetPresentationController: UIPresentationController {
    
    /// Public setable attributes
    
    /// Blur effect for the view displayed behind the drawer.
    public var blurEffectStyle: UIBlurEffect.Style = .dark
    
    /// The gap between the top of the modal and the top of the presenting
    /// view controller.
    public var topGap: CGFloat = 88
    
    /// The modal corners radius.
    /// The default value is 10 for a minimal yet elegant radius.
    public var cornerRadius: CGFloat = 10
    
    /// Set the modal's corners that should be rounded.
    /// Defaults are the two top corners.
    public var roundedCorners: UIRectCorner = [.topLeft, .topRight]
    
    /// Frame for the modally presented view.
    override public var frameOfPresentedViewInContainerView: CGRect {
        let width = UIDevice.current.userInterfaceIdiom == .phone ? self.containerView!.frame.width : 375
        return CGRect(x: 0, y: 0, width: width, height: self.containerView!.frame.height)
    }
    
    private lazy var blurEffectView: UIVisualEffectView = {
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: self.blurEffectStyle))
        blur.isUserInteractionEnabled = true
        blur.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blur.addGestureRecognizer(self.tapGestureRecognizer)
        return blur
    }()
    
    private lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: #selector(self.dismiss))
    }()
    
    private lazy var panGesture: UIPanGestureRecognizer = {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.drag(_:)))
        return pan
    }()
    
    /// Initializers
    /// Init with non required values - defaults are provided.
    public convenience init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, topGap: CGFloat) {
        self.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        self.topGap = topGap
    }
    
    /// Regular init.
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    override public func dismissalTransitionWillBegin() {
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            self.blurEffectView.alpha = 0
        }, completion: { (UIViewControllerTransitionCoordinatorContext) in
            self.blurEffectView.removeFromSuperview()
        })
    }
    
    override public func presentationTransitionWillBegin() {
        self.blurEffectView.alpha = 0
        // Add the blur effect view
        guard let presenterView = self.containerView else { return }
        presenterView.addSubview(self.blurEffectView)
        
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            self.blurEffectView.alpha = 0.5
        }, completion: { (UIViewControllerTransitionCoordinatorContext) in })
    }
    
    override public func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        guard let presentedView = self.presentedView else { return }
        
        presentedView.layer.masksToBounds = true
        presentedView.roundCorners(corners: self.roundedCorners, radius: self.cornerRadius)
        presentedView.addGestureRecognizer(self.panGesture)
    }
    
    override public func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        
        updateFrame()
    }
    
    @objc func dismiss() {
        self.presentedViewController.dismiss(animated: true, completion: nil)
    }
    
    @objc func drag(_ gesture:UIPanGestureRecognizer) {
        guard let presentedView = self.presentedView else { return }
        switch gesture.state {
        case .changed:
            self.presentingViewController.view.bringSubviewToFront(presentedView)
            let translation = gesture.translation(in: self.presentingViewController.view)
            let y = presentedView.center.y + translation.y
            
            let preventBounce = (y - (self.topGap / 2) > self.presentingViewController.view.center.y)
            // If bounce enabled or view went over the maximum y postion.
            if preventBounce {
                presentedView.center = CGPoint(x: self.presentedView!.center.x, y: y)
            }
            gesture.setTranslation(CGPoint.zero, in: self.presentingViewController.view)
        case .ended:
            let height = self.presentingViewController.view.frame.height
            let position = presentedView.convert(self.presentingViewController.view.frame, to: nil).origin.y
            if position < 0 || position < (1/4 * height) {
                // TOP SNAP POINT
                self.sendToMiddle()
            } else if (position < (height / 2)) || (position > (height / 2) && position < (height / 3)) {
                // MIDDLE SNAP POINT
                self.sendToMiddle()
            } else {
                // BOTTOM SNAP POINT
                self.dismiss()
            }
            gesture.setTranslation(CGPoint.zero, in: self.presentingViewController.view)
        default:
            return
        }
    }
    
    func sendToMiddle() {
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self = self else { return }
            self.updateFrame()
        }
    }
    
    private func updateFrame() {
        guard let presenterView = self.containerView else { return }
        guard let presentedView = self.presentedView else { return }
        
        // Set the frame and position of the modal
        presentedView.frame = self.frameOfPresentedViewInContainerView
        presentedView.frame.origin.x = (presenterView.frame.width - presentedView.frame.width) / 2
        presentedView.frame.origin.y = topGap
        
        // Set the blur effect frame, behind the modal
        self.blurEffectView.frame = presenterView.bounds
    }
}
