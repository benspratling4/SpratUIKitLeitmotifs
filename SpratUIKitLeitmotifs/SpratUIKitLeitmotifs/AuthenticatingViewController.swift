//
//  AuthenticatingViewController.swift
//  SpratUIKitLeitmotifs
//
//  Created by Ben Spratling on 6/13/17.
//  Copyright © 2017 benspratling.com. All rights reserved.
//

import Foundation
import UIKit


public protocol AuthenticatedAccount {
}

public protocol Cancellable {
	func cancel()
}


public enum AuthenticationAttemptResult {
	case authenticated(AuthenticatedAccount)
	///the round trip to the server completed, and the server denied the credentials
	case denied
	///we did not receieve a response from the server as to the authenticity of these credentials
	///includes cancellation
	case failed
}

public protocol AuthenticationAttempt : Cancellable {
	func attempt(completion:@escaping(AuthenticationAttemptResult)->())
}

public protocol AuthenticatingViewControllerDelegate : class {
	func unauthenticatedViewController()->UIViewController
	
	func authenticatedViewController(account:AuthenticatedAccount)->UIViewController
}

@objc open class AuthenticatingViewController : EmbeddingViewController {
	
	open weak var authenticationDelegate:AuthenticatingViewControllerDelegate?
	
	///setting this updates the embedded view controller if the view is loaded
	open var account:AuthenticatedAccount? {
		didSet {
			if !isViewLoaded { return }
			installCorrectViewController(animated:view.window != nil)
		}
	}
	
	open var attempt:AuthenticationAttempt? {
		didSet {
			oldValue?.cancel()
			attempt?.attempt(completion: { (response) in
				defer {
					self.attempt = nil
				}
				switch response {
				case .failed:
					//do nothing
					return
				case .denied:
					self.account = nil
				case .authenticated(let account):
					self.account = account
				}
			})
		}
	}
	
	@objc open var defaultForwardAnimationOptions:UIViewAnimationOptions = .transitionCrossDissolve
	
	@objc open var defaultBackwardAnimationOptions:UIViewAnimationOptions = .transitionCrossDissolve
	
	
	@objc open override func viewDidLoad() {
		super.viewDidLoad()
		installCorrectViewController(animated:false)
	}
	
	
	open func installCorrectViewController(animated:Bool) {
		if let account = self.account {
			setEmbeddedViewController(authenticationDelegate?.authenticatedViewController(account: account), animations: animated ? defaultForwardAnimationOptions : [])
		} else {
			setEmbeddedViewController(authenticationDelegate?.unauthenticatedViewController(), animations: animated ? defaultBackwardAnimationOptions : [])
		}
	}
	
}

