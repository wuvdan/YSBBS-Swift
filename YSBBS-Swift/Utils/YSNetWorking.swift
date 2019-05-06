//
//  YSNetWorking.swift
//  YSBBS-Swift
//
//  Created by wudan on 2019/2/28.
//  Copyright © 2019 com.wudan. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import SwiftyJSON

/// IP地址
let API_Http_URL              = "http://forumapi.zhangs.ink"
/// 多文件上传
let API_UploadFiles           = "file/uploads"
/// 单文件上传
let API_UploadFile            = "file/upload"
/// 注册
let API_Register              = "user/register"
/// 注册发送验证码
let API_RegisterGetCode       = "user/sendRegEmailMsg"
/// 忘记密码发送验证码
let API_forgetPassoworGetCode = "user/sendForgetPwdEmailMsg"
/// 忘记密码
let API_ForgetPassoword       = "user/forgetPwd"
/// 登陆
let API_LogIn                 = "user/login"
/// 首页列表
let API_Home_TopicList        = "topic/list"
/// 帖子详情
let API_Topic_Detail          = "topic/get"

/// 帖子评论列表
let API_CommentList           = "topicComment/list"
/// 添加评论
let API_AddComment            = "topicComment/add"
/// 删除评论
let API_DelComment            = "deleteCommentAPI"
/// 帖子点赞
let API_LikeComment            = "topicCommentLike/add"
/// 帖子取消点赞
let API_DisslikeComment        = "topicCommentLike/del"

/// 发帖
let API_AddTopic              = "topic/add"
/// 删帖
let API_DelTopic              = "topic/del"
/// 帖子点赞
let API_LikeTopic             = "topicLike/add"
/// 帖子取消点赞
let API_DisslikeTopic         = "topicLike/del"


/// 收藏帖子
let API_CollectionTopic       = "topicCollection/add"
/// 取消收藏帖子
let API_UnCollectionTopic     = "topicCollection/del"

/// 获取消息
let API_GetMessage  = "message/list"
/// 获取消息详情
let API_GetMessageDetal = "message/get"

/// 获取个人信息
let API_GetUserInfo = "user/getInfo"
// 或者个人帖子列表
let API_UserInfoTopicList = "topic/myList"
/// 修改个人信息
let API_ChangeUserInfo = "user/modifyInfo"

// 我的收藏列表
let API_CollectionTopicList = "topicCollection/list"
// 我的关注列表
let API_FellowList = "userFollow/list"

private let NetWorkRequestShareInstance = AlamofireNetWork()

class AlamofireNetWork: NSObject {
    class var sharedInstance:AlamofireNetWork {
        SVProgressHUD.setDefaultStyle(.dark)
        return NetWorkRequestShareInstance
    }
}

extension AlamofireNetWork {
    
    func getRequest(UrlString: String, params:[String: Any]?, showIndicator: Bool = false, success:@escaping(_ response:[String: AnyObject])->(), failure: ((_ error:Error)->())?) {
        
        let PathUrl = API_Http_URL + "/" + UrlString
        if (showIndicator) {
            SVProgressHUD.show()
        }
    
        var headers: HTTPHeaders?
        
        if UserDefaults.standard.object(forKey: kHeaderToken) != nil{
            headers = [
                "Authorization": UserDefaults.standard.object(forKey: kHeaderToken) as! String
            ]
        }
        Alamofire.request(PathUrl, method: .get, parameters: params, headers: headers).responseJSON { (response) in
            if (showIndicator) {
                SVProgressHUD.dismiss()
            }
            switch response.result{
            case .success( _):
                if let value = response.result.value as? [String:AnyObject]{
                    if value["code"]?.int64Value == 0 {
                        success(value)
                    } else if value["code"]?.int64Value == 1001 {
                        HUDUtils.showErrorHUD(string: "登陆失效，请重新登陆")
                        UIApplication.shared.keyWindow?.rootViewController?.showLoginController()
                    } else {
                        HUDUtils.showErrorHUD(string: value["msg"] as! String)
                    }
                }
            case .failure(let error):
                if (error.localizedDescription == "Could not connect to the server.") {
                    HUDUtils.showErrorHUD(string: "无法连接到服务器")
                } else {
                    if let f = failure {
                        f(error)
                    }
                }
            }
        }
    }
    
