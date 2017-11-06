//
//  Extensions.swift
//  RxPager
//
//  Created by xperi on 2017. 7. 26..
//  Copyright © 2017년 xperi. All rights reserved.
//

import UIKit

extension UIColor {
	convenience init(rgb: UInt) {
		self.init(
			red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
			green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
			blue: CGFloat(rgb & 0x0000FF) / 255.0,
			alpha: CGFloat(1.0)
		)
	}
}

extension UINavigationBar {
	
	func hideBottomHairline() {
		let navigationBarImageView = hairlineImageViewInNavigationBar(self)
		navigationBarImageView!.isHidden = true
	}
	
	func showBottomHairline() {
		let navigationBarImageView = hairlineImageViewInNavigationBar(self)
		navigationBarImageView!.isHidden = false
	}
	
	fileprivate func hairlineImageViewInNavigationBar(_ view: UIView) -> UIImageView? {
		if let view  = view as? UIImageView, view.bounds.size.height <= 1.0 {
			return view
		}
		
		let subviews = (view.subviews as [UIView])
		for subview: UIView in subviews {
			if let imageView: UIImageView = hairlineImageViewInNavigationBar(subview) {
				return imageView
			}
		}
		
		return nil
	}
}

