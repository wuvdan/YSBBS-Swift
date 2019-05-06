//
//  HomeViewController.swift
//  YSBBS-Swift
//
//  Created by wudan on 2019/2/28.
//  Copyright © 2019 com.wudan. All rights reserved.
//

import UIKit
import SwiftyJSON
import SnapKit
import MJRefresh
import EmptyPage
import JXSegmentedView

class HomeViewController: UIViewController {
    
    private var modelArray:[HomeTopicListModel]?
    private var pageNo: Int = 1
    private var totalPages: Int = 0
    private let tableView: UITableView = {
        let t = UITableView.init()
        t.tableFooterView = UIView()
        t.rowHeight = UITableView.automaticDimension
        t.estimatedRowHeight = 65
        t.backgroundColor = UIColor.groupTableViewBackground
        t.separatorStyle = .none
        t.showsVerticalScrollIndicator = false
        t.register(TopicListTableViewCell.classForCoder(), forCellReuseIdentifier: "TopicListTableViewCell")
        
        return t
    }()
    
    private let header = MJRefreshNormalHeader()
    private let footer = MJRefreshAutoNormalFooter()
    
    public var currentCell: TopicListTableViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        extendedLayoutIncludesOpaqueBars = true
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(bottomLayoutGuide.snp.top)
        }
        
        footer.setRefreshingTarget(self, refreshingAction: #selector(HomeViewController.footerRefresh))
        tableView.mj_footer = footer

        header.setRefreshingTarget(self, refreshingAction: #selector(HomeViewController.headerRefresh))
        tableView.mj_header = header
        header.beginRefreshing()
        
        NotificationCenter.default.addObserver(self, selector: #selector(postTopicSuccessNotification), name: NSNotification.Name(rawValue: PostTopicViewControllerPostTopicNotification), object: nil)
        
        let emptyView = EmptyPageView.ContentView.standard
            .set(buttonTitle: "刷新")
            .config(button: { (button) in
                button.backgroundColor = .clear
            })
            .set(image: UIImage(named: "empty")!)
            .set(title: "暂时还没有数据~", color: UIColor.lightGray, font: UIFont.boldSystemFont(ofSize: 13))
            .mix()
        tableView.emptyView = emptyView
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func postTopicSuccessNotification() {
        pageNo = 1
        loadListData(page: pageNo)
    }
    
    @objc func footerRefresh(sender: Any) {
        if pageNo < totalPages {
            pageNo = pageNo + 1
            loadListData(page: pageNo)
        } else {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                self.footer.endRefreshing()
            }
        }
    }
    
    @objc func headerRefresh(sender: Any) {
        pageNo = 1
        loadListData(page: pageNo)
    }
    
    func loadListData(page:Int) {
        YSNetWorking().getHomeTopicList(pageNo: page, successComplete: { (data) -> (Void) in
            let dic:Dictionary = data
            let dataDic:Dictionary<String, Any> = dic["data"] as! Dictionary
            let listArray: [Dictionary<String, Any>] = dataDic["list"] as! [Dictionary<String, Any>]
            if page == 1 {
                self.modelArray = Array()
                for (_, key) in listArray.enumerated() {
                    self.modelArray?.append(HomeTopicListModel.init(jsonData: JSON.init(key)))
                }
                self.header.endRefreshing()
            } else {
                for (_, key) in listArray.enumerated() {
                    self.modelArray?.append(HomeTopicListModel.init(jsonData: JSON.init(key)))
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
        }) { (error) -> (Void) in
            
        }
    }
}


// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
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
        let cell: TopicListTableViewCell? = (tableView.dequeueReusableCell(withIdentifier: "TopicListTableViewCell", for: indexPath) as! TopicListTableViewCell)
        if let modelAray = modelArray {
            let model = modelAray[indexPath.section]
            cell!.model = model
            cell!.didTappedCommentButtonBlock = {
                let vc = TopicDetailViewController()
                vc.listModel = model
                self.navigationController?.pushViewController(vc, animated: true)
            }
            cell!.didTappedLikeButtonBlock = { model in
                model.isLike = !model.isLike
                if (model.isLike) {
                    model.likeNum += 1
                } else {
                    model.likeNum -= 1
                }
                
                UIView.performWithoutAnimation {
                    self.tableView.reloadSections(IndexSet.init(integer: indexPath.section), with: .none)
                }
                YSNetWorking().likeTopic(topicId: model.id, isLike: model.isLike, successComplete: { (data) -> (Void) in
                }, falidReasonHandle: { (error) -> (Void) in
                    
                })
            }
        }
        return cell!
    }
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let tempArray = modelArray {
            let model = tempArray[indexPath.section]
            return model.getCellHeight()
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentCell = (tableView.cellForRow(at: indexPath) as! TopicListTableViewCell)
        let vc = TopicDetailViewController()
        vc.listModel = modelArray![indexPath.section]
        navigationController?.pushViewController(vc, animated: true)
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

extension HomeViewController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}
