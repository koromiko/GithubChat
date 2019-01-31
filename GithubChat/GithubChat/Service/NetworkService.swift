//
//  NetworkService.swift
//  GithubChat
//
//  Created by Neo on 2019/1/27.
//  Copyright © 2019 STH. All rights reserved.
//

import Foundation

enum HttpError: Error {
    case reachLimit(resetTime: Date?)
    case jsonFormatError(error: Error)
    case urlFormatError
    case unknown(error: Error?)
}

class NetworkService {
    private let session: URLSession

    init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    /// Make a http get reuqest with query parameter
    func getRequest<T: Decodable>(urlString: String, parameter: [String: Any], results: Results<T>) {
        if let url = URL(string: urlString) {
            session.dataTask(with: url) { [weak self] (data, response, error) in
                if let response = response as? HTTPURLResponse {
                    if response.statusCode >= 200 && response.statusCode < 300,
                        let data = data {
                        do {
                            let decoder = JSONDecoder()
                            let decoded = try decoder.decode(T.self, from: data)
                            results.completeClosure(decoded)
                        } catch let e {
                            results.errorClosure?(HttpError.jsonFormatError(error: e))
                        }
                        return
                    } else if self?.handleExceedLimit(headerFiled: response.allHeaderFields, results: results) ?? false {
                        return
                    }
                }

                /// Currently unhandable error
                results.errorClosure?(HttpError.unknown(error: error))
            }
        } else {
            results.errorClosure?(HttpError.urlFormatError)
        }
    }

    /// Check if reaching the request limit, return true if running out of quota
    private func handleExceedLimit<T>(headerFiled: [AnyHashable: Any], results: Results<T>) -> Bool {
        if let remainingRequests = headerFiled["X-RateLimit-Remaining"] as? Int, remainingRequests <= 0 {
            if let resetTime = headerFiled["X-RateLimit-Remaining"] as? TimeInterval {
                let resetTime = Date(timeIntervalSince1970: resetTime)
                results.errorClosure?(HttpError.reachLimit(resetTime: resetTime))
            } else {
                results.errorClosure?(HttpError.reachLimit(resetTime: nil))
            }
            return true
        }
        return false
    }

}
