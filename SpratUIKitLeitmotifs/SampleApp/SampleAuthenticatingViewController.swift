//
//  SampleAccountViewController.swift
//  SampleApp
//
//  Created by Ben Spratling on 8/8/17.
//  Copyright © 2017 benspratling.com. All rights reserved.
//

import Foundation
import UIKit
import SpratUIKitLeitmotifs

@objc class SampleAuthenticatingViewController : AuthenticatingViewController , AuthenticatingViewControllerDelegate {
	func unauthenticatedViewController()->UIViewController {
		return newLogInController()
	}
	
	func authenticatedViewController(account:AuthenticatedAccount)->UIViewController {
		let sampleAccount = account as! SampleAccount
		return newSampleAccountVC(account: sampleAccount)
	}
	
	func newLogInController()->UIViewController {
		return storyboard!.instantiateViewController(withIdentifier: "login")
	}

	func newSampleAccountVC(account:SampleAccount)->UIViewController {
		let accountController:SampleAccountViewController = storyboard!.instantiateViewController(withIdentifier:"account") as! SampleAccountViewController
		accountController.account = account
		return accountController
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		authenticationDelegate = self
	}
	
}

