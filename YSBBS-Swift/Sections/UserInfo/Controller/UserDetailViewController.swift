//
//  UserDetailViewController.swift
//  YSBBS-Swift
//
//  Created by wudan on 2019/4/12.
//  Copyright © 2019 com.wudan. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
    private let rowItems: [[String]] = [["头像"], ["昵称", "单点登录", "修改密码"]]
    public var userInfoModel: UserInfoModel!
  
    private lazy var tableView: UITableView = {
        let t = UITableView.init(frame: .zero, style: .plain)
        t.tableFooterView = UIView()
        t.backgroundColor = UIColor.groupTableViewBackground
        t.separatorStyle = .none
        t.dataSource = self
        t.delegate = self
        t.showsVerticalScrollIndicator = false
        t.register(UserInfoSettingCell.classForCoder(), forCellReuseIdentifier: "UserInfoSettingCell")
        return t
    }()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "编辑资料"
        view.backgroundColor = .groupTableViewBackground
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(bottomLayoutGuide.snp.top)
        }
    }
}

extension UserDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return rowItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowItems[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UserInfoSettingCell = tableView.dequeueReusableCell(withIdentifier: "UserInfoSettingCell", for: indexPath) as! UserInfoSettingCell
        cell.titleLabel.text = rowItems[indexPath.section][indexPath.row]
        if indexPath.section == 0 {
            cell.headerImageView.isHidden = false
            cell.headerImageView.kf.setImage(with: URL(string: API_Http_URL + userInfoModel.headPic!),
                                        placeholder: UIImage(named: "yundian_tupian"))
            cell.switchControl.isHidden = true
            cell.subTitleLabel.text = ""
            cell.accessoryType = .disclosureIndicator
        } else {
            if indexPath.row == 0 {
                cell.headerImageView.isHidden = true
                cell.switchControl.isHidden = true
                cell.subTitleLabel.text = userInfoModel?.nickname
                cell.headerImageView.isHidden = true
                cell.accessoryType = .disclosureIndicator
            } else if indexPath.row == 1 {
                cell.headerImageView.isHidden = true
                cell.switchControl.isHidden = false
                cell.switchControl.isOn = userInfoModel!.isSingleLogin
                cell.switchControl.addTarget(self, action: #selector(chengeSingleLogin(sender:)), for: .valueChanged)
                cell.subTitleLabel.text = ""
                cell.headerImageView.isHidden = true
                cell.accessoryType = .none
            } else {
                cell.switchControl.isHidden = true
                cell.subTitleLabel.text = ""
                cell.headerImageView.isHidden = true
                cell.accessoryType = .disclosureIndicator
            }
        }
        return cell
    }
    
    @objc func chengeSingleLogin(sender: UISwitch)  {
        YSNetWorking().changeUserInfo(nickName: nil, isSingleLogin:sender.isOn, headPic: nil, successComplete: {_ in })
    }
}

extension UserDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 100 : 65
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            ImagePickerManager.manager.pickerImage(pickImageComplete: { (image) in
               self.upLoadImage(image: image)
            }, pickImageFaildBlock: nil)
        } else {
            if indexPath.row == 0 {
                let v = UserNameInputView()
                v.showView(text: userInfoModel.nickname!) { (text) in
                    if text.count > 0 {
                        self.updataDataBaseNickName(text: text)
                    }
                }
            }
            if indexPath.row == 2 {
                 navigationController?.pushViewController(Login_ChangePwdViewController(), animated: true)
            }
        }
    }
    
    // 修改本地数据-修改昵称
    private func updataDataBaseNickName(text: String) {
        self.userInfoModel.nickname = text
        DataBaseUtils.defaultManger.update(model: self.userInfoModel, tableName: UseInfoTable, uid: self.userInfoModel.wd_fmdb_id!, successBlock: {
            self.updataNickName(text: text)
        }, failBlock: nil)
    }
    
    // 修改昵称
    private func updataNickName(text: String) {
        YSNetWorking().changeUserInfo(nickName: text, isSingleLogin:nil, headPic: nil, successComplete: {_ in })
        self.tableView.reloadData()
    }
    
    // 上传文件 && 添加到数据库
    public func upLoadImage(image: UIImage) {
        YSNetWorking().uploadMultiImage(images: [image.jpegData(compressionQuality: 0.3)!], success: { (data) in
            let dic: Dictionary<String, Any> = data as! Dictionary
            let imageArray: [String] = dic["data"] as! [String]
            self.userInfoModel.headPic = imageArray.first
            self.updataDataBase(model: self.userInfoModel, imageStr: imageArray.first! as NSString)
        }, failture: { (error) in
            HUDUtils.showErrorHUD(string: "头像修改失败~")
        })
    }
    
    // 添加到数据库
    public func updataDataBase(model: UserInfoModel, imageStr: NSString) {
        DataBaseUtils.defaultManger.update(model: model, tableName: UseInfoTable, uid: self.userInfoModel.wd_fmdb_id!, successBlock: {
            self.changeUserInfo(headerPic: imageStr as String)
        }, failBlock: nil)
    }
    
    // 修改个人信息
    public func changeUserInfo(headerPic: String) {
        YSNetWorking().changeUserInfo(nickName: nil, isSingleLogin:nil, headPic: headerPic, successComplete: {_ in })
        self.tableView.reloadData()
    }
}
