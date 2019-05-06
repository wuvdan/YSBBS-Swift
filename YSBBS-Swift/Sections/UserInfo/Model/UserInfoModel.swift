//
//  UserInfoModel.swift
//  YSBBS-Swift
//
//  Created by wudan on 2019/4/11.
//  Copyright © 2019 com.wudan. All rights reserved.
//

import UIKit
import SwiftyJSON

class UserInfoModel: NSObject, NSCoding {

    var email: String?
    var fansNum: Int = 0
    var getLikeNum: Int = 0
    var headPic: String?
    var isSingleLogin:Bool = false
    var loginName: String?
    var nickname: String?
    var topicNum: Int = 0
    
    init(jsonData:JSON) {
        email = jsonData["email"].stringValue
        fansNum = jsonData["fansNum"].intValue
        getLikeNum = jsonData["getLikeNum"].intValue
        headPic = jsonData["headPic"].stringValue
        isSingleLogin = jsonData["isSingleLogin"].boolValue
        loginName = jsonData["loginName"].stringValue
        nickname = jsonData["nickname"].stringValue
        topicNum = jsonData["topicNum"].intValue
    }
    
    // MARK: - 归档
    func encode(with aCoder: NSCoder) {
        aCoder.encode(email, forKey: "email")
        aCoder.encode(fansNum, forKey: "fansNum")
        aCoder.encode(getLikeNum, forKey: "getLikeNum")
        aCoder.encode(isSingleLogin, forKey: "isSingleLogin")
        aCoder.encode(loginName, forKey: "loginName")
        aCoder.encode(nickname, forKey: "nickname")
        aCoder.encode(topicNum, forKey: "topicNum")
        aCoder.encode(headPic, forKey: "headPic")
    }
    
    // MARK: - 解档
    required init?(coder aDecoder: NSCoder){
        super.init()
        self.email         = aDecoder.decodeObject(forKey: "email") as? String
        self.fansNum       = aDecoder.decodeInteger(forKey: "fansNum")
        self.getLikeNum    = aDecoder.decodeInteger(forKey: "getLikeNum")
        self.isSingleLogin = aDecoder.decodeBool(forKey: "isSingleLogin")
        self.loginName     = aDecoder.decodeObject(forKey: "loginName") as? String
        self.nickname      = aDecoder.decodeObject(forKey: "nickname") as? String
        self.topicNum      = aDecoder.decodeInteger(forKey: "topicNum")
        self.headPic       = aDecoder.decodeObject(forKey: "headPic") as? String
    }
}
