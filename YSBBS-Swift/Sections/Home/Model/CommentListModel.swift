//
//  CommentListModel.swift
//  YSBBS-Swift
//
//  Created by wudan on 2019/4/3.
//  Copyright © 2019 com.wudan. All rights reserved.
//

import UIKit
import SwiftyJSON

class CommentListModel: NSObject, NSCoding {
    var isLike = false
    var isMy = false
    var id = 0
    var likeNum = 0
    var content: String?
    var createTime: String?
    var nickname: String?
    var headPic: String?
    
    init(jsonData: JSON) {
        content = jsonData["content"].stringValue
        createTime = jsonData["createTime"].stringValue
        headPic = jsonData["headPic"].stringValue
        id = jsonData["id"].intValue
        isLike = jsonData["isLike"].boolValue
        isMy = jsonData["isMy"].boolValue
        likeNum = jsonData["likeNum"].intValue
        nickname = jsonData["nickname"].stringValue
    }
    
    // MARK: - 归档
    func encode(with aCoder: NSCoder) {
        aCoder.encode(content, forKey: "content")
        aCoder.encode(createTime, forKey: "createTime")
        aCoder.encode(headPic, forKey: "headPic")
        aCoder.encode(id, forKey: "id")
        aCoder.encode(isLike, forKey: "isLike")
        aCoder.encode(isMy, forKey: "isMy")
        aCoder.encode(likeNum, forKey: "likeNum")
        aCoder.encode(nickname, forKey: "nickname")
    }
    
    // MARK: - 解档
    required init?(coder aDecoder: NSCoder){
        super.init()
        self.content      = aDecoder.decodeObject(forKey: "content") as? String
        self.createTime   = aDecoder.decodeObject(forKey: "createTime") as? String
        self.headPic      = aDecoder.decodeObject(forKey: "headPic") as? String
        self.id           = aDecoder.decodeInteger(forKey: "id")
        self.isLike       = aDecoder.decodeBool(forKey: "isLike")
        self.isMy         = aDecoder.decodeBool(forKey: "isMy")
        self.likeNum      = aDecoder.decodeInteger(forKey: "likeNum")
        self.nickname     = aDecoder.decodeObject(forKey: "nickname") as? String
    }
}
