//
//  ChatroomService.swift
//  GithubChat
//
//  Created by Neo on 2019/1/29.
//  Copyright © 2019 STH. All rights reserved.
//

import Foundation
/**
 Service for fetching the chatroom resource from server (mock behavior)
 */
class ChatroomService {
    /// Shared instance for mocking the memory-persistent server behavior
    static let shared: ChatroomService = ChatroomService()

    /// Mock the server storage
    private var messages: [Int: [Message]] = [:]

    func getChatroomInfo(userId: Int, result: Results<Chatroom>) {
        DispatchQueue.global().async {
            sleep(1)
            let user = User(id: userId, login: "mockLogin", avatarUrl: "mockAvatarURL")
            var chatroom = Chatroom(users: [user], id: "1", messages: [])
            if let messages = self.messages[userId] {
                chatroom.messages = messages
            }
            DispatchQueue.main.async {
                result.completeClosure(chatroom)
            }
        }
    }

    /// Simulate the echo by using the closure as callback
    private var fakeMessageRepeater: ((String) -> Void)?
    func observingMessage(from userId: Int, onReceive: Results<Message>) {
        fakeMessageRepeater = { [weak self] text in
            if let msg = self?.generateNextMessage(sender: userId, text: text) {
                var messages = self?.messages[userId] ?? [Message]()
                messages.append(msg)
                self?.messages[userId] = messages
                DispatchQueue.main.async {
                    onReceive.completeClosure(msg)
                }
            }
        }
    }

    /// Send message to specified user
    func sendMessage(to userId: Int, text: String, result: Results<Void>) {
        DispatchQueue.global().async {
            sleep(1)
            let message = self.generateNextMessage(sender: AuthService.shared.currentUserId,
                                              text: text)

            var messages = self.messages[userId] ?? [Message]()
            messages.append(message)
            self.messages[userId] = messages

            DispatchQueue.main.async {
                result.completeClosure(())
            }

            // Fake the reply with an echo
            sleep(1)
            self.fakeMessageRepeater?(text)
        }
    }

    // Mock the unique id issued by server
    private var maxId: Int = 0
    private func generateNextMessage(sender: Int, text: String) -> Message {
        maxId += 1
        let message = Message(id: maxId,
                              content: text,
                              senderId: sender)
        return message
    }
}
