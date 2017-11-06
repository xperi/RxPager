//
//  RxPagerController+UIPageViewController.swift
//  Pods
//
//  Created by xperi on 2017. 7. 27..
//
//

import UIKit

// MARK: - Page DataSource
extension RxPagerController: UIPageViewControllerDataSource {
	open func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
		var index: Int = self.indexForViewController(viewController)
		index -= 1
		return self.viewControllerAtIndex(index)
	}
	
	open func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
		var index: Int = self.indexForViewController(viewController)
		index += 1
		return self.viewControllerAtIndex(index)
	}
}
// MARK: - Page Delegate
extension RxPagerController: UIPageViewControllerDelegate {
	open func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
		let viewController: UIViewController = self.pageViewController.viewControllers![0] as UIViewController
		let index: Int = self.indexForViewController(viewController)
		self.currentPage.value = (index: index, swipe: true)
	}
	
}
