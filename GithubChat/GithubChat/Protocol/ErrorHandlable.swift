//
//  ErrorHandlable.swift
//  GithubChat
//
//  Created by ShihTing on 2019/02/01.
//  Copyright © 2019 STH. All rights reserved.
//

import Foundation

/// Conform this protocol to add error handling support for all http errors. Only need to implement the displayError(msg: String)
protocol HttpErrorHandlable {
    /// implement this for handling the display of the error message
    func displayError(msg: String)

    /// Pass the errro for handle the error cases from the protocol extension
    func handle(error: Error)
}

extension HttpErrorHandlable {
    func handle(error: Error) {
        guard let httpError = error as? HttpError else {
            // Log the unhandled errors
            assert(false, "Unhandled error: \(error.localizedDescription)")
            displayError(msg: "Unkown error. Please update the app and try again.")
        }
        var msg: String?
        switch httpError {
        case .jsonFormatError(let e):
            msg = "Server went wrong, please try again later. Info: \(e.localizedDescription)"
        case .reachLimit(let resetTime):
            let formatter = WeekDateTimeFormatter()
            if let resetTime = resetTime {
                msg = "You have reached the request limit, please wait until \(formatter.dateToString(resetTime))"
            } else {
                msg = "You have reached the request limit, please try again later"
            }
        case .urlFormatError:
            // Log the url format error
            assert(false, "The provided url format is wrong!")
        case .unknown(let e):
            // Log the unhandled error
            msg = "Something went wrong, please try again later. Info: \(e?.localizedDescription ?? "")"
        }
        if let unwrappedMsg = msg {
            displayError(msg: unwrappedMsg)
        }
    }
}
