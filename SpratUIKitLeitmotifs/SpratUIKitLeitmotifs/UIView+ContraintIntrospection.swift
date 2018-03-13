//
//  UIView+ContraintIntrospection.swift
//  SpratUIKitLeitmotifs
//
//  Created by Ben Spratling on 8/8/17.
//  Copyright © 2017 benspratling.com. All rights reserved.
//

import Foundation
import UIKit


extension UIView {
	
	public func constraintsInvolving(_ view:AnyObject, attributes:Set<NSLayoutAttribute>? = nil)->[NSLayoutConstraint] {
		return constraints.filter({ (constraint) -> Bool in
			if constraint.firstItem === view {
				guard let attributes = attributes else {
					return true
				}
				return attributes.contains(constraint.firstAttribute)
			}
			if constraint.secondItem === view {
				guard let attributes = attributes else {
					return true
				}
				return attributes.contains(constraint.secondAttribute)
			}
			return false
		})
	}
	
}
