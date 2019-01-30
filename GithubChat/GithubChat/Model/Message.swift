//
//  Message.swift
//  GithubChat
//
//  Created by Neo on 2019/1/27.
//  Copyright © 2019 STH. All rights reserved.
//

import Foundation

struct Message: Decodable {
    let id: String
    let content: String
    let senderId: Int

    enum CodingKeys: String, CodingKey {
        case id = "message_id"
        case content = "content"
        case senderId = "sender_id"
    }
}
