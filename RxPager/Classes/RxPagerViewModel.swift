//
//  RxPagerViewModel.swift
//  Pods
//
//  Created by xperi on 2017. 7. 26..
//
//
import Foundation
import RxSwift
import RxCocoa
import RxSwiftExt

extension RxPagerViewModel {
	struct Input {
		var currentPage: Variable<(index: Int, swipe: Bool)>
		var didEndDragging: ControlEvent<Bool>
		let didEndDecelerating: ControlEvent<Void>
		let didEndScrollingAnimation: ControlEvent<Void>
	}
	
	struct Output {
		var selectedPage: Driver<(index: Int, swipe: Bool)>
		var enableTab: Driver<Bool>
	}
}

final class RxPagerViewModel: ViewModelType {
	
	func transform(input: Input) -> Output {
		
		let currentPage = input.currentPage.asDriver().distinctUntilChanged{ $0.0 == $1.0 && $0.1 == $1.1}
		let didEndDragging = input.didEndDragging.map({ _ in }).asObservable()
		let didEndDecelerating = input.didEndDecelerating.asObservable()
		let didEndScrollingAnimation = input.didEndScrollingAnimation.asObservable()
		
		let enableTab = Observable.of(didEndDragging, didEndDecelerating, didEndScrollingAnimation)
			.merge()
			.map{ false }
			.asDriver(onErrorJustReturn: false)
		
		return Output(selectedPage: currentPage, enableTab: enableTab)
	}
}

