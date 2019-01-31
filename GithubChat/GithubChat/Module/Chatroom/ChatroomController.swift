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

    init(user: User, viewModel: ChatroomViewModel, chatroomService: ChatroomService = ChatroomService.shared) {
        self.service = chatroomService
        self.user = user
        self.viewModel = viewModel
    }

    func start() {
        viewModel?.chatroomTitle.value = user.login
        service.getChatroomInfo(userId: user.id, result: Results<Chatroom>(complete: { [weak self] (chatroom) in
            guard let unwrappedSelf = self else { return }
            let viewModels = unwrappedSelf.buildMessageViewModels(messages: chatroom.messages)
            unwrappedSelf.viewModel?.cellViewModels.reloadData(viewModels)

        }))

        service.observingMessage(from: user.id, onReceive: Results<Message>(complete: { [weak self] (message) in
            self?.handleMessageReceived(message: message)
        }, errorClosure: { (error) in

        }))
    }

    private func handleMessageReceived(message: Message) {
        if let vm = self.buildMessageViewModels(messages: [message]).first {
            viewModel?.cellViewModels.append(vm)
        }
    }

    func sendMessage(text: String) {
        guard let viewModel = viewModel else { return }

        viewModel.inputText.value = nil

        let vm = ChatroomCellViewModel(style: .right, text: text)
        vm.sent.value = false
        viewModel.cellViewModels.append(vm)
        let dataIndex = viewModel.cellViewModels.count - 1
        service.sendMessage(to: user.id, text: text, result: Results<Void>(complete: { [weak self] (_) in
            vm.sent.value = true
            self?.viewModel?.cellViewModels[dataIndex] = vm
        }, errorClosure: { (error) in

        }))
    }

    func buildMessageViewModels(messages: [Message]) -> [ChatroomCellViewModel] {
        return messages.map {
            let style: ChatroomCellViewModel.Style = $0.senderId == user.id ? .left : .right
            let vm = ChatroomCellViewModel(style: style, text: $0.content)
            return vm
        }
    }

}
