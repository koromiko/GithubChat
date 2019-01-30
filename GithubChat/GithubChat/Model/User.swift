//
//  User.swift
//  GithubChat
//
//  Created by Neo on 2019/1/27.
//  Copyright © 2019 STH. All rights reserved.
//

import Foundation

struct User: Decodable {
    let id: Int
    let login: String
    let avatarUrl: String

    enum CodingKeys: String, CodingKey {
        case id
        case login
        case avatarUrl = "avatar_url"
    }
}
