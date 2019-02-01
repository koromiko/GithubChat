//
//  Chatroom.swift
//  GithubChat
//
//  Created by Neo on 2019/1/29.
//  Copyright © 2019 STH. All rights reserved.
//

import Foundation

struct Chatroom: Decodable {
    let users: [User]
    let id: String
    var messages: [Message]

    enum CodingKeys: String, CodingKey {
        case users
        case id = "chatroom_id"
        case messages
    }
}
