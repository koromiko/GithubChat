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

    var fakeMessageRepeater: ((String) -> Void)?
    func observingMessage(from userId: Int, onReceive: Results<Message>) {
        fakeMessageRepeater = { [weak self] text in
            if let msg = self?.generateNextMessage(sender: userId, text: text) {
                onReceive.completeClosure(msg)
            }
        }
    }

    func sendMessage(to userId: Int, text: String, result: Results<Void>) {
        DispatchQueue.global().async {
            sleep(1)
            let message = self.generateNextMessage(sender: AuthService.shared.currentUserId,
                                              text: text)

            var messages = self.messages[userId] ?? [Message]()
            messages.append(message)
            self.messages[userId] = messages

            result.completeClosure(())

            // Fake the reply with an echo
            sleep(1)
            self.fakeMessageRepeater?(text)
        }
    }

    private var maxId: Int = 0
    private func generateNextMessage(sender: Int, text: String) -> Message {
        maxId += 1
        let message = Message(id: maxId,
                              content: text,
                              senderId: sender)
        return message
    }
}
