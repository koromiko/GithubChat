//
//  ChatroomInputView.swift
//  GithubChat
//
//  Created by Neo on 2019/1/30.
//  Copyright © 2019 STH. All rights reserved.
//

import UIKit


protocol ChatroomInputViewDelegate: AnyObject {
    func keyboardWillShow(frame: CGRect)
    func keyboardWillHide(farme: CGRect)
    func returnKeyPressed()
}

class ChatroomInputView: UIView {
    weak var delegate: ChatroomInputViewDelegate?

    lazy var messageTextfield: UITextField = {
        let textfield: UITextField = generateSubview()
        textfield.borderStyle = .roundedRect
        textfield.tintColor = UIColor.darkGray
        textfield.delegate = self
        return textfield
    }()

    lazy var submitBtn: UIButton = {
        let btn: UIButton = generateSubview()
        btn.setTitle("Send", for: .normal)
        return btn
    }()

    init() {
        super.init(frame: .zero)
        initLayout()
        registrterKeyboardNotification()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initLayout()
        registrterKeyboardNotification()
    }

    func registrterKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(_ aNotification: Notification) {
        if let frame = aNotification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            delegate?.keyboardWillShow(frame: frame)
        }
    }

    @objc func keyboardWillHide(_ aNotificaition: Notification) {
        if let frame = aNotificaition.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            delegate?.keyboardWillHide(farme: frame)
        }
    }

    private func initLayout() {
        backgroundColor = UIColor.lightGray
        messageTextfield.constraints(snapTo: self, top: 10, left: 10).activate()
        [messageTextfield.rightAnchor.constraint(equalTo: submitBtn.leftAnchor, constant: -10),
         messageTextfield.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10),
         submitBtn.centerYAnchor.constraint(equalTo: messageTextfield.centerYAnchor),
         submitBtn.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15)].activate()
    }

}

extension ChatroomInputView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.delegate?.returnKeyPressed()
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {

    }

    func textFieldDidEndEditing(_ textField: UITextField) {

    }
}
