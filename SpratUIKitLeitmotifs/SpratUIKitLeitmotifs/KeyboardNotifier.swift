//
//  KeyboardNotifier.swift
//  SpratUIKitLeitmotifs
//
//  Created by Benjamin Spratling on 6/23/15.
//  Copyright © 2015 benspratling.com. All rights reserved.
//

import Foundation
import UIKit


extension UIViewAnimationOptions {
	public init(curve:UIViewAnimationCurve) {
		switch curve {
		case .easeIn:
			self = .curveEaseIn
		case .easeOut:
			self = .curveEaseOut
		case .easeInOut:
			self = .curveEaseInOut
		case .linear:
			self = .curveLinear
		}
	}
}


@objc open class KeyboardObserver : NSObject {
	
	private var willShowObject:NSObjectProtocol?
	private var didShowObject:NSObjectProtocol?
	private var willHideObject:NSObjectProtocol?
	private var didHideObject:NSObjectProtocol?
	private var willChangeObject:NSObjectProtocol?
	private var didChangeObject:NSObjectProtocol?
	
	
	open var keyboardFrame:CGRect = .zero
	
	
	open var changes:(_ newFrame:CGRect)->()
	
	@objc public init(changes:@escaping(_ newFrame:CGRect)->()) {
		self.changes = changes
		super.init()
		let center:NotificationCenter = .default
		willShowObject = center.addObserver(forName: .UIKeyboardWillShow, object: nil, queue: nil) { [weak self] (notification) in
			self?.keyboardWillShow(notification)
		}
		didShowObject = center.addObserver(forName: .UIKeyboardDidShow, object: nil, queue: nil) { [weak self] (notification) in
			self?.keyboardDidShow(notification)
		}
		willHideObject = center.addObserver(forName: .UIKeyboardWillHide, object: nil, queue: nil) { [weak self] (notification) in
			self?.keyboardWillHide(notification)
		}
		didHideObject = center.addObserver(forName: .UIKeyboardDidHide, object: nil, queue: nil) { [weak self] (notification) in
			self?.keyboardDidHide(notification)
		}
		willChangeObject = center.addObserver(forName: .UIKeyboardWillChangeFrame, object: nil, queue: nil, using: {[weak self] (notification) in
			self?.keyboardWillUpdate(notification)
		})
		didChangeObject = center.addObserver(forName: .UIKeyboardDidChangeFrame, object: nil, queue: nil, using: {[weak self] (notification) in
			self?.keyboardDidUpdate(notification)
		})
	}
	
	open func keyboardWillShow(_ notification:Notification) {
		guard let nextFrame:CGRect = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect else { return }
		keyboardFrame = nextFrame
		animate(notification: notification, rect: nextFrame, animations: changes)
	}
	
	open func keyboardDidShow(_ notification:Notification) {
		guard let nextFrame:CGRect = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect else { return }
		keyboardFrame = nextFrame
		animate(notification: notification, rect: nextFrame, animations: changes)
	}
	
	open func keyboardWillHide(_ notification:Notification) {
		guard let nextFrame:CGRect = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect else { return }
		keyboardFrame = nextFrame
		animate(notification: notification, rect: nextFrame, animations: changes)
	}
	
	open func keyboardDidHide(_ notification:Notification) {
		guard let nextFrame:CGRect = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect else { return }
		keyboardFrame = nextFrame
		animate(notification: notification, rect: nextFrame, animations: changes)
	}
	
	open func keyboardDidUpdate(_ notification:Notification) {
		guard let nextFrame:CGRect = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect else { return }
		keyboardFrame = nextFrame
		animate(notification: notification, rect: nextFrame, animations: changes)
	}
	
	open func keyboardWillUpdate(_ notification:Notification) {
		guard let nextFrame:CGRect = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect else { return }
		keyboardFrame = nextFrame
		animate(notification: notification, rect: nextFrame, animations: changes)
	}
	
	open func animate(notification:Notification, rect:CGRect, animations:@escaping (CGRect)->()) {
		guard let duration:Float64 = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Float64
			,let curveRawValue:Int = notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? Int
			,let curve = UIViewAnimationCurve(rawValue: curveRawValue)
			else {
				animations(rect)
				return
		}
		UIView.animate(withDuration: duration, delay: 0.0, options: UIViewAnimationOptions(curve:curve), animations: { ()->() in
			animations(rect)
		}, completion: nil)
	}
	
	
	deinit {
		let center:NotificationCenter = .default
		if let observer = willShowObject {
			center.removeObserver(observer)
		}
		if let observer = didShowObject {
			center.removeObserver(observer)
		}
		if let observer = willHideObject {
			center.removeObserver(observer)
		}
		if let observer = didHideObject {
			center.removeObserver(observer)
		}
		
		if let observer = willChangeObject {
			center.removeObserver(observer)
		}
		
		if let observer = didChangeObject {
			center.removeObserver(observer)
		}
	}
	
	
}


//provides the height of the keyboard in the view's frame
@objc open class KeyboardAvoider : KeyboardObserver {
	
	///converts the space taken by the keyboard at the bottom of the view into the coordinate system of the given view
	@objc public init(view:UIView, changes:@escaping (CGFloat)->()) {
		super.init { (newRect) in
			let convertedRect = view.convert(newRect, from: nil)
			let newInset = view.bounds.size.height - convertedRect.origin.y
			changes(newInset)
		}
	}
	
}

