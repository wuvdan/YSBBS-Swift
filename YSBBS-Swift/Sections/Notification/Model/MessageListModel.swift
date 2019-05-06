//
//  MessageListModel.swift
//  YSBBS-Swift
//
//  Created by wudan on 2019/4/11.
//  Copyright © 2019 com.wudan. All rights reserved.
//

import UIKit
import SwiftyJSON

class MessageListModel: NSObject {    
    var messageId: Int = 0
    var isRead: Bool = false
    var createTime: String?
    var messageTitle: String?
    var messageType: Int = 0
    
    init(jsonData: JSON) {
        messageId    = jsonData["messageId"].intValue
        isRead       = jsonData["isRead"].boolValue
        createTime   = jsonData["createTime"].stringValue
        messageTitle = jsonData["messageTitle"].stringValue
        messageType  = jsonData["messageType"].intValue
    }
}
