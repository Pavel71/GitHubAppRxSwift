//
//  UIViewController + Rx.swift
//  GitHubAppRxSwift
//
//  Created by Павел Мишагин on 26.09.2020.
//  Copyright © 2020 Павел Мишагин. All rights reserved.
//

import RxSwift

extension Reactive where Base: UIView {
    var willMoveToWindow: Observable<Bool> {
        return self.sentMessage(#selector(Base.willMove(toWindow:)))
            .map({ $0.filter({ !($0 is NSNull) }) })
            .map({ $0.isEmpty == false })
    }
    var viewWillAppear: Observable<Void> {
        return self.willMoveToWindow
            .filter({ $0 })
            .map({ _ in Void() })
    }
    var viewWillDisappear: Observable<Void> {
        return self.willMoveToWindow
            .filter({ !$0 })
            .map({ _ in Void() })
    }
}
