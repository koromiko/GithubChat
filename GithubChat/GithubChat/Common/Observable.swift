//
//  Observable.swift
//  GithubChat
//
//  Created by Neo on 2019/1/29.
//  Copyright © 2019 STH. All rights reserved.
//

import Foundation

/// Data wrapper for observing the value changes
class Observable<T> {
    /// The value container
    var value: T {
        didSet {
            DispatchQueue.main.async {
                self.valueChanged?(self.value)
            }
        }
    }

    /// Assogin this with a closure to observe the value changes
    var valueChanged: ((T) -> Void)?

    init(_ value: T) {
        self.value = value
    }
}
