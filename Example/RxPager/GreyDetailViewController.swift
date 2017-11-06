//
//  GreyDetailViewController.swift
//  RxPager
//
//  Created by xperi on 2017. 7. 26..
//  Copyright © 2017년 CocoaPods. All rights reserved.
//

import UIKit

class GreyDetailViewController: UIViewController {
	
	@IBOutlet weak var detailText: UILabel! {
		didSet {
			detailText.text = text
		}
	}
	
	var text: String?
	
}
