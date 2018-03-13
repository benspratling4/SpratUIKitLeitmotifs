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

class SampleAccountViewController : UIViewController {
	
	@IBOutlet var label:UILabel?
	
	var account:SampleAccount?  {
		didSet {
			if !isViewLoaded { return }
			updateUI()
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		updateUI()
	}
	
	func updateUI() {
		label?.text = account?.vip
	}
	
	@IBAction func userDidTapLogOut() {
		guard let authenticatingVC:AuthenticatingViewController = enclosingViewController() else {
			return
		}
		
		authenticatingVC.account = nil
	}
}
