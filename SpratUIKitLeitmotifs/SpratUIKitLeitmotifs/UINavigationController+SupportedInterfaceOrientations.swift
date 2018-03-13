//
//  UINavigationController+StatusBarUpdating.swift
//  SpratUIKitLeitmotifs
//
//  Created by Ben Spratling on 8/8/17.
//  Copyright © 2017 benspratling.com. All rights reserved.
//

import Foundation
import UIKit

///uses the top view controller's supported & preferred interface orientations
@objc open class TopOrientingNavigationController : UINavigationController {
	
	@objc open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
		return topViewController?.supportedInterfaceOrientations ?? .portrait
	}
	
	@objc open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
		return topViewController?.preferredInterfaceOrientationForPresentation ?? .portrait
	}
	
}
