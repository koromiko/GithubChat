//
//  UserListController.swift
//  GithubChat
//
//  Created by Neo on 2019/1/28.
//  Copyright © 2019 STH. All rights reserved.
//

import UIKit

class UserListController {
    let service: GithubService

    weak var viewModel: UserListViewModel?

    init(service: GithubService = GithubService()) {
        self.service = service
    }

    func start() {
        viewModel?.isLoading.value = true
        service.getUsers(results: Results(complete: { [weak self] (users) in
            self?.viewModel?.isLoading.value = false
            if let viewModels = self?.buildViewModels(users: users) {
                self?.viewModel?.cellViewModels.value = viewModels
            }
        }, errorClosure: { [weak self] (error) in
            self?.viewModel?.isLoading.value = false

        }))
    }

    private func buildViewModels(users: [User]) -> [UserListCellViewModel] {
        return users.map { (user) -> UserListCellViewModel in
            let vm = UserListCellViewModel(name: "@\(user.login)", avatarImage: UIImage(named: "user")!)
            vm.userDidSelect = { [weak self] in
                self?.userSelect(user: user)
            }
            return vm
        }
    }

    private func userSelect(user: User) {
        viewModel?.openChatroom?(user)
    }
}
