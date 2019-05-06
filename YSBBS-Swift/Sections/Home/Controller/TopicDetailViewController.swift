//
//  TopicDetailViewController.swift
//  YSBBS-Swift
//
//  Created by wudan on 2019/4/3.
//  Copyright © 2019 com.wudan. All rights reserved.
//

import UIKit
import MJRefresh
import SwiftyJSON
import IQKeyboardManagerSwift

class TopicDetailViewController: UIViewController {
    
    private let tableView: UITableView = {
        let t = UITableView.init()
        t.tableFooterView = UIView()
        t.rowHeight = UITableView.automaticDimension
        t.estimatedRowHeight = 65
        t.backgroundColor = UIColor.groupTableViewBackground
        t.showsVerticalScrollIndicator = false
        t.keyboardDismissMode = .onDrag
        return t
    }()
    
    private lazy var collectionButton: UIButton = {
        let b = UIButton.init()
        b.setImage(kGetImage(imageName: "Collection_Button"), for: .selected)
        b.setImage(kGetImage(imageName: "UnCollection_Button"), for: .normal)
        b.addTarget(self, action: #selector(collectionButtonTapped), for: .touchUpInside)
        return b
    }()
    
    private let replyInputView: ReplyInputView = {
        let v = ReplyInputView.init(frame: .zero)
        return v
    }()
    
    var listModel: HomeTopicListModel!

    private var modelArray: [CommentListModel]?
    private var pageNo: Int = 1
    private var totalPages: Int = 1
    private let header = MJRefreshNormalHeader()
    private let footer = MJRefreshAutoNormalFooter()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubViews()
        setupRefrsh()
        setupInputView()
    }
    
