//
//  Results.swift
//  GithubChat
//
//  Created by Neo on 2019/1/29.
//  Copyright © 2019 STH. All rights reserved.
//

import Foundation

/// Result patter wrapper for wrapping the async operation as an object
class Results<T> {
    let completeClosure: (T) -> Void
    let errorClosure: ((Error) -> Void)?
    init(complete: @escaping (T) -> Void, errorClosure: ((Error) -> Void)? = nil) {
        self.completeClosure = complete
        self.errorClosure = errorClosure
    }
}
