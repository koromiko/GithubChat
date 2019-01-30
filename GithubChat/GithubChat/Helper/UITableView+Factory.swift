//
//  UITableView+Factory.swift
//  GithubChat
//
//  Created by Neo on 2019/1/28.
//  Copyright © 2019 STH. All rights reserved.
//

import UIKit

protocol SingleTypeTableViewController {
    associatedtype CellType: UITableViewCell
}
extension SingleTypeTableViewController where Self: UIViewController & UITableViewDelegate & UITableViewDataSource {
    func generateTableView(estimatedHeight: CGFloat = 75, defaultHidden: Bool = true) -> UITableView {
        let tableView: UITableView = view.generateSubview()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CellType.self, forCellReuseIdentifier: CellType.uniqueIdentifier)
        tableView.estimatedRowHeight = estimatedHeight
        tableView.isHidden = defaultHidden
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }
}
