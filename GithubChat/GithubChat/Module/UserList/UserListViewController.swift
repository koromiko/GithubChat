//
//  UserListViewController.swift
//  GithubChat
//
//  Created by Neo on 2019/1/28.
//  Copyright © 2019 STH. All rights reserved.
//

import UIKit

class UserListViewModel {
    var cellViewModels = Observable([UserListCellViewModel]())
    var isLoading = Observable(false)
    var openChatroom: ((User) -> Void)?
    var alertMessage = Observable<String?>(nil)
}

class UserListViewController: UIViewController, SingleTypeTableViewController, AlertDisplayable {
    typealias CellType = UserListTableViewCell

    let controller: UserListController
    let viewModel: UserListViewModel = UserListViewModel()

    lazy var tableView: UITableView = {
        return generateTableView()
    }()

    lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator: UIActivityIndicatorView = view.generateSubview()
        indicator.style = .gray
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        return indicator
    }()

    init(controller: UserListController = UserListController()) {
        self.controller = controller
        self.controller.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        initLayout()
        initBinding()
    }

    required init?(coder aDecoder: NSCoder) {
        self.controller = UserListController()
        self.controller.viewModel = viewModel
        super.init(coder: aDecoder)
        initLayout()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initBinding()
        controller.start()
    }

    private func initLayout() {
        view.backgroundColor = .white
        tableView.constraints(snapTo: view).activate()
        [loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
         loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)].activate()
    }

    private func initBinding() {
        viewModel.cellViewModels.valueChanged = { [weak self] (_) in
            self?.tableView.reloadData()
        }

        viewModel.isLoading.valueChanged = { [weak self] isLoading in
            if isLoading {
                self?.showLoading()
            } else {
                self?.hideLoading()
            }
        }

        viewModel.openChatroom = { [weak self] user in
            self?.openChatroomPage(user: user)
        }

        viewModel.alertMessage.valueChanged = { [weak self] msg in
            if let msg = msg {
                self?.showAlert(title: "Error", message: msg)
            }
        }
    }

    private func openChatroomPage(user: User) {
        let vc = ChatroomViewController(user: user)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    private func showLoading() {
        loadingIndicator.startAnimating()
        tableView.isHidden = true
    }

    private func hideLoading() {
        loadingIndicator.stopAnimating()
        tableView.isHidden = false
    }
}

extension UserListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellViewModels.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: UserListTableViewCell.uniqueIdentifier, for: indexPath) as? UserListTableViewCell {
            let vm = viewModel.cellViewModels.value[indexPath.row]
            cell.setup(viewModel: vm)
            return cell
        } else {
            assert(false, "Cell type is not handled at \(indexPath)")
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vm = viewModel.cellViewModels.value[indexPath.row]
        vm.userDidSelect?()
    }
}
