//
//  SampleAccount.swift
//  SampleApp
//
//  Created by Ben Spratling on 8/8/17.
//  Copyright © 2017 benspratling.com. All rights reserved.
//

import Foundation
import SpratUIKitLeitmotifs


struct SampleAccount : AuthenticatedAccount {
	var vip:String
}


class SampleAccountAttempt : AuthenticationAttempt {
	
	var vip:String
	
	init(vip:String) {
		self.vip = vip
	}
	
	func attempt(completion:@escaping (AuthenticationAttemptResult)->()) {
		DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.5) {
			completion(.authenticated(SampleAccount(vip:self.vip)))
		}
	}
	
	func cancel() {
		//TODO: write me
	}

}
