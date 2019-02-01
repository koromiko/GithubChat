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

    /// Assign this closure for handling the domain-specific error
    var domainErrorHandler: ((URLResponse) -> Error?)?

    init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    /// Make a http get reuqest with query parameter
    func getRequest<T: Decodable>(urlString: String, parameter: [String: Any]? = nil, results: Results<T>) {
        var path = urlString
        if let param = parameter {
            path.append("?")
            path.append(urlEncode(param))
        }
        if let url = URL(string: path) {
            let dataTask = session.dataTask(with: url) { [weak self] (data, response, error) in
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
                    } else if let error = self?.domainErrorHandler?(response) {
                        results.errorClosure?(error)
                    }
                }

                /// Currently unhandable error
                results.errorClosure?(HttpError.unknown(error: error))
            }
            dataTask.resume()
        } else {
            results.errorClosure?(HttpError.urlFormatError)
        }
    }

    // Encode the url from dictionary, with url encoding
    private func urlEncode(_ parameter: [String: Any]) -> String {
        let querys = parameter.reduce(into: [String]()) { (q, keyValue) in
            q.append("\(keyValue.key)=\(keyValue.value)")
        }
        return querys.joined(separator: "&")
    }

}
