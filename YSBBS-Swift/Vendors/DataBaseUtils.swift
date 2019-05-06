//
//  DataBaseUtils.swift
//  YSBBS-Swift
//
//  Created by wudan on 2019/4/8.
//  Copyright © 2019 com.wudan. All rights reserved.
//

import UIKit
import FMDB
import SwiftyJSON

let HomeListTable    = "HomeListTable"
let CommentListTable = "CommentListTable"
let UseInfoTable     = "UseInfoTable"

class DataBaseUtils: NSObject {
    static let defaultManger = DataBaseUtils()
    typealias successBlock = () -> Void
    typealias failBlock = () -> Void
    
    lazy var fmdb:FMDatabase = {
        let path = NSHomeDirectory().appending("/Documents/wudan_ys_app.db")
        let db = FMDatabase(path: path)
        return db
    }()
    
    func creatTable(tableName:String) -> Void {
        fmdb.open()
        let creatSql = "create table if not exists \(tableName) (id integer primary key autoincrement,model BLOB)"
        let result = fmdb.executeUpdate(creatSql, withArgumentsIn:[])
        if result{
//            print("创建表成功")
        }
    }
    
    func dropTable(tableName:String) -> Void {
        fmdb.open()
        let sql = "drop table if exists " + tableName
        let result = fmdb.executeUpdate(sql, withArgumentsIn:[])
        if result{
//            print("删除表成功")
        }
    }
    
    func insert(model: HomeTopicListModel, tableName: String, successBlock: successBlock) -> Void {
        let modelData: Data = NSKeyedArchiver.archivedData(withRootObject: model)
        let insertSql = "insert into " + tableName + " (model) values(?)"
        do {
            try fmdb.executeUpdate(insertSql, values: [modelData])
            successBlock()
        } catch {
            print("错误出现了❌")
        }
    }
    
    func insertComment(model: CommentListModel, tableName: String, successBlock: successBlock) -> Void {
        let modelData: Data = NSKeyedArchiver.archivedData(withRootObject: model)
        let insertSql = "insert into " + tableName + " (model) values(?)"
        do {
            try fmdb.executeUpdate(insertSql, values: [modelData])
            successBlock()
        } catch {
            print("错误出现了❌")
        }
    }
    
    func insertUserInfo(model: UserInfoModel, tableName: String, successBlock: successBlock) -> Void {
        let modelData: Data = NSKeyedArchiver.archivedData(withRootObject: model)
        let insertSql = "insert into " + tableName + " (model) values(?)"
        do {
            try fmdb.executeUpdate(insertSql, values: [modelData])
            successBlock()
        } catch {
            print("错误出现了❌")
        }
    }
    
    func update(model: NSObject, tableName: String, uid:Int32, successBlock: successBlock?, failBlock: failBlock?) -> Void {
        var modelData: NSObject?
        if #available(iOS 11.0, *) {
            modelData = try! NSKeyedArchiver.archivedData(withRootObject: model, requiringSecureCoding: false) as NSObject
        } else {
            modelData = NSKeyedArchiver.archivedData(withRootObject: model) as NSObject
        }
        let updateSql = "update " + tableName + " set model = ? where id = ?"
        do {
            try fmdb.executeUpdate(updateSql, values: [modelData as Any, uid])
            successBlock!()
        } catch {
            failBlock!()
        }
    }
    
    func selectAll(tableName: String) -> [NSObject] {
        fmdb.open()
        var tmpArr = [NSObject]()
        let selectSql = "select * from " + tableName
        do {
            let rs = try fmdb.executeQuery(selectSql, values:nil)
            while rs.next() {
                var model = NSObject()
                let modelData = rs.data(forColumn:"model")
                let id = rs.int(forColumn: "id")
                model = NSKeyedUnarchiver.unarchiveObject(with: modelData!) as! NSObject
                model.wd_fmdb_id = id
                tmpArr.append(model)
            }
        } catch {
            print(fmdb.lastError())
        }
        return tmpArr
    }
    
    func delete(uid:Int32,tableName: String, successBlock: successBlock, failBlock: failBlock) -> Void {
        let deleteSql = "delete from " + tableName + " where id = ?"
        do {
            try fmdb.executeUpdate(deleteSql, values: [uid])
            successBlock()
        } catch {
            print(fmdb.lastError())
            failBlock()
        }
    }
}

private var wd_id_key: String = "key"

extension NSObject {
    open var wd_fmdb_id:Int32? {
        get { return (objc_getAssociatedObject(self, &wd_id_key) as? Int32) }
        set(newValue) { objc_setAssociatedObject(self, &wd_id_key, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN) }
    }
}
