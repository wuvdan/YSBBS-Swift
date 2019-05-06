//
//  HomeTopicListModel.swift
//  YSBBS-Swift
//
//  Created by wudan on 2019/3/1.
//  Copyright © 2019 com.wudan. All rights reserved.
//

import UIKit
import SwiftyJSON

class HomeTopicListModel: NSObject, NSCoding {
    
    var commentNum: Int    = 0
    var content: String?
    var createTime: String?
    var headPic: String?
    var id: Int            = 0
    var isCollection: Bool = false
    var isFollow: Bool     = false
    var isLike: Bool       = false
    var isMy: Bool         = false
    var likeNum: Int       = 0
    var nickname: String?
    var title: String?
    var userId: Int        = 0
    var img: String?
    
    var imgURLArray: [String]? {
        if img?.count == 0 {
            return nil
        }
        guard let imageUrls = img?.components(separatedBy: ",") else { return [""] }
        return imageUrls
    }
    
    var imgOrignRectArray: [CGRect]? {
        if img?.count == 0 {
            return [.zero]
        }
        
        let imageUrls = img?.components(separatedBy: ",")
        var tempArray: [CGRect] = Array()

        for string in imageUrls! {
            let width = string.components(separatedBy: "?").last?.components(separatedBy: "/")[1]
            let height = string.components(separatedBy: "?").last?.components(separatedBy: "/")[3]
            if let w = width {
                if let h = height {
                    
                    let imageW: CGFloat = kSCREEN_WIDTH
                    let doudleH = CGFloat(Double(h)!)
                    let doudleW = CGFloat(Double(w)!)

                    var rotaion: CGFloat = (doudleW / (doudleH > 0 ? doudleH : doudleW))
                    if(rotaion <= 0.0){
                        rotaion = 1.0
                    }
                    let imageH:CGFloat = imageW / rotaion
                    var originY: CGFloat = 0.0
                    if (imageH > kSCREEN_HEIGHT) {
                        originY = 0
                    } else {
                        originY = (kSCREEN_HEIGHT - imageH) / 2.0
                    }
                    
                    let imgViewRect = CGRect(x: 0, y: originY, width: kSCREEN_WIDTH, height: imageH)
                    tempArray.append(imgViewRect)
                }
            }
        }
        return tempArray
    }
    
    var imgWidthArray: [CGFloat] {
        if img?.count == 0 {
            return [0]
        }
        let imageUrls = img?.components(separatedBy: ",")
        var tempArray: [CGFloat] = Array()
        for string in imageUrls! {
            let imageW = string.components(separatedBy: "?").last?.components(separatedBy: "/")[1]
            let imageH = string.components(separatedBy: "?").last?.components(separatedBy: "/")[3]

            if let w = imageW {
                if let h = imageH {
                    let doubleH = Double(h) ?? 0
                    var doubleW = Double(w) ?? 0
                    let imageScale = doubleW / doubleH
                    
                    let isOverWidth = CGFloat(doubleW) > (kSCREEN_WIDTH / 3)
                    let isOverHeight = CGFloat(doubleH) > (kSCREEN_HEIGHT / 3)
                    
                    if imageScale < 1 {
                        if isOverHeight && !isOverWidth { // 超高 固定高度
                            doubleW = Double(kSCREEN_WIDTH / 3) * imageScale
                            print("1-1")
                        } else if !isOverHeight && isOverWidth { // 超宽 固定宽度
                            doubleW = Double(kSCREEN_WIDTH / 3)
                            print("2-1")
                        } else if isOverHeight && isOverWidth {  // 超高 + 超宽 固定宽度
                            doubleW = Double(kSCREEN_WIDTH / 3)
                            print("3-1")
                        } else {
                            print("4-1")
                        }
                    } else if imageScale > 1 {
                        if isOverHeight && !isOverWidth { // 超高 固定宽度
                            doubleW = Double(kSCREEN_WIDTH / 3)
                            print("5-1")
                        } else if !isOverHeight && isOverWidth { // 超宽 固定宽度
                            doubleW = Double(kSCREEN_WIDTH / 3)
                            print("6-1")
                        } else if isOverHeight && isOverWidth {  // 超高 + 超宽 固定高度
                            doubleW = Double(kSCREEN_WIDTH / 3) * imageScale
                            print("7-1")
                        } else {
                            print("8-1")
                        }
                    } else {
                        doubleW = Double(kSCREEN_WIDTH / 3)
                    }
                    tempArray.append(CGFloat(doubleW))
                }
            }
        }
        return tempArray
    }
    
