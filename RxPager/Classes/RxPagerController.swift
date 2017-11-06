//
//  RxPagerController.swift
//  Pods
//
//  Created by xperi on 2017. 7. 26..
//
//

import Foundation
import UIKit.UITableView
import RxSwift
import RxCocoa

open class RxPagerController: UIViewController {
	
	open var config: RxPagerConfig = RxPagerConfig()

	internal var tabModels = Variable<[RxTabModel]>([])
	internal var viewModel: RxPagerViewModel = RxPagerViewModel()
	internal var tabViewModel: RxPagerTabViewModel = RxPagerTabViewModel()
	internal let disposeBag = DisposeBag()
	internal var currentPage = Variable<(index: Int, swipe: Bool)>(index: 0, swipe: false)
	internal var activeTabIndex = Variable<Int>(0)

	// MARK: - Tab and content stuff
	internal var pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
	internal var contentView: UIView {
		let contentView = self.pageViewController.view
		contentView!.autoresizingMask = [.flexibleHeight, .flexibleWidth]
		contentView!.bounds = self.view.bounds
		contentView!.tag = 34
		return contentView!
	}
	
	internal lazy var tabsView: RxPagerTabView = {
		return RxPagerTabView(config: self.config)
	}()
	
	// MARK: - Tab and content cache
	internal var contents: [UIViewController?] = []
	internal var activeContentIndex: Int = 0
	internal var animatingToTab = Variable<Bool>(false)
	internal var defaultSetupDone: Bool = false
	internal var didTapOnTabView = Variable<Bool>(false)
	
	// MARK: - Important Methods
	// Initializing RxPagerController with Name of the Tabs and their respective ViewControllers
	open func setupPager(tabNames: [String], tabControllers: [UIViewController]) {
		if tabNames.count > 0 && tabNames.count == tabControllers.count {
			let count = tabNames.count
			var models = [RxTabModel]()
			for i in 0..<count {
				let model = RxTabModel(title: tabNames[i], viewController: tabControllers[i])
				models.append(model)
			}
			tabModels.value = models
		}
	}
	
	
	open func selectTabAtIndex(_ index: Int) {
		self.selectTabAtIndex(index, swipe: false)
	}
	
	// MARK: - Other Methods
	override open func viewDidLoad() {
		super.viewDidLoad()
		self.initViews()
		self.bindViewModel()
	}
	
	override open func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if !self.defaultSetupDone {
			self.defaultSetup()
		}
	}
	
	override open func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		self.layoutSubViews()
	}
	
	override open func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransition(to: size, with: coordinator)
		self.layoutSubViews()
		self.activeTabIndex.value = self.activeTabIndex.value
	}
	
	private func initViews() {
		self.pageViewController.dataSource = self
		self.pageViewController.delegate = self
		self.view.insertSubview(self.tabsView, at: 0)
		self.view.insertSubview(self.contentView, at: 0)
	}
	
	private func bindViewModel() {
		
		guard let scrollView = (self.pageViewController.view?.subviews.flatMap{ $0 as? UIScrollView }.first)  else { return }
		
		let input = RxPagerViewModel.Input(currentPage: currentPage,
		                                   didEndDragging: scrollView.rx.didEndDragging,
		                                   didEndDecelerating: scrollView.rx.didEndDecelerating,
		                                   didEndScrollingAnimation: scrollView.rx.didEndScrollingAnimation)
		
		let output = viewModel.transform(input: input)
		output.selectedPage.drive(onNext: { [weak self] (index, swipe) in
				self?.selectTabAtIndex(index, swipe: swipe)
			})
			.disposed(by: disposeBag)
		
		output.enableTab.drive(self.didTapOnTabView)
			.disposed(by: disposeBag)
		
		
		let tabInput = RxPagerTabViewModel.Input(config: config,
											 	 models: tabModels,
		                                         activeIndex: activeTabIndex,
		                                         didScroll: scrollView.rx.didScroll,
		                                         animatingToTab: animatingToTab)
		
		let tabOutput = tabViewModel.transform(input: tabInput)
		
		tabOutput.updatedModels.debug("updatedModels").drive(onNext: {
			self.tabsView.updateTabModels(tabModels: $0, currentPage: self.currentPage)
			if self.defaultSetupDone {
				self.selectTabAtIndex(self.currentPage.value.index, swipe: false)
				self.tabsView.updateTabsIndicator(activedIndex: self.activeTabIndex.value, scrollView: scrollView, viewWidth: self.view.frame.width, didTapOnTabView: self.didTapOnTabView.value , animated: false)
			}
		}).disposed(by: disposeBag)
		
		tabOutput.updateLayoutSubviews.debug("updateLayoutSubviews2").drive(onNext: {
			self.layoutSubViews()
		}).disposed(by: disposeBag)
		
		tabOutput.activedIndex.drive(onNext: {
			self.tabsView.selectTab(index: $0)
		}).disposed(by: disposeBag)
		
		tabOutput.updateCenter.drive(onNext: { activeTabIndex in
			self.tabsView.updateTabsViewCenter(activedIndex: activeTabIndex, scrollView: scrollView)
		}).disposed(by: disposeBag)
		
		tabOutput.updateIndicator.drive(onNext: {
			self.tabsView.updateTabsIndicator(activedIndex: self.activeTabIndex.value, scrollView: scrollView, viewWidth: self.view.frame.width, didTapOnTabView: self.didTapOnTabView.value)
		}).disposed(by: disposeBag)

	}
	
	private func defaultSetup() {
		// Add tabsView
		self.tabsView.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: config.tabHeight.value)
		self.tabsView.config = config

				
		self.contents.removeAll(keepingCapacity: true)
		self.contents = Array(repeating: nil, count: self.tabsView.tabCount)
		for _ in 0 ..< self.tabsView.tabCount {
			self.contents.append(nil)
		}
		
		// Select starting tab
		let index: Int = config.startFromSecondTab.value ? 1 : 0
		self.selectTabAtIndex(index, swipe: false)
		
		// Set setup done
		self.defaultSetupDone = true
	}
	
	private func layoutSubViews() {
		var topLayoutGuide: CGFloat = 0.0
		if self.navigationController?.navigationBar.isTranslucent != false {
			topLayoutGuide = UIApplication.shared.isStatusBarHidden ? 0.0 : 20.0
			
			if let nav = self.navigationController {
				topLayoutGuide += nav.navigationBar.frame.size.height
			}
		}
		
		var frame: CGRect = self.tabsView.frame
		frame.origin.x = 0.0
		frame.origin.y = (config.tabLocation.value == .top) ? topLayoutGuide + config.tabTopOffset.value: self.view.frame.height - config.tabHeight.value
		frame.size.width = self.view.frame.width
		frame.size.height = config.tabHeight.value
		self.tabsView.frame = frame
		
		frame = self.contentView.frame
		frame.origin.x = 0.0
		frame.origin.y = (config.tabLocation.value == .top) ? topLayoutGuide + self.tabsView.frame.height + config.tabTopOffset.value: topLayoutGuide
		frame.size.width = self.view.frame.width
		
		frame.size.height = self.view.frame.height - (topLayoutGuide + self.tabsView.frame.height + config.tabTopOffset.value)
		
		if self.tabBarController != nil && self.tabBarController?.tabBar.isTranslucent == true {
			frame.size.height -= self.tabBarController!.tabBar.frame.height
		}
		self.contentView.backgroundColor = config.contentViewBackgroundColor.value
		self.contentView.frame = frame
		self.tabsView.setNeedsReloadOptions()
	}
}
