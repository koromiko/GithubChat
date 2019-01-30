//
//  ChatroomController.swift
//  GithubChat
//
//  Created by Neo on 2019/1/28.
//  Copyright © 2019 STH. All rights reserved.
//

import Foundation

class ChatroomController {

    weak var viewModel: ChatroomViewModel?
    let service: ChatroomService

    private let user: User

    init(user: User, viewModel: ChatroomViewModel, chatroomService: ChatroomService = ChatroomService()) {
        self.service = chatroomService
        self.user = user
        self.viewModel = viewModel
    }

    func start() {
        viewModel?.chatroomTitle.value = user.login
        service.getChatroomInfo(userId: user.id, result: Results<Chatroom>(complete: { [weak self] (chatroom) in
            guard let unwrappedSelf = self else { return }
            unwrappedSelf.viewModel?.cellViewModels.value = unwrappedSelf.buildMessageViewModels(messages: chatroom.messages)
        }))
    }

    func buildMessageViewModels(messages: [Message]) -> [ChatroomCellViewModel] {
        return messages.map {
            let vm = ChatroomCellViewModel(style: .left, text: $0.content)
            return vm
        }
    }
}
