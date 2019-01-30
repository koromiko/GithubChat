//
//  ChatroomViewController.swift
//  GithubChat
//
//  Created by Neo on 2019/1/28.
//  Copyright © 2019 STH. All rights reserved.
//

import UIKit

class ChatroomViewModel {
    let chatroomTitle = Observable("")
    let cellViewModels = Observable([ChatroomCellViewModel]())
}

class ChatroomViewController: UIViewController, SingleTypeTableViewController {
    typealias CellType = ChatroomTableViewCell

    private let controller: ChatroomController
    private let viewModel: ChatroomViewModel

    lazy var tableView: UITableView = {
        let tableView = generateTableView()
        tableView.separatorStyle = .none
        return tableView
    }()

    lazy var messageInputView: ChatroomInputView = {
        let inputView: ChatroomInputView = view.generateSubview()
        return inputView
    }()

    init(user: User, controller: ChatroomController? = nil) {
        let viewModel = ChatroomViewModel()
        self.viewModel = viewModel
        if let controller = controller {
            self.controller = controller
            self.controller.viewModel = viewModel
        } else {
            self.controller = ChatroomController(user: user, viewModel: viewModel)
        }
        super.init(nibName: nil, bundle: nil)
        initLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Cannot use this class in interface builder")
    }

    private func initLayout() {
        view.backgroundColor = .white
        tableView.constraints(snapTo: view, top: 0, left: 0, right: 0).activate()
        messageInputView.constraints(snapTo: view, left: 0, bottom: 0, right: 0).activate()
        messageInputView.topAnchor.constraint(equalTo: tableView.bottomAnchor).isActive = true
    }

    private func initBinding() {
        viewModel.chatroomTitle.valueChanged = { [weak self] title in
            self?.title = title
        }

        viewModel.cellViewModels.valueChanged = { [weak self] _ in
            self?.tableView.isHidden = false
            self?.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initBinding()
        controller.start()
    }

}

extension ChatroomViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellViewModels.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: ChatroomTableViewCell.uniqueIdentifier, for: indexPath) as? ChatroomTableViewCell {
            let vm = ChatroomCellViewModel(style: .left, text: "Requests that return multiple items will be paginated to 30 items by default. You can specify further pages with the ?page parameter. For some resources, you can also set a custom page size up to 100 with the ?per_page parameter.")
            cell.setup(viewModel: vm)
            return cell
        }
        assert(false, "Cell type \(CellType.description()) is not registered")
        return UITableViewCell()
    }
}
