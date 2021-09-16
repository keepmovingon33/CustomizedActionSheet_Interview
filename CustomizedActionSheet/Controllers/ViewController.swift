//
//  ViewController.swift
//  CustomizedActionSheet
//
//  Created by Sky on 16/09/2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let items: [Item] = [Item(name: "AmCham China"), Item(name: "AmCham China")]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initUI()
    }
    
    private func initUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let actionSheet = storyboard.instantiateViewController(withIdentifier: "ActionSheetViewController") as! ActionSheetViewController
        actionSheet.items = items.sorted(by: {$0.name > $1.name} )
        actionSheet.modalPresentationStyle = .custom
        actionSheet.transitioningDelegate = self
        self.present(actionSheet, animated: true)
    }
}

extension ViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let height = items.count > 3 ? 400 : (items.count + 1) * 100
        return ActionSheetPresentationController(presentedViewController: presented, presenting: presenting, topGap: UIScreen.main.bounds.height - CGFloat(height))
    }
}

