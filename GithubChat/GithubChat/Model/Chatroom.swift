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

    init() {
        messages = [Message(id: "3", content: "Test", senderId: 20)]
        id = "3"
        users = [User(id: 3, login: "mojombo", avatarUrl: "https://avatars0.githubusercontent.com/u/1?v=4")]
    }
}