    private func setupSubViews() {
        view.backgroundColor = .white
        title = "正文"
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(replyInputView)
        replyInputView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(bottomLayoutGuide.snp.top)
            make.height.equalTo(60)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(replyInputView.snp.top)
        }
        collectionButton.isSelected = listModel.isCollection
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: collectionButton)
        if listModel.isMy {
            navigationItem.rightBarButtonItems = [UIBarButtonItem.init(title: "删除", style: .done, target: self, action: #selector(deleteButtonTapped(sender:))), UIBarButtonItem.init(customView: collectionButton)]
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: collectionButton)
        }
    }
    
    private func setupRefrsh() {
        footer.setRefreshingTarget(self, refreshingAction: #selector(TopicDetailViewController.footerRefresh))
        tableView.mj_footer = footer
        
        header.setRefreshingTarget(self, refreshingAction: #selector(TopicDetailViewController.headerRefresh))
        tableView.mj_header = header
        header.beginRefreshing()
    }
    
    private func addComment(content: String) {
        YSNetWorking().addComment(content: content, topicId: listModel.id, successComplete: { (data) -> (Void) in
            print("\(data)")
            self.replyInputView.textView.text = ""
            self.pageNo = 1
            self.loadCommentList(page: self.pageNo)
        }) { (error) -> (Void) in
            
        }
    }
    
    private func loadCommentList(page: Int) {
        
        YSNetWorking().getCommentList(pageNo: page, topicId: self.listModel.id, successComplete: { (data) -> (Void) in
            let dic:Dictionary = data
            let dataDic:Dictionary<String, Any> = dic["data"] as! Dictionary
            let listArray: [Dictionary<String, Any>] = dataDic["list"] as! [Dictionary<String, Any>]
            self.totalPages = dic["data"]!["totalPages"] as! Int
            if page == 1 {
                self.header.endRefreshing()
              for (_, key) in listArray.enumerated() {
                  self.modelArray = Array()
                  self.modelArray?.append(CommentListModel.init(jsonData: JSON.init(key)))
              }
            } else {
              for (_, key) in listArray.enumerated() {
                  self.modelArray?.append(CommentListModel.init(jsonData: JSON.init(key)))
              }
          }
          
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

extension TopicDetailViewController: LZAlterViewDelegate {
    func alterView(_ alterView: LZAlterView, didSelectedAt index: Int) {
        YSNetWorking().delTopic(topicId: listModel.id, successComplete: { (data) -> (Void) in
            LZRemindBar.configuration(with: .info, show: .statusBar, contentText: "删除成功~").show(afterTimeInterval: 1.2)
            self.navigationController?.popViewController(animated: true)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: PostTopicViewControllerPostTopicNotification), object: nil, userInfo: nil)
        }) { (error) -> (Void) in
            HUDUtils.showErrorHUD(string: "删除失败，请稍后再试~")
        }
    }
}

// MARK: - @Objc Event
@objc private extension TopicDetailViewController {
    
    func collectionButtonTapped(sender: UIButton) {
        if UserDefaults.standard.object(forKey: kIsLogin) == nil {
            self.showLoginController()
            return
        }
        sender.isSelected = !sender.isSelected
        if (listModel.isCollection) {
            listModel.isCollection = false
            YSNetWorking().unCollectionTopic(topicId: self.listModel.id, successComplete: nil) { (error) -> (Void) in
                HUDUtils.showErrorHUD(string: "取消收藏失败，请稍后再试~")
            }
        } else {
            listModel.isCollection = true
            YSNetWorking().collectionTopic(topicId: self.listModel.id, successComplete: nil) { (error) -> (Void) in
                HUDUtils.showErrorHUD(string: "收藏失败，请稍后再试~")
            }
        }
    }
    
    func deleteButtonTapped(sender: Any) {
         LZAlterView.defaltManager().configure(withMainTitle: "提示", subTitle: "是否删除帖子? 删除后无法恢复", actionTitleArray: ["删除"], cancelActionTitle: "取消").setupDelegate(self).showAlter()
    }
    
    func footerRefresh(sender: Any) {
        if pageNo < totalPages {
            pageNo = pageNo + 1
            loadCommentList(page: pageNo)
        } else {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                self.footer.endRefreshing()
            }
        }
    }
    
    func headerRefresh(sender: Any) {
        pageNo = 1
        loadCommentList(page: pageNo)
    }
    
    func setupInputView() {
        replyInputView.keyBordShowBlock = {(margin, duration) in
            UIView.animate(withDuration: duration, animations: {
                self.replyInputView.snp.updateConstraints { (make) in
                    make.bottom.equalTo(self.bottomLayoutGuide.snp.top).offset(-margin)
                }
                self.replyInputView.superview!.layoutIfNeeded()
            })
        }
        replyInputView.keyBordHidenBlock = {(margin, duration) in
            UIView.animate(withDuration: duration, animations: {
                self.replyInputView.snp.updateConstraints { (make) in
                    make.bottom.equalTo(self.bottomLayoutGuide.snp.top)
                }
                self.replyInputView.superview!.layoutIfNeeded()
            })
        }
        
        replyInputView.textViewChangeText = { text in
            let height = text.ga_heightForComment(fontSize: 13, width: kSCREEN_WIDTH - 80)
            UIView.animate(withDuration: 0.1, animations: {
                self.replyInputView.snp.updateConstraints { (make) in
                    if height <= 60 {
                        make.height.equalTo(60)
                    } else {
                        make.height.equalTo(height)
                    }
                }
                self.replyInputView.superview!.layoutIfNeeded()
            })
        }
        
        replyInputView.textViewEndEditing = { text in
            if UserDefaults.standard.object(forKey: kIsLogin) == nil {
                self.showLoginController()
                return
            }
            self.addComment(content: text)
        }
    }
}

extension TopicDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard (modelArray != nil) else {
            return section == 1 ? 0 : 1
        }
        return section == 1 ? modelArray!.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let reuseIdentifier = "cellId"
            var cell: TopicDetalHeaderTableViewCell? = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? TopicDetalHeaderTableViewCell
            if cell == nil {
                cell = TopicDetalHeaderTableViewCell.init(style: .default, reuseIdentifier: reuseIdentifier)
            }
            cell!.model = self.listModel
            return cell!
        case 1:
            let reuseIdentifier = "cell-\(indexPath.section)-\(indexPath.row)"
            
            var cell: TopicCommentTableViewCell? = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? TopicCommentTableViewCell
            if cell == nil {
                cell = TopicCommentTableViewCell.init(style: .default, reuseIdentifier: reuseIdentifier)
            }
            cell!.model = modelArray![indexPath.row]
            cell?.likeClickBlock = { m in
                m.isLike = !m.isLike
                if (m.isLike) {
                    m.likeNum += 1
                } else {
                    m.likeNum -= 1
                }
                DataBaseUtils.defaultManger.update(model: m, tableName: CommentListTable, uid: m.wd_fmdb_id!, successBlock: {
                    UIView.performWithoutAnimation {
                        tableView.reloadSections(IndexSet.init(integer: indexPath.section), with: .none)
                    }
                    YSNetWorking().likeComment(topicCommentId: m.id, isLike: !m.isLike, successComplete: { (data) -> (Void) in
                    }, falidReasonHandle: { (erroe) -> (Void) in
                        
                    })
                }, failBlock: { })
            }
            return cell!
        default:
            return UITableViewCell.init()
        }
    }
}

extension TopicDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel.init()
        label.text = "  评论列表"
        label.backgroundColor = .groupTableViewBackground
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? listModel.getDetailCellHeight() : UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 1 ? 45 : 0
    }
}
