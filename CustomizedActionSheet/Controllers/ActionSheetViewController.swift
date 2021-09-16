//
//  ActionSheetViewController.swift
//  CustomizedActionSheet
//
//  Created by Sky on 16/09/2021.
//

import UIKit

struct Item {
    let name: String
}

class ActionSheetViewController: UIViewController {

    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var items: [Item] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initUI()
    }
    
    private func initUI() {
        indicatorView.setBorder(color: .clear, width: 0, radius: 5)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
}

extension ActionSheetViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActionSheetTableViewCell", for: indexPath) as! ActionSheetTableViewCell
        cell.titleLabel.text = items[indexPath.row].name
        return cell
    }
}
