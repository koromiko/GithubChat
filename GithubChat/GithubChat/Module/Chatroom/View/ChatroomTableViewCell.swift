//
//  ChatroomTableViewCell.swift
//  GithubChat
//
//  Created by Neo on 2019/1/28.
//  Copyright © 2019 STH. All rights reserved.
//

import UIKit

struct ChatroomCellViewModel {
    enum Style {
        case left
        case right
    }

    let style: Style
    let text: String
    let sent = Observable(true)

    init(style: Style, text: String) {
        self.style = style
        self.text = text
    }
}

class ChatroomTableViewCell: UITableViewCell {

    lazy var contentLabel: UILabel = {
        let label: UILabel = contentView.generateSubview()
        label.numberOfLines = 0
        label.textColor = UIColor.white
        return label
    }()

    lazy var bubbleImageView: UIImageView = {
        let imageView: UIImageView = contentView.generateSubview()
        imageView.contentMode = .scaleToFill
        return imageView
    }()

    private var leftBubbleImage: UIImage = {
        return UIImage(named: "left_bubble")!.resizableImage(withCapInsets: UIEdgeInsets(top: 15, left: 25, bottom: 20, right: 20), resizingMode: .tile)
    }()

    private var rightBubbleImage: UIImage = {
        return UIImage(named: "right_bubble")!.resizableImage(withCapInsets: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 20))
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initLayout()
    }

    func setup(viewModel: ChatroomCellViewModel) {
        self.viewModel = viewModel

        switch viewModel.style {
        case .left:
            bubbleImageView.image = leftBubbleImage
            bubbleRightConstraint?.isActive = false
            bubbleLeftConstraint?.isActive = true
        case .right:
            bubbleImageView.image = rightBubbleImage
            bubbleLeftConstraint?.isActive = false
            bubbleRightConstraint?.isActive = true
        }
        contentLabel.text = viewModel.text

        viewModel.sent.valueChanged = { [weak self] isSent in
            self?.contentView.alpha = isSent ? 1.0 : 0.4
        }
    }

    var viewModel: ChatroomCellViewModel?

    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel?.sent.valueChanged = nil
    }

    var bubbleLeftConstraint: NSLayoutConstraint?
    var bubbleRightConstraint: NSLayoutConstraint?

    private func initLayout() {
        let screenSize = UIScreen.main.bounds.size
        bubbleImageView.constraints(snapTo: contentView, top: 10, bottom: 10).activate()
        bubbleLeftConstraint = bubbleImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10)
        bubbleRightConstraint = bubbleImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10)
        bubbleLeftConstraint?.isActive = true
        bubbleRightConstraint?.isActive = false
        bubbleImageView.widthAnchor.constraint(lessThanOrEqualToConstant: screenSize.width*0.6).isActive = true
        contentLabel.constraints(snapTo: bubbleImageView, top: 10, left: 20, bottom: 10, right: 10).activate()
    }
}
