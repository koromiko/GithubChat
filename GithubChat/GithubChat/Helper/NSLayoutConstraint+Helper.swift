//
//  NSLayoutConstraint+Helper.swift
//  GithubChat
//
//  Created by Neo on 2019/1/28.
//  Copyright © 2019 STH. All rights reserved.
//

import UIKit

extension Array where Element: NSLayoutConstraint {
    func activate() {
        for e in self {
            e.isActive = true
        }
    }
}