    var imgHeightArray: [CGFloat] {
        if img?.count == 0 {
            return [0]
        }
        let imageUrls = img?.components(separatedBy: ",")
        var tempArray: [CGFloat] = Array()
        for string in imageUrls! {
            let imageH = string.components(separatedBy: "?").last?.components(separatedBy: "/")[3]
            let imageW = string.components(separatedBy: "?").last?.components(separatedBy: "/")[1]

            if let w = imageW {
                if let h = imageH {
                    var doubleH = Double(h) ?? 0
                    let doubleW = Double(w) ?? 0
                    let isOverWidth = CGFloat(doubleW) > (kSCREEN_WIDTH / 3)
                    let isOverHeight = CGFloat(doubleH) > (kSCREEN_HEIGHT / 3)
                    let imageScale = doubleW / doubleH
                    
                    if imageScale < 1 { // 高度大于宽度
                        if isOverHeight && !isOverWidth { // 超高 固定高度
                            doubleH = Double(kSCREEN_HEIGHT / 3)
                            print("1")
                        } else if !isOverHeight && isOverWidth { // 超宽
                            doubleH = Double(kSCREEN_WIDTH / 3) * imageScale
                            print("2")
                        } else if isOverHeight && isOverWidth {  // 超高 + 超宽
                            doubleH = Double(kSCREEN_WIDTH / 3) / imageScale
                            if doubleH > Double(kSCREEN_HEIGHT / 3) {
                                doubleH = Double(kSCREEN_HEIGHT / 3)
                            }
                            print("3")
                        } else {
                            print("4")
                        }
                    } else if imageScale > 1 {
                        if isOverHeight && !isOverWidth { // 超高 固定宽度
                            doubleH = Double(kSCREEN_WIDTH / 3) * imageScale
                            print("5")
                        } else if !isOverHeight && isOverWidth { // 超宽
                            doubleH = Double(kSCREEN_WIDTH / 3) / imageScale
                            print("6")
                        } else if isOverHeight && isOverWidth {  // 超高 + 超宽
                            doubleH = Double(kSCREEN_WIDTH / 3)
                            print("7")
                        } else {
                            print("8")
                        }
                    } else {
                        doubleH = Double(kSCREEN_WIDTH / 3)
                    }
                    tempArray.append(CGFloat(doubleH))
                }
            }
        }
        return tempArray
    }
    
    func getDetailCellHeight() -> CGFloat {
        
        let imageTopSpace: CGFloat = 10
        let imageHeight: CGFloat = 40
        let titleTopSpace: CGFloat = 10
        let titleHeight: CGFloat = 16
        let contentSpace: CGFloat = 10
        let contentHeiht: CGFloat = getLabHeigh(labelStr: content!, font: UIFont.systemFont(ofSize: 13), width: kSCREEN_WIDTH - 20)
        let sudoTopSpace: CGFloat = 30
        var sudoHeight: CGFloat = 0.0
        var timeTopSpace: CGFloat = 30
        let timeBottomSpace: CGFloat = 10
        let timeSpace: CGFloat = UIFont.systemFont(ofSize: 11).lineHeight
        
        let imageUrls = img?.components(separatedBy: ",")
        
        if imageUrls?.count == 0 {
            sudoHeight = 0
            timeTopSpace = 10
        } else if imageUrls?.count == 1 {
            sudoHeight = imgHeightArray.first!
        } else if imageUrls?.count == 2 || imageUrls?.count == 3 {
            sudoHeight = (kSCREEN_WIDTH - 60) / 3
        } else if imageUrls?.count == 4 {
            sudoHeight = (kSCREEN_WIDTH - 60) / 3 * 2 + 5
        } else if imageUrls!.count < 7 {
            sudoHeight = (kSCREEN_WIDTH - 60) / 3 * 2 + 5
        } else {
            sudoHeight = (kSCREEN_WIDTH - 60) / 3 * 3 + 10
        }
        
        return  imageTopSpace +
            imageHeight +
            titleTopSpace +
            titleHeight +
            contentSpace +
            contentHeiht +
            sudoTopSpace +
            timeTopSpace +
            timeBottomSpace +
            timeSpace +
        sudoHeight
    }
    
