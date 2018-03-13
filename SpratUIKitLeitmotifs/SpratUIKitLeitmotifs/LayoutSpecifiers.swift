//
//  LayoutSpecifiers.swift
//  SpratUIKitLeitmotifs
//
//  Created by Ben Spratling on 3/12/18.
//  Copyright © 2018 benspratling.com. All rights reserved.
//

import Foundation
import UIKit

prefix operator |-
prefix operator /-
postfix operator -|
postfix operator -/

///center horizontally
infix operator -|-

///center vertically
infix operator -/-

///same height
infix operator /-/

/// same width
infix operator |-|

public struct PartialLayoutSpecifier {
	public let axis:UILayoutConstraintAxis
	public let spacing:CGFloat
	public let priority:UILayoutPriority
}

public struct LayoutSpecifier {
	public let axis:UILayoutConstraintAxis
	public let spacing:CGFloat
	public let priority:UILayoutPriority
	public let view:UIView
}

public prefix func |-(rhs:CGFloat)->PartialLayoutSpecifier {
	return PartialLayoutSpecifier(axis: .horizontal, spacing: rhs, priority: UILayoutPriorityRequired)
}

public postfix func -|(lhs:CGFloat)->PartialLayoutSpecifier {
	return PartialLayoutSpecifier(axis: .horizontal, spacing: lhs, priority: UILayoutPriorityRequired)
}

public prefix func /-(rhs:CGFloat)->PartialLayoutSpecifier {
	return PartialLayoutSpecifier(axis: .vertical, spacing: rhs, priority: UILayoutPriorityRequired)
}

public postfix func -/(lhs:CGFloat)->PartialLayoutSpecifier {
	return PartialLayoutSpecifier(axis: .vertical, spacing: lhs, priority: UILayoutPriorityRequired)
}


@discardableResult public prefix func |-(rhs:UIView)->UIView {
	let constraint = NSLayoutConstraint(item: rhs, attribute: .leading, relatedBy:.equal, toItem: rhs.superview, attribute: .leading, multiplier: 1.0, constant: 0.0)
	rhs.translatesAutoresizingMaskIntoConstraints = false
	rhs.superview?.addConstraint(constraint)
	return rhs
}

@discardableResult public postfix func -|(lhs:UIView)->UIView {
	let constraint = NSLayoutConstraint(item: lhs, attribute: .trailing, relatedBy:.equal, toItem: lhs.superview, attribute: .trailing, multiplier: 1.0, constant: 0.0)
	lhs.translatesAutoresizingMaskIntoConstraints = false
	lhs.superview?.addConstraint(constraint)
	return lhs
}


@discardableResult public prefix func /-(rhs:UIView)->UIView {
	let constraint = NSLayoutConstraint(item: rhs, attribute: .top, relatedBy:.equal, toItem: rhs.superview, attribute: .top, multiplier: 1.0, constant: 0.0)
	rhs.translatesAutoresizingMaskIntoConstraints = false
	rhs.superview?.addConstraint(constraint)
	return rhs
}

@discardableResult public postfix func -/(lhs:UIView)->UIView {
	let constraint = NSLayoutConstraint(item: lhs, attribute: .bottom, relatedBy:.equal, toItem: lhs.superview, attribute: .bottom, multiplier: 1.0, constant: 0.0)
	lhs.superview?.addConstraint(constraint)
	return lhs
}


@discardableResult public func -(lhs:UIView, rhs:UIView)->UIView {
	let constraint = NSLayoutConstraint(item: lhs, attribute: .trailing, relatedBy: .equal, toItem: rhs, attribute: .leading, multiplier: 1.0, constant: 0.0)
	lhs.translatesAutoresizingMaskIntoConstraints = false
	rhs.translatesAutoresizingMaskIntoConstraints = false
	if let ancestor = lhs.shallowestCommonAncestor(with: rhs) {
		ancestor.addConstraint(constraint)
	}
	return rhs
}

@discardableResult public func -(lhs:PartialLayoutSpecifier, rhs:UIView)->UIView {
	let leadAttribute:NSLayoutAttribute = (lhs.axis == .horizontal) ? .leading : .top
	let constraint = NSLayoutConstraint(item: rhs, attribute:leadAttribute, relatedBy: .equal, toItem: rhs.superview, attribute: leadAttribute, multiplier: 1.0, constant: lhs.spacing)
	constraint.priority = lhs.priority
	rhs.translatesAutoresizingMaskIntoConstraints = false
	rhs.superview?.addConstraint(constraint)
	return rhs
}

@discardableResult public func -(lhs:UIView, rhs:PartialLayoutSpecifier)->UIView {
	let trailAttribute:NSLayoutAttribute = (rhs.axis == .horizontal) ? .trailing : .bottom
	let constraint = NSLayoutConstraint(item: lhs, attribute:trailAttribute, relatedBy: .equal, toItem: lhs.superview, attribute: trailAttribute, multiplier: 1.0, constant: -rhs.spacing)
	constraint.priority = rhs.priority
	lhs.translatesAutoresizingMaskIntoConstraints = false
	lhs.superview?.addConstraint(constraint)
	return lhs
}

