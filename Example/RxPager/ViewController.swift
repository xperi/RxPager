//
//  ViewController.swift
//  RxPager
//
//  Created by xperi on 07/26/2017.
//  Copyright (c) 2017 xperi. All rights reserved.
//

import UIKit
import RxPager

class ViewController: RxPagerController {
	
	var titles: [String] = []
	
	override open func loadView(){
		super.loadView()
		customizeTab()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Instantiating Storyboard ViewControllers
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let controller1 = storyboard.instantiateViewController(withIdentifier: "firstView")
		let controller2 = storyboard.instantiateViewController(withIdentifier: "secondView")
		let controller3 = storyboard.instantiateViewController(withIdentifier: "thirdView")
		let controller4 = storyboard.instantiateViewController(withIdentifier: "tableView")
		let controller5 = storyboard.instantiateViewController(withIdentifier: "fifthView")
		let controller6 = storyboard.instantiateViewController(withIdentifier: "sixthView")
		
		// Setting up the PagerController with Name of the Tabs and their respective ViewControllers
		self.setupPager(
			tabNames: ["Blue", "Orange", "Light Blue", "Grey", "Purple", "Green"],
			tabControllers: [controller1, controller2, controller3, controller4, controller5, controller6])
		
		if let controller = controller4 as? GreyViewController {
			controller.didSelectRow = pushGreyDetailViewController
		}
	}
	
	// Customising the Tab's View
	func customizeTab() {
		self.config.indicatorColor.value = UIColor.white
		self.config.tabsViewBackgroundColor.value = UIColor(rgb: 0x00AA00)
		self.config.contentViewBackgroundColor.value = UIColor.gray.withAlphaComponent(0.32)
		
		self.config.startFromSecondTab.value = false
		self.config.centerCurrentTab.value = true
		self.config.tabLocation.value = PagerTabLocation.top
		self.config.tabHeight.value = 49
		self.config.tabOffset.value = 36
		self.config.tabWidth.value = 96.0
		self.config.fixFormerTabsPositions.value = false
		self.config.fixLaterTabsPosition.value = false
		self.config.animation.value = PagerAnimation.during
		self.config.selectedTabTextColor.value = .blue
		self.config.tabsTextFont.value = UIFont(name: "HelveticaNeue-Bold", size: 20)!
		// tabTopOffset = 10.0
		// tabsTextColor = .purpleColor()
			
	}
	
	
	// Programatically selecting a tab. This function is getting called on AppDelegate
	func changeTab() {
		//self.config.tabHeight.value = 100.0
		//self.selectTabAtIndex(4)
		self.config.tabsViewBackgroundColor.value = UIColor.blue
		self.config.tabsViewBackgroundColor.value = UIColor.blue


	}
	
	
	func pushGreyDetailViewController(text: String) {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		if let detail = storyboard.instantiateViewController(withIdentifier: "greyTableDetail") as? GreyDetailViewController {
			detail.text = text
			self.navigationController?.pushViewController(detail, animated: true)
		}
	}
	
	
}

