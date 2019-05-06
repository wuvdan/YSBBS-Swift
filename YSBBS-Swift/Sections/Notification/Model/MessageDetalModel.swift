//
//  NotificationDetalModel.swift
//  YSBBS-Swift
//
//  Created by wudan on 2019/4/11.
//  Copyright © 2019 com.wudan. All rights reserved.
//

import UIKit
import SwiftyJSON

class MessageDetalModel: NSObject {
    var title: String?
    var content: String?
    
    init(jsonData: JSON) {
        title   = jsonData["title"].stringValue
        content = jsonData["content"].stringValue
    }
}
