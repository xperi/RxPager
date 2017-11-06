//
//  RxPagerTabViewCell.swift
//  Pods
//
//  Created by xperi on 2017. 7. 27..
//
//

import UIKit
import RxSwift
import RxCocoa

//MARK: - TabView
class RxPagerTabView: UIScrollView {
	private var tabModels: [RxTabModel] = []
	private let disposeBag = DisposeBag()
	
	var underlineStroke: UIView = UIView()
	var tabs: [UIView?] = []
	var tabCount: Int {
		return tabModels.count
	}
	var config: RxPagerConfig
	
	init(config: RxPagerConfig) {
		self.config = config
		super.init(frame: CGRect.zero)
		commonInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func commonInit(){
		self.autoresizingMask = .flexibleWidth
		self.scrollsToTop = false
		self.bounces = false
		self.showsHorizontalScrollIndicator = false
		self.showsVerticalScrollIndicator = false
		self.isScrollEnabled = true
		self.tag = 38
		self.backgroundColor = config.tabsViewBackgroundColor.value
	}
	
	func updateTabModels(tabModels: [RxTabModel], currentPage: Variable<(index: Int, swipe: Bool)>){
		
		self.tabModels = tabModels
		
		for tabView in self.tabs {
			tabView?.removeFromSuperview()
		}
		
		self.underlineStroke.removeFromSuperview()
		self.tabs.removeAll(keepingCapacity: true)
		
		
		// Populate arrays with nil
		self.tabs = Array(repeating: nil, count: self.tabCount)
		for _ in 0 ..< self.tabCount {
			self.tabs.append(nil)
		}
		
		// Add tab views to _tabsView
		var contentSizeWidth: CGFloat = 0.0
		
		// Give the standard offset if fixFormerTabsPositions is provided as YES
		if config.fixFormerTabsPositions.value {
			// And if the centerCurrentTab is provided as YES fine tune the offset according to it
			if config.centerCurrentTab.value {
				contentSizeWidth = (self.frame.width - config.tabWidth.value) / 2.0
			} else {
				contentSizeWidth = config.tabOffset.value
			}
		}
		
		for i in 0 ..< self.tabCount {
			
			if let tabView = self.tabViewCellAtIndex(i) {
				var frame: CGRect = tabView.frame
				frame.origin.x = contentSizeWidth
				frame.size.width = config.tabWidth.value
				tabView.frame = frame
				
				self.addSubview(tabView)
				
				contentSizeWidth += tabView.frame.width
				
				// To capture tap events
				let tapGestureRecognizer = UITapGestureRecognizer()
				tapGestureRecognizer.rx.event.map{ _ in (index: i, swipe: false) }
					.bind(to: currentPage)
					.disposed(by: disposeBag)
				tabView.addGestureRecognizer(tapGestureRecognizer)
			}

		}
		
		// Extend contentSizeWidth if fixLatterTabsPositions is provided YES
		if config.fixLaterTabsPosition.value {
			// And if the centerCurrentTab is provided as YES fine tune the content size according to it
			if config.centerCurrentTab.value {
				contentSizeWidth += (self.frame.width - config.tabWidth.value) / 2.0
			} else {
				contentSizeWidth += self.frame.width - config.tabWidth.value - config.tabOffset.value
			}
		}
		
		self.contentSize = CGSize(width: contentSizeWidth, height: config.tabHeight.value)

		if self.tabCount > 0 {
			// creates the indicator
			var rect: CGRect = self.tabViewCellAtIndex(0)?.frame ?? CGRect.zero
			rect.origin.y = rect.size.height - config.indicatorHeight.value
			rect.size.height = config.indicatorHeight.value
			
			self.underlineStroke = UIView(frame: rect)
			self.underlineStroke.backgroundColor = config.indicatorColor.value
			self.addSubview(self.underlineStroke)
		}
	}
	

	func tabViewCellAtIndex(_ index: Int) -> RxPagerTabViewCell? {
		if index >= self.tabCount {
			return nil
		}
		
		if (self.tabs[index] as UIView?) == nil {
			
			var tabViewContent = UIView()
			let title = self.tabModels[index].title
			let label: UILabel = UILabel()
			label.text = title
			label.textColor = config.tabsTextColor.value
			label.font = config.tabsTextFont.value
			label.backgroundColor = UIColor.clear
			label.sizeToFit()
			tabViewContent = label
			
			tabViewContent.autoresizingMask = [.flexibleHeight, .flexibleWidth]
			
			let tabView: RxPagerTabViewCell = RxPagerTabViewCell(frame: CGRect(x: 0.0, y: 0.0, width: config.tabWidth.value, height: config.tabHeight.value))
			tabView.addSubview(tabViewContent)
			tabView.clipsToBounds = true
			tabViewContent.center = tabView.center
			
			// Replace the null object with tabView
			self.tabs[index] = tabView
		}
		
		return self.tabs[index] as? RxPagerTabViewCell
	}
	
	func selectTab(index:Int){
		guard let tabView = self.tabViewCellAtIndex(index) else { return }

		var frame: CGRect = tabView.frame
		
		if self.config.centerCurrentTab.value {
			
			if (frame.origin.x + frame.width + (self.frame.width / 2)) >= self.contentSize.width {
				frame.origin.x = (self.contentSize.width - self.frame.width)
			} else {
				
				frame.origin.x += (frame.width / 2)
				frame.origin.x -= (self.frame.width / 2)
				
				if frame.origin.x < 0 {
					frame.origin.x = 0
				}
				
			}
			
		} else {
			frame.origin.x -= self.config.tabOffset.value
			frame.size.width = self.frame.width
		}
		
		self.setContentOffset(frame.origin, animated: true)
	}
	
	func updateSelectedTab(_ index: Int) {
		
		// Resetting all tab colors to white
		for tab in self.tabs {
			
			if let label = tab?.subviews.first as? UILabel {
				label.textColor = config.tabsTextColor.value
			}
		}
		
		// Setting current selected tab to red
		let tab = self.tabViewCellAtIndex(index)
		if let label = tab?.subviews.first as? UILabel {
			label.textColor = config.selectedTabTextColor.value
		}
	}
	
	func setNeedsReloadOptions() {
		// We should update contentSize property of our tabsView, so we should recalculate it with the new values
		var contentSizeWidth: CGFloat = 0.0
		
		// Give the standard offset if fixFormerTabsPositions is provided as YES
		if config.fixFormerTabsPositions.value {
			// And if the centerCurrentTab is provided as YES fine tune the offset according to it
			if config.centerCurrentTab.value {
				contentSizeWidth = (self.frame.width - config.tabWidth.value) / 2.0
			} else {
				contentSizeWidth = config.tabOffset.value
			}
		}
		
		// Update every tab's frame
		for i in 0 ..< self.tabCount {
			let tabView = self.tabViewCellAtIndex(i)
			var frame: CGRect = tabView!.frame
			frame.origin.x = contentSizeWidth
			frame.size.width = config.tabWidth.value
			tabView?.frame = frame
			contentSizeWidth += tabView!.frame.width
		}
		
		// Extend contentSizeWidth if fixLatterTabsPositions is provided YES
		if config.fixLaterTabsPosition.value {
			
			// And if the centerCurrentTab is provided as YES fine tune the content size according to it
			if config.centerCurrentTab.value {
				contentSizeWidth += (self.frame.width - config.tabWidth.value) / 2.0
			} else {
				contentSizeWidth += self.frame.width - config.tabWidth.value - config.tabOffset.value
			}
		}
		// Update tabsView's contentSize with the new width
		self.contentSize = CGSize(width: contentSizeWidth, height: config.tabHeight.value)
		self.backgroundColor = config.tabsViewBackgroundColor.value

	}
	
	
	func updateTabsViewCenter(activedIndex: Int, scrollView: UIScrollView){
		guard let tabView = self.tabViewCellAtIndex(activedIndex)  else { return }
		// Get the related tab view position
		var frame: CGRect = tabView.frame
		let movedRatio: CGFloat = (scrollView.contentOffset.x / scrollView.frame.width) - 1
		frame.origin.x += movedRatio * frame.width
		
		if self.config.centerCurrentTab.value {
			
			frame.origin.x += (frame.size.width / 2)
			frame.origin.x -= self.frame.width / 2
			frame.size.width = self.frame.width
			
			if frame.origin.x < 0 {
				frame.origin.x = 0
			}
			
			if (frame.origin.x + frame.size.width) > self.contentSize.width {
				frame.origin.x = (self.contentSize.width - self.frame.width)
			}
		} else {
			
			frame.origin.x -= self.config.tabOffset.value
			frame.size.width = self.frame.width
		}
		
		self.scrollRectToVisible(frame, animated: false)
		
	}
	
	func updateTabsIndicator(activedIndex: Int, scrollView: UIScrollView, viewWidth: CGFloat, didTapOnTabView: Bool, animated: Bool = true){
		guard let tabView = self.tabViewCellAtIndex(activedIndex)  else { return }
		
		var rect: CGRect = tabView.frame
		
		let updateIndicator = {
			(newX: CGFloat) -> Void in
			rect.origin.x = newX
			rect.origin.y = self.underlineStroke.frame.origin.y
			rect.size.height = self.underlineStroke.frame.size.height
			self.underlineStroke.frame = rect
		}
		
		var newX: CGFloat
		let width: CGFloat = viewWidth
		let distance: CGFloat = tabView.frame.size.width
		
		if self.config.animation.value == PagerAnimation.during && !didTapOnTabView {
			if scrollView.panGestureRecognizer.translation(in: scrollView.superview!).x > 0 {
				let mov: CGFloat = width - scrollView.contentOffset.x
				newX = rect.origin.x - ((distance * mov) / width)
			} else {
				let mov: CGFloat = scrollView.contentOffset.x - width
				newX = rect.origin.x + ((distance * mov) / width)
			}
			updateIndicator(newX)
		} else if self.config.animation.value == PagerAnimation.none {
			newX = tabView.frame.origin.x
			updateIndicator(newX)
		} else if self.config.animation.value == PagerAnimation.end || didTapOnTabView {
			newX = tabView.frame.origin.x
			if animated {
				UIView.animate(withDuration: 0.35, animations: {
					() -> Void in
					updateIndicator(newX)
				})
			} else {
				updateIndicator(newX)
			}
		}

	}
}


//MARK: - TabViewCell
class RxPagerTabViewCell: UIView {
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.backgroundColor = UIColor.clear
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.backgroundColor = UIColor.clear
	}
}
