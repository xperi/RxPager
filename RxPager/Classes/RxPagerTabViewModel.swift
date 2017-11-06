//
//  RxPageTabViewModel.swift
//  Pods
//
//  Created by xperi on 2017. 7. 31..
//
//

import Foundation
import RxSwift
import RxCocoa
import RxSwiftExt

extension RxPagerTabViewModel {
	struct Input {
		var config: RxPagerConfig
		var models: Variable<[RxTabModel]>
		var activeIndex: Variable<Int>
		var didScroll: ControlEvent<Void>
		var animatingToTab: Variable<Bool>
	}
	
	
	struct Output {
		var updatedModels: Driver<[RxTabModel]>
		var activedIndex: Driver<Int>
		var updateCenter: Driver<Int>
		var updateLayoutSubviews: Driver<Void>
		var updateIndicator: Driver<Void>
	}
}

final class RxPagerTabViewModel: ViewModelType {
	
	func transform(input: Input) -> Output {
		let config						= input.config
		let tabOffset					= config.tabOffset.asObservable().map{_ in }
		let tabWidth					= config.tabWidth.asObservable().map{_ in }
		let tabHeight					= config.tabHeight.asObservable().map{_ in }
		let tabTopOffset				= config.tabTopOffset.asObservable().map{_ in }
		let tabLocation					= config.tabLocation.asObservable().map{_ in }
		let fixLaterTabsPosition		= config.fixLaterTabsPosition.asObservable().map{_ in }
		let fixFormerTabsPositions		= config.fixFormerTabsPositions.asObservable().map{_ in }
		let centerCurrentTab			= config.centerCurrentTab.asObservable().map{_ in }
		let indicatorHeight				= config.indicatorHeight.asObservable().map{_ in }
		let indicatorColor				= config.indicatorColor.asObservable().map{_ in }
		let contentViewBackgroundColor	= config.contentViewBackgroundColor.asObservable().map{_ in }
		let tabsViewBackgroundColor		= config.tabsViewBackgroundColor.asObservable().map{_ in }
		
		let configForUpdateModels = Observable.from([tabOffset, tabWidth, tabHeight, fixLaterTabsPosition, fixFormerTabsPositions,
		                                             centerCurrentTab, indicatorHeight,indicatorColor])
													.merge()
													.throttle(0.3, scheduler: MainScheduler.instance).debug("configForUpdateModels")
												
		let updateModels = Observable.combineLatest(input.models.asObservable(), configForUpdateModels){
													models, configEvent in
														return models
													}
													.asDriver(onErrorJustReturn:[])

		let updateLayoutSubviews = Observable.from([tabLocation, tabTopOffset, tabHeight, contentViewBackgroundColor
													,tabsViewBackgroundColor])
													.merge()
													.debounce(0.3, scheduler: MainScheduler.instance)
													.debug("updateLayoutSubvies")
													.asDriver(onErrorJustReturn: ())
		
		let updateCenter = input.didScroll.pausable(input.animatingToTab.asObservable().map{ !$0 })
			.asDriver(onErrorJustReturn: ())
			.map{ input.activeIndex.value }



		return Output(updatedModels: updateModels,
		              activedIndex: input.activeIndex.asDriver(),
		              updateCenter: updateCenter,
		              updateLayoutSubviews: updateLayoutSubviews,
		              updateIndicator: input.didScroll.asDriver())
	}
}

