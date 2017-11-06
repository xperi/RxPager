//
//  RxPagerConfig.swift
//  Pods
//
//  Created by xperi on 2017. 7. 27..
//
//

import Foundation
import RxSwift
import RxCocoa

public struct RxPagerConfig {
	// MARK: - public properties
	public var contentViewBackgroundColor = Variable<UIColor>(UIColor.white)
	public var indicatorColor = Variable<UIColor>(UIColor.red)
	public var tabsViewBackgroundColor = Variable<UIColor>(UIColor.gray)
	public var tabsTextColor = Variable<UIColor>(UIColor.white)
	public var selectedTabTextColor = Variable<UIColor>(UIColor.white)
	public var tabHeight = Variable<CGFloat>(44.0)
	public var tabTopOffset = Variable<CGFloat>(0.0)
	public var tabOffset = Variable<CGFloat>(56.0)
	public var tabWidth = Variable<CGFloat>(128.0)
	public var tabsTextFont = Variable<UIFont>(UIFont.boldSystemFont(ofSize: 16.0))
	public var indicatorHeight = Variable<CGFloat>(5.0)
	public var tabLocation = Variable<PagerTabLocation>(PagerTabLocation.top)
	public var animation = Variable<PagerAnimation>(PagerAnimation.during)
	public var startFromSecondTab = Variable<Bool>(false)
	public var centerCurrentTab = Variable<Bool>(false)
	public var fixFormerTabsPositions = Variable<Bool>(false)
	public var fixLaterTabsPosition = Variable<Bool>(false)}
