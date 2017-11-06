//
//  RxPager.swift
//  Pods
//
//  Created by xperi on 2017. 7. 27..
//
//

import UIKit

//MARK: - Pager Enums
//Enum for the location of the tab bar
public enum PagerTabLocation: Int {
	case none = 0 // None will go to the bottom
	case top = 1
	case bottom = 2
}

//Enum for the animation of the tab indicator
public enum PagerAnimation: Int {
	case none = 0 // No animation
	case end = 1 // pager indicator will animate after the VC changes
	case during = 2 // pager indicator will animate as the VC changes
}

//MARK: - Extensions
extension Array {
	func find(_ includedElement: (Element) -> Bool) -> Int? {
		for (idx, element) in self.enumerated() {
			if includedElement(element) {
				return idx
			}
		}
		return 0
	}
}
