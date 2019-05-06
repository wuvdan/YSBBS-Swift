//
//  NotificationViewController.swift
//  YSBBS-Swift
//
//  Created by wudan on 2019/4/9.
//  Copyright © 2019 com.wudan. All rights reserved.
//

import UIKit
import SwiftyJSON
import MJRefresh
import EmptyPage

class NotificationViewController: UIViewController {
    private let header = MJRefreshNormalHeader()
    private let footer = MJRefreshAutoNormalFooter()
    private var modelArray:[MessageListModel]?
    private var pageNo: Int = 1
    private var totalPages: Int = 0
    private lazy var tableView: UITableView = {
        let t = UITableView.init()
        t.tableFooterView = UIView()
        t.backgroundColor = .white
        t.separatorStyle = .none
        t.rowHeight = UITableView.automaticDimension
        t.estimatedRowHeight = 65
        t.dataSource = self
        t.delegate = self
        t.backgroundColor = .groupTableViewBackground
        t.showsVerticalScrollIndicator = false
        t.register(NotificationCell.classForCoder(), forCellReuseIdentifier: "NotificationCell")
        return t
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .groupTableViewBackground
        
        setupSubviewConstants()
        setupPlaceholerView()
        setupRefreshControl()
    }
    
    private func setupRefreshControl() {
        footer.setRefreshingTarget(self, refreshingAction: #selector(footerRefresh))
        tableView.mj_footer = footer
        header.setRefreshingTarget(self, refreshingAction: #selector(headerRefresh))
        tableView.mj_header = header
        header.beginRefreshing()
    }
    
    private func setupPlaceholerView() {
        let emptyView = EmptyPageView.ContentView.standard
            .set(buttonTitle: "刷新")
            .config(button: { (button) in
                button.backgroundColor = .clear
            })
            .set(image: UIImage(named: "empty")!)
            .set(title: "还没有任何通知消息", color: UIColor.lightGray, font: UIFont.boldSystemFont(ofSize: 13))
            .mix()
        tableView.emptyView = emptyView
    }
    
    private func setupSubviewConstants() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(bottomLayoutGuide.snp.top)
        }
    }
}

@objc private extension NotificationViewController {
    func loadListData(thePage: Int) {
        YSNetWorking().getMessgaeList(pageNo: thePage, successComplete: { (data) -> (Void) in
            let dic:Dictionary = data
            let dataDic:Dictionary<String, Any> = dic["data"] as! Dictionary
            let listArray: [Dictionary<String, Any>] = dataDic["list"] as! [Dictionary<String, Any>]
            
            if thePage == 1 {
                self.modelArray = Array()
                for (_, key) in listArray.enumerated() {
                    self.modelArray?.append(MessageListModel.init(jsonData: JSON.init(key)))
                }
                self.header.endRefreshing()
                
            } else {
                for (_, key) in listArray.enumerated() {
                    self.modelArray?.append(MessageListModel.init(jsonData: JSON.init(key)))
                }
            }
            self.totalPages = dic["data"]!["totalPages"] as! Int
            if (thePage >= self.totalPages) {
                self.footer.endRefreshingWithNoMoreData()
            } else {
                self.footer.endRefreshing()
            }
            if self.totalPages == 0 {
                self.footer.isHidden = true
            } else {
                self.footer.isHidden = false
            }
            self.tableView.reloadData()
        })
    }
    
    func footerRefresh(sender: Any) {
        if pageNo < totalPages {
            pageNo = pageNo + 1
            loadListData(thePage: pageNo)
        } else {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                self.footer.endRefreshing()
            }
        }
    }
    
    func headerRefresh(sender: Any) {
        pageNo = 1
        loadListData(thePage: pageNo)
    }
}


// MARK: - UITableViewDataSource
extension NotificationViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let array = modelArray {
            return array.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NotificationCell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        if let array = modelArray {
            cell.setup(array[indexPath.section])
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension NotificationViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc: NotificationDetalViewController = NotificationDetalViewController()
        if let array = modelArray {
            vc.messageModel = array[indexPath.section]
            navigationController?.pushViewController(vc, animated: true)
        }
        return
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        let cell = tableView.cellForRow(at: indexPath)
        UIView.animate(withDuration: 0.2) {
            cell?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        UIView.animate(withDuration: 0.2) {
            cell?.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
}
