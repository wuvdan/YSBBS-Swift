//
//  UserInfoViewController.swift
//  YSBBS-Swift
//
//  Created by wudan on 2019/4/9.
//  Copyright © 2019 com.wudan. All rights reserved.
//

import UIKit
import SwiftyJSON
import MJRefresh

class UserInfoViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let t = UITableView.init(frame: .zero, style: .plain)
        t.tableFooterView = UIView()
        t.backgroundColor = UIColor.groupTableViewBackground
        t.separatorStyle = .none
        t.dataSource = self
        t.delegate = self
        t.showsVerticalScrollIndicator = false
        t.register(UserInfoHeaderCell.classForCoder(), forCellReuseIdentifier: "UserInfoHeaderCell")
        t.register(UserInfoNoLoginHeaderCell.classForCoder(), forCellReuseIdentifier: "UserInfoNoLoginHeaderCell")
        t.register(UserInfoItemCell.classForCoder(), forCellReuseIdentifier: "UserInfoItemCell")
        return t
    }()
    
    private var rowItems: [[String]] = Array()
    private let header = MJRefreshNormalHeader()

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .groupTableViewBackground
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(bottomLayoutGuide.snp.top)
        }
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reloadData),
                                               name: NSNotification.Name(rawValue: LoginSuccessNotification),
                                               object: nil)
        header.setRefreshingTarget(self, refreshingAction: #selector(headerRefresh))
        tableView.mj_header = header
        header.beginRefreshing()
        reloadData()
    }
    
    @objc func headerRefresh(sender: Any) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.8) {
            self.reloadData()
            self.header.endRefreshing()
        }
    }
    
    @objc func reloadData() {
        
        if UserDefaults.standard.bool(forKey: kIsLogin) {
            rowItems = [["我的关注", "我的收藏"], ["清除缓存", "退出登录"]]
            YSNetWorking().getUserInfo { (data) -> (Void) in
                let dic:Dictionary = data
                let dataDic:Dictionary<String, Any> = dic["data"] as! Dictionary
                let json = JSON(dataDic)
                DataBaseUtils.defaultManger.dropTable(tableName: UseInfoTable)
                DataBaseUtils.defaultManger.creatTable(tableName: UseInfoTable)
                DataBaseUtils.defaultManger.insertUserInfo(model: UserInfoModel.init(jsonData: json), tableName: UseInfoTable, successBlock: {
                    self.tableView.reloadData()
                })
            }
        } else {
            rowItems = [["我的关注", "我的收藏"], ["清除缓存"]]
            tableView.reloadData()
        }
    }
    
    private func clearUserData() {
        UserDefaults.standard.removeObject(forKey: kIsLogin)
        UserDefaults.standard.removeObject(forKey: kHeaderToken)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: LoginSuccessNotification), object: nil, userInfo: nil)
    }
}

extension UserInfoViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return rowItems.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : rowItems[section - 1].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let isLogin = UserDefaults.standard.bool(forKey: kIsLogin)
            if isLogin {
                let cell: UserInfoHeaderCell = tableView.dequeueReusableCell(withIdentifier: "UserInfoHeaderCell", for: indexPath) as! UserInfoHeaderCell
                cell.setup(DataBaseUtils.defaultManger.selectAll(tableName: UseInfoTable).first as! UserInfoModel)
                cell.userInfoHeaderItmeClickBlock = { tag in
                    switch tag {
                        case 1001: break
                        case 1002: break
                        case 1003: self.navigationController?.pushViewController(UserTopicListViewController(), animated: true)
                        default: break
                    }
                }
                return cell
            } else {
                let cell: UserInfoNoLoginHeaderCell = tableView.dequeueReusableCell(withIdentifier: "UserInfoNoLoginHeaderCell", for: indexPath) as! UserInfoNoLoginHeaderCell
                return cell
            }
        } else {
            let cell: UserInfoItemCell = tableView.dequeueReusableCell(withIdentifier: "UserInfoItemCell", for: indexPath) as! UserInfoItemCell
            cell.titleLabel.text = rowItems[indexPath.section - 1][indexPath.row]
            if indexPath.section == 2 && indexPath.row == 0 {
                cell.accessoryType = .none
                cell.subTitleLabel.text = CleanUtils.getCacheSize()
            } else {
                cell.accessoryType = .disclosureIndicator
                cell.subTitleLabel.text = ""
            }
            return cell
        }
    }
}

extension UserInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 200 : 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (indexPath.section == 0) {
            let isLogin = UserDefaults.standard.bool(forKey: kIsLogin)
            if !isLogin {
                 showLoginController()
            } else {
                let vc: UserDetailViewController = UserDetailViewController()
                let model: UserInfoModel = (DataBaseUtils.defaultManger.selectAll(tableName: UseInfoTable).first as! UserInfoModel)
                vc.userInfoModel = model
                navigationController?.pushViewController(vc, animated: true)
            }
        } else if indexPath.section == 1{
            if !UserDefaults.standard.bool(forKey: kIsLogin) {
                showLoginController()
            } else {
                if indexPath.row == 0 {
                    navigationController?.pushViewController(UserFellowViewController(), animated: true)
                } else {
                    navigationController?.pushViewController(UserCollectionTopicController(), animated: true)
                }
            }
        } else {
            if  indexPath.row == 0 {
                CleanUtils.clearCache()
                tableView.reloadData()
            } else {
                LZAlterView.defaltManager().configure(withMainTitle: "温馨提示", subTitle: "是否确定退出登录？", actionTitleArray: ["退出"], cancelActionTitle: "取消").setupDelegate(self).showAlter()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 2 ? 0 : 15
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
}

extension UserInfoViewController: LZAlterViewDelegate {
    func alterView(_ alterView: LZAlterView, didSelectedAt index: Int) {
        clearUserData()
    }
}