@discardableResult public func /(lhs:UIView, rhs:PartialLayoutSpecifier)->UIView {
	let trailAttribute:NSLayoutAttribute = (rhs.axis == .horizontal) ? .trailing : .bottom
	let constraint = NSLayoutConstraint(item: lhs, attribute:trailAttribute, relatedBy: .equal, toItem: lhs.superview, attribute: trailAttribute, multiplier: 1.0, constant: -rhs.spacing)
	constraint.priority = rhs.priority
	lhs.translatesAutoresizingMaskIntoConstraints = false
	lhs.superview?.addConstraint(constraint)
	return lhs
}

@discardableResult public func /(lhs:UIView, rhs:UIView)->UIView {
	let constraint = NSLayoutConstraint(item: lhs, attribute: .bottom, relatedBy: .equal, toItem: rhs, attribute: .top, multiplier: 1.0, constant: 0.0)
	lhs.translatesAutoresizingMaskIntoConstraints = false
	rhs.translatesAutoresizingMaskIntoConstraints = false
	if let ancestor = lhs.shallowestCommonAncestor(with: rhs) {
		ancestor.addConstraint(constraint)
	}
	return rhs
}

@discardableResult public func /(lhs:PartialLayoutSpecifier, rhs:UIView)->UIView {
	let leadAttribute:NSLayoutAttribute = (lhs.axis == .horizontal) ? .leading : .top
	let constraint = NSLayoutConstraint(item: rhs, attribute:leadAttribute, relatedBy: .equal, toItem: rhs.superview, attribute: leadAttribute, multiplier: 1.0, constant: lhs.spacing)
	constraint.priority = lhs.priority
	rhs.translatesAutoresizingMaskIntoConstraints = false
	rhs.superview?.addConstraint(constraint)
	return rhs
}

public func -(lhs:UIView, rhs:CGFloat)->LayoutSpecifier {
	return LayoutSpecifier(axis: .horizontal, spacing: rhs, priority: UILayoutPriorityRequired, view:lhs)
}

public func /(lhs:UIView, rhs:CGFloat)->LayoutSpecifier {
	return LayoutSpecifier(axis: .vertical, spacing: rhs, priority: UILayoutPriorityRequired, view:lhs)
}

@discardableResult public func -(lhs:LayoutSpecifier, rhs:UIView)->UIView {
	let constraint = NSLayoutConstraint(item: rhs, attribute:.leading, relatedBy: .equal, toItem: lhs.view, attribute: .trailing, multiplier: 1.0, constant: lhs.spacing)
	constraint.priority = lhs.priority
	rhs.translatesAutoresizingMaskIntoConstraints = false
	lhs.view.translatesAutoresizingMaskIntoConstraints = false
	if let ancestor = lhs.view.shallowestCommonAncestor(with: rhs) {
		ancestor.addConstraint(constraint)
	}
	return rhs
}

@discardableResult public func /(lhs:LayoutSpecifier, rhs:UIView)->UIView {
	let constraint = NSLayoutConstraint(item: rhs, attribute:.top, relatedBy: .equal, toItem: lhs.view, attribute: .bottom, multiplier: 1.0, constant: lhs.spacing)
	constraint.priority = lhs.priority
	rhs.translatesAutoresizingMaskIntoConstraints = false
	lhs.view.translatesAutoresizingMaskIntoConstraints = false
	if let ancestor = lhs.view.shallowestCommonAncestor(with: rhs) {
		ancestor.addConstraint(constraint)
	}
	return rhs
}

/// Align centers horizontally
@discardableResult public func -|-(lhs:UIView, rhs:UIView)->UIView {
	rhs.translatesAutoresizingMaskIntoConstraints = false
	lhs.translatesAutoresizingMaskIntoConstraints = false
	lhs.centerXFeature == rhs.centerXFeature
	return rhs
}

/// Align centers vertically
@discardableResult public func -/-(lhs:UIView, rhs:UIView)->UIView {
	rhs.translatesAutoresizingMaskIntoConstraints = false
	lhs.translatesAutoresizingMaskIntoConstraints = false
	lhs.centerYFeature == rhs.centerYFeature
	return rhs
}

/// Set widths equal
@discardableResult public func |-|(lhs:UIView, rhs:UIView)->UIView {
	rhs.translatesAutoresizingMaskIntoConstraints = false
	lhs.translatesAutoresizingMaskIntoConstraints = false
	lhs.widthFeature == rhs.widthFeature
	return rhs
}

///Set heights equal
@discardableResult public func /-/(lhs:UIView, rhs:UIView)->UIView {
	rhs.translatesAutoresizingMaskIntoConstraints = false
	lhs.translatesAutoresizingMaskIntoConstraints = false
	lhs.heightFeature == rhs.heightFeature
	return rhs
}
