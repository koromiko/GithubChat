//
//  UserListTableViewCell.swift
//  GithubChat
//
//  Created by Neo on 2019/1/28.
//  Copyright © 2019 STH. All rights reserved.
//

import UIKit

class UserListCellViewModel {
    let name: String
    let avatarImage: UIImage
    var userDidSelect: (() -> Void)?
    init(name: String, avatarImage: UIImage) {
        self.name = name
        self.avatarImage = avatarImage
    }
}

class UserListTableViewCell: UITableViewCell {

    lazy var avatarImageView: UIImageView = {
        let imageView: UIImageView = contentView.generateSubview()
        return imageView
    }()

    lazy var nameLabel: UILabel = {
        let label: UILabel = contentView.generateSubview()
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initLayout()
    }

    private func initLayout() {
        avatarImageView.constraints(width: 35, height: 35).activate()
        avatarImageView.constraints(snapTo: contentView, top: 20, left: 20, bottom: 20).activate()

        [nameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor, constant: 0),
         nameLabel.leftAnchor.constraint(equalTo: avatarImageView.rightAnchor, constant: 20)].activate()
    }

    func setup(viewModel: UserListCellViewModel) {
        avatarImageView.image = viewModel.avatarImage
        nameLabel.text = viewModel.name
    }
}
