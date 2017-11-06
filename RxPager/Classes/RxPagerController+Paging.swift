//
//  RxPagerController+Paging.swift
//  Pods
//
//  Created by xperi on 2017. 7. 27..
//
//

import UIKit

extension RxPagerController {
	
	func indexForViewController(_ viewController: UIViewController) -> Int {
		for (index, element) in self.contents.enumerated() {
			if element == viewController {
				return index
			}
		}
		return 0
	}
	
	
	func selectTabAtIndex(_ index: Int, swipe: Bool) {
		if index >= self.tabsView.tabCount {
			return
		}
		
		self.didTapOnTabView.value = !swipe
		self.animatingToTab.value = true
				
		self.activeTabIndex.value = index

		self.setActiveContentIndex(activeContentIndex: index)
		
		// Updating selected tab color
		self.tabsView.updateSelectedTab(index)
	}
	
	func setNeedsReloadOptions() {
		self.tabsView.setNeedsReloadOptions()
	}
	
	func viewControllerAtIndex(_ index: Int) -> UIViewController? {

		if index >= self.tabsView.tabCount || index < 0 {
			return nil
		}
		
		guard let viewController = self.contents[index] else {
			let viewController = self.tabModels.value[index].viewController
			self.contents[index] = viewController
			self.pageViewController.addChildViewController(viewController)
			return viewController
		}
		
		return viewController
	}
	
	func setActiveContentIndex(activeContentIndex: Int) {
		// Get the desired viewController
		
		guard let viewController = self.viewControllerAtIndex(activeContentIndex) else {
			return
		}

		
		weak var wPageViewController: UIPageViewController? = self.pageViewController
		weak var wSelf: RxPagerController? = self
		
		if activeContentIndex == self.activeContentIndex {
			DispatchQueue.main.async(execute: {
				_ in
				
				self.pageViewController.setViewControllers([viewController], direction: .forward, animated: false, completion: {
					(completed: Bool) -> Void in
					wSelf!.animatingToTab.value = false
				})
			})
		} else if !(activeContentIndex + 1 == self.activeContentIndex || activeContentIndex - 1 == self.activeContentIndex) {
			
			let direction: UIPageViewControllerNavigationDirection = (activeContentIndex < self.activeContentIndex) ? .reverse : .forward
			DispatchQueue.main.async(execute: {
				_ in
				
				self.pageViewController.setViewControllers([viewController], direction: direction, animated: true, completion: {
					completed in
					
					wSelf?.animatingToTab.value = false
					
					if completed {
						DispatchQueue.main.async(execute: {
							() -> Void in
							wPageViewController!.setViewControllers([viewController], direction: direction, animated: false, completion: nil)
						})
					}
				})
			})
		} else {
			let direction: UIPageViewControllerNavigationDirection = (activeContentIndex < self.activeContentIndex) ? .reverse : .forward
			DispatchQueue.main.async(execute: {
				_ in
				
				self.pageViewController.setViewControllers([viewController], direction: direction, animated: true, completion: {
					(completed: Bool) -> Void in
					wSelf!.animatingToTab.value = true
				})
			})
		}
		
		// Clean out of sight contents
		var index: Int = self.activeContentIndex - 1
		if index >= 0 && index != activeContentIndex && index != activeContentIndex - 1 {
			self.contents[index] = nil
		}
		index = self.activeContentIndex
		if index != activeContentIndex - 1 && index != activeContentIndex && index != activeContentIndex + 1 {
			self.contents[index] = nil
		}
		index = self.activeContentIndex + 1
		if index < self.contents.count && index != activeContentIndex && index != activeContentIndex + 1 {
			self.contents[index] = nil
		}
		self.activeContentIndex = activeContentIndex
	}
	
}