    func getCellHeight() -> CGFloat {
        
        let imageTopSpace: CGFloat = 10
        let imageHeight: CGFloat = 40
        let titleTopSpace: CGFloat = 10
        let titleHeight: CGFloat = 16
        let contentSpace: CGFloat = 10
        let contentHeiht: CGFloat = getContentHeigt(title: content!)
        let sudoTopSpace: CGFloat = 30
        var sudoHeight: CGFloat = 0.0
        var timeTopSpace: CGFloat = 30
        let timeBottomSpace: CGFloat = 10
        let timeSpace: CGFloat = UIFont.systemFont(ofSize: 11).lineHeight
        
        let imageUrls = img?.components(separatedBy: ",")
        
        if imageUrls?.count == 0 {
            sudoHeight = 0
            timeTopSpace = 10
        } else if imageUrls?.count == 1 {
            sudoHeight = imgHeightArray.first!
        } else if imageUrls?.count == 2 || imageUrls?.count == 3 {
            sudoHeight = (kSCREEN_WIDTH - 60) / 3
        } else if imageUrls?.count == 4 {
            sudoHeight = (kSCREEN_WIDTH - 60) / 3 * 2 + 5
        } else if imageUrls!.count < 7 {
            sudoHeight = (kSCREEN_WIDTH - 60) / 3 * 2 + 5
        } else {
            sudoHeight = (kSCREEN_WIDTH - 60) / 3 * 3 + 10
        }
        
        return  imageTopSpace +
                imageHeight +
                titleTopSpace +
                titleHeight +
                contentSpace +
                contentHeiht +
                sudoTopSpace +
                timeTopSpace +
                timeBottomSpace +
                timeSpace +
                sudoHeight 
    }
    
    func getLabHeigh(labelStr: String, font: UIFont, width: CGFloat) -> CGFloat {
        let statusLabelText: NSString = labelStr as NSString
        return statusLabelText.boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil).height
    }
    
    private func getContentHeigt(title: String) -> CGFloat {
        var attrButes: [NSAttributedString.Key: NSObject]? = nil
        let paraph = NSMutableParagraphStyle()
        paraph.maximumLineHeight = 2
        attrButes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13), NSAttributedString.Key.paragraphStyle:paraph]
        let size: CGRect = title.boundingRect(with: CGSize(width: kSCREEN_WIDTH - 30 - 20, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attrButes, context: nil)
        return size.height
    }
    
    init(jsonData: JSON) {
        commentNum   = jsonData["commentNum"].intValue
        content      = jsonData["content"].stringValue
        createTime   = jsonData["createTime"].stringValue
        headPic      = jsonData["headPic"].stringValue
        id           = jsonData["id"].intValue
        isCollection = jsonData["isCollection"].boolValue
        isFollow     = jsonData["isFollow"].boolValue
        isLike       = jsonData["isLike"].boolValue
        isMy         = jsonData["isMy"].boolValue
        likeNum      = jsonData["likeNum"].intValue
        nickname     = jsonData["nickname"].stringValue
        title        = jsonData["title"].stringValue
        img          = jsonData["img"].stringValue
        userId       = jsonData["userId"].intValue
    }
    
    // MARK: - 归档
    func encode(with aCoder: NSCoder) {
        aCoder.encode(commentNum, forKey: "commentNum")
        aCoder.encode(content, forKey: "content")
        aCoder.encode(createTime, forKey: "createTime")
        aCoder.encode(headPic, forKey: "headPic")
        aCoder.encode(id, forKey: "id")
        aCoder.encode(isCollection, forKey: "isCollection")
        aCoder.encode(isLike, forKey: "isLike")
        aCoder.encode(isFollow, forKey: "isFollow")
        aCoder.encode(isMy, forKey: "isMy")
        aCoder.encode(likeNum, forKey: "likeNum")
        aCoder.encode(nickname, forKey: "nickname")
        aCoder.encode(title, forKey: "title")
        aCoder.encode(img, forKey: "img")
        aCoder.encode(userId, forKey: "userId")
    }

     // MARK: - 解档
     required init?(coder aDecoder: NSCoder){
        super.init()
        self.commentNum   = aDecoder.decodeInteger(forKey: "commentNum")
        self.content      = aDecoder.decodeObject(forKey: "content") as? String
        self.createTime   = aDecoder.decodeObject(forKey: "createTime") as? String
        self.headPic      = aDecoder.decodeObject(forKey: "headPic") as? String
        self.id           = aDecoder.decodeInteger(forKey: "id")
        self.isCollection = aDecoder.decodeBool(forKey: "isCollection")
        self.isLike       = aDecoder.decodeBool(forKey: "isLike")
        self.isFollow     = aDecoder.decodeBool(forKey: "isFollow")
        self.isMy         = aDecoder.decodeBool(forKey: "isMy")
        self.likeNum      = aDecoder.decodeInteger(forKey: "likeNum")
        self.nickname     = aDecoder.decodeObject(forKey: "nickname") as? String
        self.title        = aDecoder.decodeObject(forKey: "title") as? String
        self.img          = aDecoder.decodeObject(forKey: "img") as? String
        self.userId       = aDecoder.decodeInteger(forKey: "userId")
    }
}

