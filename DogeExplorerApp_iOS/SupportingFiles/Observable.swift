//
//  Observable.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 19.07.2023.
//

import Foundation

final class Observable<T> {
    typealias Listener = (T) -> Void
    
    private var listener: Listener?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(value: T) {
        self.value = value
    }
    
    func bind(listener: @escaping Listener) {
        self.listener = listener
    }
}
