//
//  GithubService.swift
//  GithubChat
//
//  Created by Neo on 2019/1/28.
//  Copyright © 2019 STH. All rights reserved.
//

import Foundation

class GithubService {
    func getUsers(results: Results<[User]>) {
        DispatchQueue.global().async {
//            sleep(1)
            do {
                if let jsonPath = Bundle(for: type(of: self)).path(forResource: "users", ofType: "json") {
                    let data = try Data(contentsOf: URL(fileURLWithPath: jsonPath))
                    let users = try JSONDecoder().decode([User].self, from: data)
                    DispatchQueue.main.async {
                        results.completeClosure(users)
                    }
                }
            } catch let e {
                DispatchQueue.main.async {
                    results.errorClosure?(e)
                }
            }
        }

    }
}
