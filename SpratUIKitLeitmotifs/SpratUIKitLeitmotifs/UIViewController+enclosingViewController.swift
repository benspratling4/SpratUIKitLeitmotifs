//
//  UIViewController+enclosingViewController.swift
//  SpratUIKitLeitmotifs
//
//  Created by Ben Spratling on 8/8/17.
//  Copyright © 2017 benspratling.com. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
	public func enclosingViewController<EnclosingType>()->EnclosingType? {
		if let foundType = self as? EnclosingType {
			return foundType
		} else {
			return (parent ?? presentingViewController)?.enclosingViewController()
		}
	}
}
