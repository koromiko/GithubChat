//
//  GithubService.swift
//  GithubChat
//
//  Created by Neo on 2019/1/28.
//  Copyright © 2019 STH. All rights reserved.
//

import Foundation

class GithubService {
    let service: NetworkService

    init(service: NetworkService = NetworkService()) {
        self.service = service
        self.service.domainErrorHandler = self.quotaLimitErrorHandler()
    }

    func getUsers(results: Results<[User]>) {
        service.getRequest(urlString: "https://api.github.com/users", parameter: ["page": 1, "per_page": 100], results: results)
    }

    /// Check the github header exists and examine if the limit has been reached
    private func quotaLimitErrorHandler() -> ((URLResponse) -> Error?) {
        return { response in
            if let response = response as? HTTPURLResponse,
                let remainingRequestsString = response.allHeaderFields["X-RateLimit-Remaining"] as? String,
                let remainingRequests = Int(remainingRequestsString),
                remainingRequests <= 0 {

                if let resetTimeString = response.allHeaderFields["X-RateLimit-Reset"] as? String,
                    let resetTimestamp = TimeInterval(resetTimeString) {
                    let resetTime = Date(timeIntervalSince1970: resetTimestamp)
                    return HttpError.reachLimit(resetTime: resetTime)
                } else {
                    return HttpError.reachLimit(resetTime: nil)
                }
            }
            return nil
        }
    }
}
