////
////  ATCMenuTableViewController.swift
////  AppTemplatesFoundation
////
////  Created by Florian Marcu on 2/10/17.
////  Copyright © 2017 iOS App Templates. All rights reserved.
////
//
//import UIKit
//
//
//open class ATCMenuTableViewController: UITableViewController {
//
//    fileprivate var lastSelectedIndexPath: IndexPath?
//
//    var items: [ATCNavigationItem]
//    var user: ATCUser?
//
//    let cellClass: ATCMenuTableViewCellConfigurable.Type
//    let headerHeight: CGFloat
//
//    init(configuration: ATCMenuConfiguration, nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
//        self.items = configuration.items
//        self.user = configuration.user
//        self.cellClass = configuration.cellClass
//        self.headerHeight = configuration.headerHeight
//        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//
//        let cellNib = UINib(nibName: String(describing: cellClass), bundle: nil)
//        tableView.register(cellNib, forCellReuseIdentifier: String(describing: cellClass))
//
//        let headerNib = UINib(nibName: "ATCMenuHeaderTableViewCell", bundle:nil)
//        tableView.register(headerNib, forCellReuseIdentifier: "ATCMenuHeaderTableViewCell")
//
//        lastSelectedIndexPath = IndexPath(row: 0, section: 0)
//    }
//
//    required public init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override open func viewDidLoad() {
//        super.viewDidLoad()
//        tableView.tableFooterView = UIView()
//        let backgroundView = UIView()
//        backgroundView.backgroundColor = UIColor(displayP3Red: 39/255, green: 44/255, blue: 48/255, alpha: 1)
//        tableView.backgroundView = backgroundView
//        tableView.separatorColor = UIColor(red: 90/255, green: 90/255, blue: 90/255, alpha: 1)
//    }
//
//    // MARK: - Table view data source
//
//    override open func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return items.count
//    }
//
//    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: cellClass))
//        if let cell = cell as? ATCMenuTableViewCellConfigurable {
//            cell.configure(item: items[indexPath.row])
//        }
//
//        return cell!
//    }
//
//    override open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let dController = drawerController() {
//            if (lastSelectedIndexPath == indexPath) {
//                dController.toggleMenu()
//                return
//            }
//            let navigationController = dController.rootViewController
//            let item = items[indexPath.row]
//            if (item.type == .viewController) {
//                navigationController.setViewControllers([item.viewController], animated: false)
//                dController.toggleMenu()
//                lastSelectedIndexPath = indexPath
//            } else if (item.type == .logout) {
//                if let hostVC = dController.parent {
//                    hostVC.dismiss(animated: true, completion: nil)
//                }
//            }
//        }
//    }
//
//    override open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ATCMenuHeaderTableViewCell") as? ATCMenuHeaderTableViewCell
//        cell?.configureCell(user: user)
//        return cell
//    }
//
//    override open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        let totalHeight = self.tableView.bounds.height
//        let availableHeight = totalHeight - CGFloat(items.count) * 40
//        return min(self.headerHeight, availableHeight)
//    }
//}

