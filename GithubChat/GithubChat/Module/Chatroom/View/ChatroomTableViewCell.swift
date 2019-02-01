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

    private var viewModel: ChatroomCellViewModel?

    private var leftBubbleImage: UIImage = {
        return UIImage(named: "left_bubble")!.resizableImage(withCapInsets: UIEdgeInsets(top: 15, left: 25, bottom: 20, right: 20), resizingMode: .tile)
    }()

    private var rightBubbleImage: UIImage = {
        return UIImage(named: "right_bubble")!.resizableImage(withCapInsets: UIEdgeInsets(top: 15, left: 20, bottom: 20, right: 25), resizingMode: .tile)
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
        contentLabel.text = viewModel.text

        setupBubbleStyle(viewModel.style)

        setupSentStatus(sent: viewModel.sent)

        setNeedsLayout()
    }

    private func setupSentStatus(sent: Observable<Bool>) {
        sent.valueChangedHotStart = { [weak self] isSent in
            self?.contentView.alpha = isSent ? 1.0 : 0.4
        }
    }

    private func setupBubbleStyle(_ style: ChatroomCellViewModel.Style) {
        switch style {
        case .left:
            bubbleImageView.image = leftBubbleImage
            bubbleRightConstraint?.isActive = false
            bubbleLeftConstraint?.isActive = true
            labelLeftConstraint?.constant = 20
            labelRightConstraint?.constant = -10
        case .right:
            bubbleImageView.image = rightBubbleImage
            bubbleLeftConstraint?.isActive = false
            bubbleRightConstraint?.isActive = true
            labelLeftConstraint?.constant = 10
            labelRightConstraint?.constant = -20
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel?.sent.valueChangedHotStart = nil
    }

    private var bubbleLeftConstraint: NSLayoutConstraint?
    private var bubbleRightConstraint: NSLayoutConstraint?
    private var labelLeftConstraint: NSLayoutConstraint?
    private var labelRightConstraint: NSLayoutConstraint?
    private func initLayout() {
        selectionStyle = .none
        let screenSize = UIScreen.main.bounds.size
        bubbleImageView.constraints(snapTo: contentView, top: 10, bottom: 10).activate()
        bubbleLeftConstraint = bubbleImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10)
        bubbleRightConstraint = bubbleImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10)
        bubbleImageView.widthAnchor.constraint(lessThanOrEqualToConstant: screenSize.width*0.6).isActive = true
        contentLabel.constraints(snapTo: bubbleImageView, top: 10, bottom: 10).activate()

        labelLeftConstraint = contentLabel.leftAnchor.constraint(equalTo: bubbleImageView.leftAnchor)
        labelRightConstraint = contentLabel.rightAnchor.constraint(equalTo: bubbleImageView.rightAnchor)

        labelLeftConstraint?.isActive = true
        labelRightConstraint?.isActive = true
    }
}
