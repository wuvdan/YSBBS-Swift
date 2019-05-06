//
//  NotificationDetalViewController.swift
//  YSBBS-Swift
//
//  Created by wudan on 2019/4/11.
//  Copyright © 2019 com.wudan. All rights reserved.
//

import UIKit
import SwiftyJSON

class NotificationDetalViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let t = UITableView.init(frame: .zero, style: .grouped)
        t.tableFooterView = UIView()
        t.backgroundColor = .white
        t.separatorStyle = .none
        t.rowHeight = UITableView.automaticDimension
        t.estimatedRowHeight = 65
        t.dataSource = self
        t.delegate = self
        t.backgroundColor = .groupTableViewBackground
        t.showsVerticalScrollIndicator = false
        t.register(NotificationDetailCell.classForCoder(), forCellReuseIdentifier: "NotificationDetailCell")
        return t
    }()
    
    public var messageModel: MessageListModel?
    private var messageDetailModel:MessageDetalModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "消息详情"
        view.backgroundColor = .groupTableViewBackground
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(bottomLayoutGuide.snp.top)
        }
        
        loadData()
    }

    deinit {
        print("======\(self.classForCoder)===== -> 被销毁")
    }
    
    private func loadData() {
        YSNetWorking().getMessgaeDetal(messageId: messageModel!.messageId) { (data) -> (Void) in
            let dic:Dictionary = data
            let dataDic:Dictionary<String, Any> = dic["data"] as! Dictionary
            let json = JSON(dataDic)
            self.messageDetailModel = MessageDetalModel.init(jsonData: json)
            self.tableView.reloadData()
        }
    }
}

extension NotificationDetalViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.messageDetailModel != nil {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NotificationDetailCell = tableView.dequeueReusableCell(withIdentifier: "NotificationDetailCell", for: indexPath) as! NotificationDetailCell
        if let model = self.messageDetailModel {
           cell.setup(model)
        }
        return cell
    }
}

extension NotificationDetalViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v: NotificationDetailHeaderView = NotificationDetailHeaderView.init(frame: .zero)
        v.timeLabel.text = messageModel?.createTime
        return v
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
}


