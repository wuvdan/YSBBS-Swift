//
//  UserFellowViewController.swift
//  YSBBS-Swift
//
//  Created by wudan on 2019/4/15.
//  Copyright © 2019 com.wudan. All rights reserved.
//

import UIKit
import MJRefresh
import SnapKit
import SwiftyJSON
import EmptyPage

class UserFellowViewController: UIViewController {

    private var modelArray: [UserFellowUserModel]?
    private var pageNo: Int = 1
    private var totalPages: Int = 0
    private let header = MJRefreshNormalHeader()
    private let footer = MJRefreshAutoNormalFooter()
    private lazy var tableView: UITableView = {
        let t = UITableView.init()
        t.tableFooterView = UIView()
        t.rowHeight = UITableView.automaticDimension
        t.estimatedRowHeight = 65
        t.backgroundColor = UIColor.groupTableViewBackground
        t.showsVerticalScrollIndicator = false
        t.delegate = self
        t.dataSource = self
        t.register(UserFellowUserCell.classForCoder(), forCellReuseIdentifier: "UserFellowUserCell")
        return t
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "我的关注"
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
            .set(title: "您还没有关注任何用户", color: UIColor.lightGray, font: UIFont.boldSystemFont(ofSize: 13))
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

@objc private extension UserFellowViewController {
    func postTopicSuccessNotification() {
        pageNo = 1
        loadListData(page: pageNo)
    }
    
    func footerRefresh(sender: Any) {
        if pageNo < totalPages {
            pageNo = pageNo + 1
            loadListData(page: pageNo)
        } else {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                self.footer.endRefreshing()
            }
        }
    }
    
    func headerRefresh(sender: Any) {
        pageNo = 1
        loadListData(page: pageNo)
    }
    
    func loadListData(page:Int) {
        YSNetWorking().getUserFellowTopicList(pageNo: page) { (data) -> (Void) in
            let dic:Dictionary = data
            let dataDic:Dictionary<String, Any> = dic["data"] as! Dictionary
            let listArray: [Dictionary<String, Any>] = dataDic["list"] as! [Dictionary<String, Any>]
            if page == 1 {
                self.header.endRefreshing()
                self.modelArray = Array()
                for (_, key) in listArray.enumerated() {
                    let json = JSON.init(key)
                    let model = UserFellowUserModel.init(jsonData: json)
                    self.modelArray?.append(model)
                }
            } else {
                for (_, key) in listArray.enumerated() {
                    let json = JSON.init(key)
                    let model = UserFellowUserModel.init(jsonData: json)
                    self.modelArray?.append(model)
                }
            }
            self.totalPages = dic["data"]!["totalPages"] as! Int
            
            
            if (page >= self.totalPages) {
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
        }
    }
}

// MARK: - UITableViewDataSource
extension UserFellowViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if let tempArray = modelArray {
            return tempArray.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UserFellowUserCell = tableView.dequeueReusableCell(withIdentifier: "UserFellowUserCell", for: indexPath) as! UserFellowUserCell
        cell.setup(model: modelArray![indexPath.section])
        return cell
    }
}

// MARK: - UITableViewDelegate
extension UserFellowViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = TopicDetailViewController()
//        vc.listModel = modelArray![indexPath.section]
//        navigationController?.pushViewController(vc, animated: true)
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
