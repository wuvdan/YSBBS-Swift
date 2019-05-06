//
//  PostTopicViewController.swift
//  YSBBS-Swift
//
//  Created by wudan on 2019/4/9.
//  Copyright © 2019 com.wudan. All rights reserved.
//

import UIKit
import Photos
import SVProgressHUD
import FFToast

let PostTopicViewControllerPostTopicNotification = "PostTopicViewControllerPostTopicNotification"

class PostTopicViewController: UIViewController {
    
    private let tableView: UITableView = {
        let t = UITableView.init()
        t.tableFooterView = UIView()
        t.backgroundColor = .white
        t.separatorStyle = .none
        t.showsVerticalScrollIndicator = false
        t.register(PostTopic_TextField_Cell.classForCoder(), forCellReuseIdentifier: "PostTopic_TextField_Cell")
        t.register(PostTopic_TextView_Cell.classForCoder(), forCellReuseIdentifier: "PostTopic_TextView_Cell")
        t.register(PostTopic_Image_Cell.classForCoder(), forCellReuseIdentifier: "PostTopic_Image_Cell")
        return t
    }()

    private var textViewHeight: CGFloat = 0.0
    private var allAssetList: [PHAsset] = Array()
    private var titleString: String = ""
    private var contentString: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .groupTableViewBackground
        title = "发帖"
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "发布",
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(postToicAction(sender:)))
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(bottomLayoutGuide.snp.top)
        }
    }
    
    @objc func postToicAction(sender: Any) {
        self.view.endEditing(true)
        if titleString.count == 0 {
            HUDUtils.showWarningHUD(string: "请输入标题")
        } else if contentString.count == 0 {
            HUDUtils.showWarningHUD(string: "请输入内容")
        } else {
           LZRemindBar.configuration(with: .info, show: .statusBar, contentText: "正在发布中~").show(afterTimeInterval: 1.2)
            self.navigationController?.popToRootViewController(animated: true)
            if allAssetList.count > 0 {
                YSNetWorking().uploadMultiImage(images: getImages(), success: { (data) in
                    let images = data as! [String]
                    self.addTopic(title: self.titleString, content: self.contentString, images: images.joined(separator: ","))
                }) { (error) in
                    print(error)
                }
            } else {
                addTopic(title: titleString, content: contentString, images: nil)
            }
        }
    }
    
    private func addTopic(title: String, content: String, images: String?) {
        YSNetWorking().postTopic(title: title, content: content, image: images, successComplete: { (data) -> (Void) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: PostTopicViewControllerPostTopicNotification), object: nil, userInfo: nil)
        }) { (error) -> (Void) in
            HUDUtils.showErrorHUD(string: "帖子上传失败，请稍后再试~")
        }
    }
    
   private func getImages() -> [Data] {
        var tempArray: [Data] = Array()
        let sema = DispatchSemaphore.init(value: 0)
        SVProgressHUD.show()
        for value in allAssetList {
            let options = PHImageRequestOptions()
            options.version = .current
            options.isSynchronous = true
            PHImageManager.default().requestImageData(for: value, options: options) { (data, str, origin, info) in
                tempArray.append(data!)
                DispatchSemaphore.signal(sema)()
            }
            SVProgressHUD.dismiss()
            DispatchSemaphore.wait(sema)()
        }
        return tempArray
    }
}

extension PostTopicViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell: PostTopic_TextField_Cell = tableView.dequeueReusableCell(withIdentifier: "PostTopic_TextField_Cell", for: indexPath) as! PostTopic_TextField_Cell
            cell.getTextWhenTextFieldEditComplete = {
                self.titleString = $0
            }
            return cell
        } else if indexPath.section == 1{
            let cell: PostTopic_TextView_Cell = tableView.dequeueReusableCell(withIdentifier: "PostTopic_TextView_Cell", for: indexPath) as! PostTopic_TextView_Cell
            cell.textViewDidChange = { height in
                self.textViewHeight = height
                tableView.beginUpdates()
                tableView.endUpdates()
            }
            cell.getTextWhenTextViewEditComplete = {
                self.contentString = $0
            }
            return cell
        } else {
            let cell: PostTopic_Image_Cell = tableView.dequeueReusableCell(withIdentifier: "PostTopic_Image_Cell", for: indexPath) as! PostTopic_Image_Cell
            cell.getAllAssetListComplete = { allList in
                self.allAssetList = allList
                tableView.reloadData()
            }
            return cell
        }
    }
}

extension PostTopicViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
            case 0: return 60
            case 1: return self.textViewHeight < 80 ? 80 : self.textViewHeight
            case 2: if allAssetList.count < 3 {
                return 130
            } else if allAssetList.count < 6 {
                return 130 + 100 + 10
            } else {
                return 130 + 100 + 100 + 20
            }
            default:
                return 0
        }
    }
}
