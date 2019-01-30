//
//  ChatroomService.swift
//  GithubChat
//
//  Created by Neo on 2019/1/29.
//  Copyright © 2019 STH. All rights reserved.
//

import Foundation

class ChatroomService {
    private var messages: [Int: [Message]] = [:]

    func getChatroomInfo(userId: Int, result: Results<Chatroom>) {
        DispatchQueue.global().async {
//            sleep(1)
            var chatroom = Chatroom()
            if let messages = self.messages[userId] {
                chatroom.messages = messages
            }
            result.completeClosure(chatroom)
        }

    }

    func sendMessage(to userId: Int, message: Message, result: Results<Void>) {
        DispatchQueue.global().async {
            sleep(1)
            var messages = self.messages[userId] ?? [Message]()
            messages.append(message)
            self.messages[userId] = messages
            result.completeClosure(())
        }
    }
}