    func postRequest(UrlString: String, params: [String: String]?, showIndicator:Bool = true, success:@escaping(_ response:[String: AnyObject])->(), failure:@escaping(_ error:Error)->()) {
        let PathUrl = API_Http_URL + "/" + UrlString
        if (showIndicator) {
            SVProgressHUD.show()
        }
        
        var headers: HTTPHeaders?
        
        if UserDefaults.standard.object(forKey: kHeaderToken) != nil{
            headers = [
                "Authorization": UserDefaults.standard.object(forKey: kHeaderToken) as! String
            ]
            
            Alamofire.request(PathUrl, method: .post, parameters: params, headers: headers).responseJSON { (response) in
                if (showIndicator) {
                    SVProgressHUD.dismiss()
                }
                switch response.result{
                case .success( _):
                    if let value = response.result.value as? [String:AnyObject]{
                        if value["code"]?.int64Value == 0 {
                            success(value)
                        } else if value["code"]?.int64Value == 1001 {
                            HUDUtils.showErrorHUD(string: "登陆失效，请重新登陆")
                            UIApplication.shared.keyWindow?.rootViewController?.showLoginController()
                        } else {
                            HUDUtils.showErrorHUD(string: value["msg"] as! String)
                        }
                    }
                case .failure(let error):
                    if (error.localizedDescription == "Could not connect to the server.") {
                        HUDUtils.showErrorHUD(string: "无法连接到服务器")
                    } else {
                        failure(error)
                    }
                }
            }
        } else {
            Alamofire.request(PathUrl, method: .post, parameters: params).responseJSON { (response) in
                if (showIndicator) {
                    SVProgressHUD.dismiss()
                }
                switch response.result{
                case .success( _):
                    if let value = response.result.value as? [String : AnyObject]{
                        if value["code"]?.int64Value == 0 {
                            success(value)
                        } else if value["code"]?.int64Value == 1001 {
                            HUDUtils.showErrorHUD(string: "登陆失效，请重新登陆")
                            UIApplication.shared.keyWindow?.rootViewController?.showLoginController()
                        } else {
                            HUDUtils.showErrorHUD(string: value["msg"] as! String)
                        }
                    }
                case .failure(let error):
                    if (error.localizedDescription == "Could not connect to the server.") {
                        HUDUtils.showErrorHUD(string: "无法连接到服务器")
                    } else {
                        failure(error)
                    }
                }
            }
        }
    }
}


class YSNetWorking: NSObject {
    
