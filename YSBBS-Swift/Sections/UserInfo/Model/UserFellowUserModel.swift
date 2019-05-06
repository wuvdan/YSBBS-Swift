//
//  UserFellowUserModel.swift
//  YSBBS-Swift
//
//  Created by wudan on 2019/4/15.
//  Copyright © 2019 com.wudan. All rights reserved.
//

import UIKit
import SwiftyJSON

class UserFellowUserModel: NSObject {
    var headPic: String?
    var followUserId: Int = 0
    var nickname: String?

    init(jsonData:JSON) {
        headPic = jsonData["headPic"].stringValue
        followUserId = jsonData["followUserId"].intValue
        nickname = jsonData["nickname"].stringValue
    }
}
