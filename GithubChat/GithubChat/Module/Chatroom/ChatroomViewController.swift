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
    let inputText = Observable<String?>("")
    let cellViewModels = ArrayObservable<ChatroomCellViewModel>()
}

class ChatroomViewController: UIViewController, SingleTypeTableViewController {
    typealias CellType = ChatroomTableViewCell

    private let controller: ChatroomController
    private let viewModel: ChatroomViewModel

    private var tapGestureRecognizer: UITapGestureRecognizer?

    private var messageInputViewBottomConstraint: NSLayoutConstraint?

    lazy var tableView: UITableView = {
        let tableView = generateTableView()
        tableView.separatorStyle = .none
        return tableView
    }()

    lazy var messageInputView: ChatroomInputView = {
        let inputView: ChatroomInputView = view.generateSubview()
        inputView.delegate = self
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
        messageInputView.constraints(snapTo: view, left: 0, right: 0).activate()
        messageInputViewBottomConstraint = messageInputView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        messageInputViewBottomConstraint?.isActive = true
        messageInputView.topAnchor.constraint(equalTo: tableView.bottomAnchor).isActive = true
    }

    private func initBinding() {
        viewModel.chatroomTitle.valueChanged = { [weak self] title in
            self?.title = title
        }

        viewModel.cellViewModels.dataReloaded = { [weak self] () in
            self?.tableView.isHidden = false
            self?.tableView.reloadData()
        }

        viewModel.cellViewModels.valueChanged = { [weak self] (index, actionType) in
            self?.handleCellValueChanged(at: index, actionType: actionType)
        }

        viewModel.inputText.valueChanged = { [weak self] text in
            self?.messageInputView.text = text
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initBinding()
        controller.start()
    }

    private func handleCellValueChanged(at index: Int, actionType: ArrayObservable<ChatroomCellViewModel>.Action) {
        let indexPaths = [IndexPath(row: index, section: 0)]
        tableView.beginUpdates()
        switch actionType {
        case .insert:
            tableView.insertRows(at: indexPaths, with: .automatic)
        case .remove:
            tableView.deleteRows(at: indexPaths, with: .automatic)
        case .reload:
            tableView.reloadRows(at: indexPaths, with: .automatic)
        }
        tableView.endUpdates()
    }

}

extension ChatroomViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellViewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatroomTableViewCell.uniqueIdentifier, for: indexPath) as? ChatroomTableViewCell else {
            assert(false, "Cell type \(CellType.description()) is not handled")
            return UITableViewCell()
        }

        let vm = viewModel.cellViewModels[indexPath.row]
        cell.setup(viewModel: vm)
        return cell
    }
}

extension ChatroomViewController: ChatroomInputViewDelegate {
    func returnKeyPressed(text: String) {
        controller.sendMessage(text: text)
    }

    func sendButtomPressed(text: String) {
        controller.sendMessage(text: text)
    }

    func adjustInputFrame(offset: CGFloat) {
        messageInputViewBottomConstraint?.constant = -offset
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    func keyboardWillShow(frame: CGRect) {
        if self.tapGestureRecognizer == nil {
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(touchToHideKeyboard))
            view.addGestureRecognizer(tapGestureRecognizer)
            self.tapGestureRecognizer = tapGestureRecognizer
        }

        adjustInputFrame(offset: frame.height)
    }

    func keyboardWillHide() {
        if let gestureRecognizer = self.tapGestureRecognizer {
            view.removeGestureRecognizer(gestureRecognizer)
        }
        adjustInputFrame(offset: 0)
    }

    @objc func touchToHideKeyboard() {
        if let gestureRecognizer = self.tapGestureRecognizer {
            view.removeGestureRecognizer(gestureRecognizer)
            messageInputView.unfocus()
            tapGestureRecognizer = nil
        }
    }
}