    typealias SuccessComplete = (_ data: [String: AnyObject]) -> (Void)
    typealias FalidReasonHandle = (_ error: Any) -> (Void)
    /// 单图上传
    ///
    /// - Parameters:
    ///   - image: Dataz
    ///   - success: 成功回调
    ///   - failture: 失败
    func uploadSingleImage(image: Data, success: @escaping (_ response : Any?) -> (), failture : @escaping (_ error : Error)->(Void)) {
        let PathUrl = API_Http_URL + "/" + API_UploadFile
        SVProgressHUD.show()
        var headers: HTTPHeaders?
        if UserDefaults.standard.object(forKey: kHeaderToken) != nil{
            headers = [
                "Authorization": UserDefaults.standard.object(forKey: kHeaderToken) as! String
            ]
        }
        Alamofire.upload(multipartFormData: { multipartFormData in
            let imageData = image
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyyMMddHHmmss"
            let str = formatter.string(from: Date())
            let fileName = str + ".jpg"
            multipartFormData.append(imageData, withName: "files", fileName: fileName, mimeType: "image/jpeg")
        }, to: PathUrl, headers: headers, encodingCompletion: { encodingResult in
            SVProgressHUD.dismiss()
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    let result = response.result
                    if result.isSuccess {
                        success(response.value)
                    }
                }
            case .failure(let encodingError):
                failture(encodingError)
            }
        }
        )
    }
    
    /// 多图上传
    ///
    /// - Parameters:
    ///   - images: 图片[Data]
    ///   - success: 成功
    ///   - failture: 失败
    func uploadMultiImage(images: [Data], success: @escaping (_ response : Any?) -> (), failture : @escaping (_ error : Error)->()) {
        let PathUrl = API_Http_URL + "/" + API_UploadFiles
        SVProgressHUD.show()
        var headers: HTTPHeaders?
        if UserDefaults.standard.object(forKey: kHeaderToken) != nil{
            headers = [
                "Authorization": UserDefaults.standard.object(forKey: kHeaderToken) as! String
            ]
        }
        
        var sizeArray: [String] = Array()
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            for (_, value) in images.enumerated() {
                let imageData = value
                let formatter = DateFormatter()
                let imageSize = UIImage.init(data: value)?.size
                formatter.dateFormat = "yyyyMMddHHmmss"
                let str = formatter.string(from: Date())
                let fileName = str + ".jpg"
                sizeArray.append("?w/" + "\(imageSize!.width)" + "/h/" + "\(imageSize!.height)")
                multipartFormData.append(imageData, withName: "files", fileName: fileName, mimeType: "image/jpeg")
            }
        }, to: PathUrl, headers: headers, encodingCompletion: { encodingResult in
            SVProgressHUD.dismiss()
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    let result = response.result
                    if result.isSuccess {
                        let stringDic = response.value as! Dictionary<String, Any>
                        let stringArray = stringDic["data"] as! Array<String>
                        var tempArray: [String] = Array()
                        for (index, v) in stringArray.enumerated() {
                            tempArray.append("\(v)" + "\(sizeArray[index])")
                        }
                        success(tempArray)
                    }
                }
            case .failure(let encodingError):
                failture(encodingError)
            }
        }
        )
    }
    
    /// 登陆
    ///
    /// - Parameters:
    ///   - account: 账号或者邮箱
    ///   - password: 密码
    ///   - successComplete: 成功回调
    ///   - falidReasonHandle: 失败回调
    func login(with account: String, password: String, successComplete:@escaping SuccessComplete, falidReasonHandle:@escaping FalidReasonHandle) {
        let postDic = ["loginName": account,
                       "loginPwd" : password]
        
        AlamofireNetWork.sharedInstance.postRequest(UrlString: API_LogIn, params: postDic, success: { (data) in
            successComplete(data)
        }) { (error) in
            falidReasonHandle(error)
        }
    }
    
    /// 注册获取验证码
    ///
    /// - Parameters:
    ///   - account: 邮箱地址
    ///   - successComplete: 成功回调
    ///   - falidReasonHandle: 失败回调
    func registerSendCode(with account: String, successComplete:@escaping SuccessComplete, falidReasonHandle:@escaping FalidReasonHandle) {
        let postDic = ["email": account]
        AlamofireNetWork.sharedInstance.postRequest(UrlString: API_RegisterGetCode, params: postDic, success: { (data) in
            successComplete(data)
        }) { (Error) in
            falidReasonHandle(Error)
        }
    }
    
    /// 注册
    ///
    /// - Parameters:
    ///   - account: 邮箱地址
    ///   - code: 验证码
    ///   - userName: 用户名
    ///   - password: 密码
    ///   - successComplete: 成功回调
    ///   - falidReasonHandle: 失败回调
    func register(with account: String, code: String,userName: String, password: String, successComplete:@escaping SuccessComplete, falidReasonHandle:@escaping FalidReasonHandle) {
        let postDic = ["email"     : account,
                       "loginName" : userName,
                       "loginPwd"  : password,
                       "code"      : code]
        AlamofireNetWork.sharedInstance.postRequest(UrlString: API_Register, params: postDic, success: { (data) in
            successComplete(data)
        }) { (Error) in
            falidReasonHandle(Error)
        }
    }
    
    /// 忘记密码发送验证码
    ///
    /// - Parameters:
    ///   - account: 账号
    ///   - successComplete: 成功回调
    ///   - falidReasonHandle: 失败回调
    func forgetPasswordSendCode(with account: String, successComplete:@escaping SuccessComplete, falidReasonHandle:@escaping FalidReasonHandle) {
        let postDic = ["email": account]
        AlamofireNetWork.sharedInstance.postRequest(UrlString: API_forgetPassoworGetCode, params: postDic, success: { (data) in
            successComplete(data)
        }) { (Error) in
            falidReasonHandle(Error)
        }
    }
    
    
    /// 忘记密码
    ///
    /// - Parameters:
    ///   - withAccount: 账号
    ///   - code: 验证码
    ///   - password: 密码
    ///   - successComplete: 成功回调
    ///   - falidReasonHandle: 失败回调
    func forgetPassword(withAccount: String, code: String, password: String, successComplete:@escaping SuccessComplete, falidReasonHandle:@escaping FalidReasonHandle) {
        let postDic = ["email"     : withAccount,
                       "newPwd"    : password,
                       "code"      : code]
        AlamofireNetWork.sharedInstance.getRequest(UrlString: API_ForgetPassoword, params: postDic, success: { (data) in
            successComplete(data)
        }) { (Error) in
            falidReasonHandle(Error)
        }
    }
    
    
    /// 获取首页列表
    ///
    /// - Parameters:
    ///   - pageNo: 页码
    ///   - successComplete: 成功回调
    ///   - falidReasonHandle: 失败回调
    func getHomeTopicList(pageNo: Int,  successComplete: @escaping SuccessComplete, falidReasonHandle: @escaping FalidReasonHandle) {
        let postDic = [
            "pageSize" : "10",
            "pageNo"   : "\(pageNo)"
        ]
        
        AlamofireNetWork.sharedInstance.postRequest(UrlString: API_Home_TopicList, params: postDic,showIndicator: false, success: { (data) in
            successComplete(data)
        }) { (error) in
            falidReasonHandle(error)
        }
    }
    
    
    /// 获取帖子详情
    ///
    /// - Parameters:
    ///   - topicId: 帖子Id
    ///   - successComplete: 成功回调
    ///   - falidReasonHandle: 失败回调
    func getTopicDetal(topicId: Int,  successComplete: @escaping SuccessComplete, falidReasonHandle: @escaping FalidReasonHandle) {
        let postDic = [
            "topicId" : "\(topicId)",
        ]
        
        AlamofireNetWork.sharedInstance.postRequest(UrlString: API_Topic_Detail, params: postDic,showIndicator: false, success: { (data) in
            successComplete(data)
        }) { (error) in
            falidReasonHandle(error)
        }
    }
    
    
    /// 获取评论列表
    ///
    /// - Parameters:
    ///   - pageNo: 页码
    ///   - topicId: 帖子Id
    ///   - successComplete: 成功回调
    ///   - falidReasonHandle: 失败回调
    func getCommentList(pageNo: Int, topicId: Int, successComplete: @escaping SuccessComplete, falidReasonHandle: @escaping FalidReasonHandle) {
        let postDic = [
            "pageSize" : "10",
            "pageNo"   : "\(pageNo)",
            "topicId"  : "\(topicId)"
        ]
        
        AlamofireNetWork.sharedInstance.postRequest(UrlString: API_CommentList, params: postDic,showIndicator: false, success: { (data) in
            successComplete(data)
        }) { (error) in
            falidReasonHandle(error)
        }
    }
    
    /// 评论帖子
    ///
    /// - Parameters:
    ///   - content: 评论内容
    ///   - topicId: 帖子Id
    ///   - successComplete: 成功
    ///   - falidReasonHandle: 失败
    func addComment(content: String, topicId: Int, successComplete: @escaping SuccessComplete, falidReasonHandle: @escaping FalidReasonHandle) {
        let postDic = [
            "topicId" : "\(topicId)",
            "content" : content
        ]
        AlamofireNetWork.sharedInstance.postRequest(UrlString: API_AddComment, params: postDic,showIndicator: false, success: { (data) in
            successComplete(data)
        }) { (error) in
            falidReasonHandle(error)
        }
    }
    
    
    /// 删除评论
    ///
    /// - Parameters:
    ///   - topicId: 评论id
    ///   - successComplete: 成功
    ///   - falidReasonHandle: 失败
    func delComment(topicId: Int, successComplete: @escaping SuccessComplete, falidReasonHandle: @escaping FalidReasonHandle) {
        let postDic = [
            "topicId" : "\(topicId)",
        ]
        AlamofireNetWork.sharedInstance.postRequest(UrlString: API_DelComment, params: postDic,showIndicator: false, success: { (data) in
            successComplete(data)
        }) { (error) in
            falidReasonHandle(error)
        }
    }
    
    /// 点赞帖子
    ///
    /// - Parameters:
    ///   - topicId: 帖子Id
    ///   - isLike: 点赞还是取消点赞
    ///   - successComplete: 成功
    ///   - falidReasonHandle: 失败
    func likeTopic(topicId: Int, isLike: Bool, successComplete: @escaping SuccessComplete, falidReasonHandle: @escaping FalidReasonHandle) {
        let postDic = ["topicId": "\(topicId)"]
        AlamofireNetWork.sharedInstance.postRequest(UrlString: isLike ? API_LikeTopic : API_DisslikeTopic, params: postDic,showIndicator: false, success: { (data) in
            print("data:\(data)")
            successComplete(data)
        }) { (error) in
            falidReasonHandle(error)
        }
    }
    
    
    ///  发帖
    ///
    /// - Parameters:
    ///   - title: 标题
    ///   - content: 内容
    ///   - image: 图片列表
    ///   - successComplete: 成功
    ///   - falidReasonHandle: 失败
    func postTopic(title: String, content: String, image:String?, successComplete: @escaping SuccessComplete, falidReasonHandle: @escaping FalidReasonHandle) {
        var postDic: Dictionary<String, String> = Dictionary()
        postDic["title"] = title
        postDic["content"] = content
        if image != nil {
             postDic["img"] = image
        }
        AlamofireNetWork.sharedInstance.postRequest(UrlString: API_AddTopic, params: postDic,showIndicator: false, success: { (data) in
            successComplete(data)
        }) { (error) in
            falidReasonHandle(error)
        }
    }
    
    
    /// 删帖
    ///
    /// - Parameters:
    ///   - topicId: 帖子Id
    ///   - successComplete: 成功
    ///   - falidReasonHandle: 失败
    func delTopic(topicId: Int, successComplete: @escaping SuccessComplete, falidReasonHandle: @escaping FalidReasonHandle) {
        let postDic = ["topicId" : "\(topicId)"]
        AlamofireNetWork.sharedInstance.postRequest(UrlString: API_DelTopic, params: postDic,showIndicator: false, success: { (data) in
            successComplete(data)
        }) { (error) in
            falidReasonHandle(error)
        }
    }
    
    /// 收藏帖子
    ///
    /// - Parameters:
    ///   - topicId: 帖子id
    ///   - successComplete: 成功
    ///   - falidReasonHandle: 失败
    func collectionTopic(topicId: Int, successComplete: SuccessComplete?, falidReasonHandle: @escaping FalidReasonHandle) {
        let postDic = ["topicId" : "\(topicId)"]
        AlamofireNetWork.sharedInstance.postRequest(UrlString: API_CollectionTopic, params: postDic,showIndicator: false, success: { (data) in
            if let blcok = successComplete{
                blcok(data)
            }
        }) { (error) in
            falidReasonHandle(error)
        }
    }
    
    /// 取消收藏帖子
    ///
    /// - Parameters:
    ///   - topicId: 帖子id
    ///   - successComplete: 成功
    ///   - falidReasonHandle: 失败
    func unCollectionTopic(topicId: Int, successComplete: SuccessComplete?, falidReasonHandle: @escaping FalidReasonHandle) {
        let postDic = ["topicId" : "\(topicId)"]
        AlamofireNetWork.sharedInstance.postRequest(UrlString: API_UnCollectionTopic, params: postDic,showIndicator: false, success: { (data) in
            if let blcok = successComplete{
                blcok(data)
            }
        }) { (error) in
            falidReasonHandle(error)
        }
    }
    
    /// 评论取消点赞
    ///
    /// - Parameters:
    ///   - topicCommentId: 评论id
    ///   - successComplete: 成功
    ///   - falidReasonHandle: 失败
    func likeComment(topicCommentId: Int, isLike: Bool, successComplete: SuccessComplete?, falidReasonHandle: @escaping FalidReasonHandle) {
        let postDic = ["topicCommentId" : "\(topicCommentId)"]
        let path = isLike ? API_DisslikeComment : API_LikeComment
        AlamofireNetWork.sharedInstance.postRequest(UrlString: path, params: postDic,showIndicator: false, success: { (data) in
            if let blcok = successComplete{
                blcok(data)
            }
        }) { (error) in
            falidReasonHandle(error)
        }
    }
    
    /// 获取消息列表
    ///
    /// - Parameters:
    ///   - pageNo: 页码
    ///   - successComplete: 成功回调
    func getMessgaeList(pageNo: Int, successComplete: SuccessComplete?) {
        let postDic = [
            "pageNo" : "\(pageNo)",
            "pageSize" : "10"
        ]
        
        AlamofireNetWork.sharedInstance.getRequest(UrlString: API_GetMessage, params: postDic, success: { (data) in
            if let blcok = successComplete{
                blcok(data)
            }
        }) { (error) in
            print(error)
        }
    }
    
    /// 获取消息详情
    ///
    /// - Parameters:
    ///   - messageId: Id
    ///   - successComplete: 成功回调
    func getMessgaeDetal(messageId: Int, successComplete: SuccessComplete?) {
        let postDic = [
            "messageId" : "\(messageId)",
        ]
        AlamofireNetWork.sharedInstance.getRequest(UrlString: API_GetMessageDetal, params: postDic, success: { (data) in
            if let blcok = successComplete{
                blcok(data)
            }
        }) { (error) in
            print(error)
        }
    }
    
    /// 获取个人信息
    ///
    /// - Parameter successComplete: 成功
    func getUserInfo(successComplete: @escaping SuccessComplete) {
        AlamofireNetWork.sharedInstance.getRequest(UrlString: API_GetUserInfo, params: nil, success: { (data) in
            successComplete(data)
        }) { (error) in
            print(error)
        }
    }
    
    
    /// 获取个人帖子列表
    ///
    /// - Parameters:
    ///   - pageNo: 页码
    ///   - successComplete: 成功
    func getUserTopicList(pageNo:Int, successComplete: @escaping SuccessComplete) {
        let postDic = [
            "pageSize" : "10",
            "pageNo" : "\(pageNo)"
        ]
        AlamofireNetWork.sharedInstance.getRequest(UrlString: API_UserInfoTopicList, params: postDic, success: { (data) in
            successComplete(data)
        }) { (error) in
            print(error)
        }
    }
    
    
    /// 修改个人信息
    ///
    /// - Parameters:
    ///   - nickName: 昵称
    ///   - isSingleLogin: 是否单点登录
    ///   - headPic: 头像
    ///   - successComplete: 成功
    func changeUserInfo(nickName: String?, isSingleLogin: Bool?, headPic: String?, successComplete: @escaping SuccessComplete) {
        var postDic: Dictionary<String, String> = Dictionary()

        if let nick = nickName {
             postDic["nickname"] = nick
        }
 
        if let pic = headPic {
            postDic["headPic"] = pic
        }
        
        if let isSinger = isSingleLogin {
            postDic["isSingleLogin"] = "\(isSinger ? 1 : 0)"
        }
        
        AlamofireNetWork.sharedInstance.postRequest(UrlString: API_ChangeUserInfo, params: postDic, success: { (data) in
            successComplete(data)
        }) { (error) in
            print(error)
        }
    }
    
    /// 获取收藏帖子列表
    ///
    /// - Parameters:
    ///   - pageNo: 页码
    ///   - successComplete: 成功
    func getUserCollectionTopicList(pageNo:Int, successComplete: @escaping SuccessComplete) {
        let postDic = [
            "pageSize" : "10",
            "pageNo" : "\(pageNo)"
        ]
        AlamofireNetWork.sharedInstance.getRequest(UrlString: API_CollectionTopicList, params: postDic, success: { (data) in
            successComplete(data)
        }) { (error) in
            print(error)
        }
    }

    /// 获取关注用户列表
    ///
    /// - Parameters:
    ///   - pageNo: 页码
    ///   - successComplete: 成功
    func getUserFellowTopicList(pageNo:Int, successComplete: @escaping SuccessComplete) {
        let postDic = [
            "pageSize" : "10",
            "pageNo" : "\(pageNo)"
        ]
        AlamofireNetWork.sharedInstance.getRequest(UrlString: API_FellowList, params: postDic, success: { (data) in
            successComplete(data)
        }) { (error) in
            print(error)
        }
    }
}
