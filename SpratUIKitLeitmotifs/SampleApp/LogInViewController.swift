//
//  LogInViewController.swift
//  SampleApp
//
//  Created by Ben Spratling on 8/8/17.
//  Copyright © 2017 benspratling.com. All rights reserved.
//

import Foundation
import UIKit
import SpratUIKitLeitmotifs

class LogInViewController :  UIViewController {
	
	@IBOutlet var textField:UITextField?
	
	@IBAction func userDidTapLogIn() {
		guard let text:String = textField?.text else {
			print("did ta log in")
			return
		}
		let attempt = SampleAccountAttempt(vip:text)
		guard let authenticatingVC:AuthenticatingViewController = enclosingViewController() else {
			return
		}
		authenticatingVC.attempt = attempt
		
	}
	
}
