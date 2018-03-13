//
//  EmbeddedViewController.swift
//  SpratUIKitLeitmotifs
//
//  Created by Ben Spratling on 5/3/17.
//  Copyright © 2017 benspratling.com. All rights reserved.
//

import Foundation
import UIKit

///sets up another view controller to fill its view, forwards all status bar preferences to it
@objc open class EmbeddingViewController : UIViewController {
	
	
	@objc public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		self.definesPresentationContext = true
	}
	
	@objc public required init?(coder aDecoder: NSCoder) {
		//TODO: write me
		super.init(coder: aDecoder)
		self.definesPresentationContext = true

	}
	
	@objc open private(set) var embeddedViewController:UIViewController?
	
	@objc open func setEmbeddedViewController(_ viewController:UIViewController?, animations:UIViewAnimationOptions) {
		if viewController === embeddedViewController {
			return
		}
		let oldVC = embeddedViewController
		embeddedViewController?.willMove(toParentViewController: nil)
		embeddedViewController = viewController
		
		guard let nextVC = viewController else {
			oldVC?.view.removeFromSuperview()
			oldVC?.removeFromParentViewController()
			self.setNeedsStatusBarAppearanceUpdate()
			return
		}
		addChildViewController(nextVC)
		//if !isViewLoaded { return }
		nextVC.view.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(nextVC.view)
		/-nextVC.view-/
		|-nextVC.view-|
		guard let originalVC = oldVC else {
			nextVC.didMove(toParentViewController: self)
			self.setNeedsStatusBarAppearanceUpdate()
			return
		}
		originalVC.willMove(toParentViewController: nil)
		
		let completion = {
			originalVC.view.removeFromSuperview()
			originalVC.removeFromParentViewController()
			nextVC.didMove(toParentViewController: self)
		}
		
		if animations.contains(.transitionCrossDissolve) {
			nextVC.view.alpha = 0.0
			UIView.animate(withDuration: 0.5, animations: {
				nextVC.view.alpha = 1.0
				self.setNeedsStatusBarAppearanceUpdate()
			}, completion:{ _ in
				completion()
			})
		} else {
			self.setNeedsStatusBarAppearanceUpdate()
			completion()
		}
	}
	
	@objc open override var childViewControllerForStatusBarStyle: UIViewController? {
		return embeddedViewController?.childViewControllerForStatusBarStyle ?? embeddedViewController
	}
	
	@objc open override var childViewControllerForStatusBarHidden: UIViewController? {
		return embeddedViewController?.childViewControllerForStatusBarHidden ?? embeddedViewController
	}
	
	@objc open override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
		return embeddedViewController?.preferredStatusBarUpdateAnimation ?? .fade
	}
	
	@objc open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
		return embeddedViewController?.supportedInterfaceOrientations ?? .all
	}
	
	@objc open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
		return embeddedViewController?.preferredInterfaceOrientationForPresentation ?? .portrait
	}
	
}
