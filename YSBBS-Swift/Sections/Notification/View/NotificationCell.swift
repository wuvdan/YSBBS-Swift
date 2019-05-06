//
//  NotificationCell.swift
//  YSBBS-Swift
//
//  Created by wudan on 2019/4/11.
//  Copyright © 2019 com.wudan. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {
    
    private let tagCycle: UIView = {
        let v = UIView.init()
        v.backgroundColor = .black
        v.layer.cornerRadius = 7.5
        v.layer.masksToBounds = true
        return v
    }()
    
    private let titleLabel: UILabel = {
        let t = UILabel.init()
        t.font = UIFont.systemFont(ofSize: 16)
        t.text = "个人消息"
        t.textColor = .black
        return t
    }()
    
    private let timeLabel: UILabel = {
        let t = UILabel.init()
        t.font = UIFont.systemFont(ofSize: 13)
        t.text = "2019-04-11 13:12:13"
        t.textColor = .lightGray
        return t
    }()
    
    private let contentLabel: UILabel = {
        let t = UILabel.init()
        t.font = UIFont.systemFont(ofSize: 16)
        t.text = "2019-04-11 13:12:13"
        t.textColor = .black
        return t
    }()
    
    private let dividingLine: UIView = {
        let v = UIView.init()
        v.backgroundColor = kCOLOR(R: 233, G: 233, B: 233)
        return v
    }()
    
    private let checkDetailLabel: UILabel = {
        let t = UILabel.init()
        t.font = UIFont.systemFont(ofSize: 12)
        t.text = "查看详情"
        t.textColor = .lightGray
        return t
    }()
    
    private let moreImageView: UIImageView = {
        let i = UIImageView.init()
        i.image = kGetImage(imageName: "right").withRenderingMode(.alwaysTemplate)
        i.tintColor = .lightGray
        return i
    }()
    
    func setup(_ model: MessageListModel) {
        tagCycle.backgroundColor = model.isRead ? .lightGray : .black
        titleLabel.text = model.messageType == 1 ? "个人消息" : "系统消息"
        contentLabel.text = model.messageTitle
        timeLabel.text = model.createTime
    }
    
    override var frame: CGRect {
        didSet{
            var newFrame = frame
            newFrame.origin.x += 15
            newFrame.size.width -= 30
            super.frame = newFrame
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        layer.cornerRadius = 10
        layer.masksToBounds = true
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(10)
            make.leading.equalToSuperview().inset(10 + 15 + 10)
        }
        
        contentView.addSubview(tagCycle)
        tagCycle.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleLabel)
            make.width.height.equalTo(15)
            make.leading.equalToSuperview().inset(10)
        }
        
        contentView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(10)
        }
        
        contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(timeLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(10)
        }
        
        contentView.addSubview(dividingLine)
        dividingLine.snp.makeConstraints { (make) in
            make.top.equalTo(contentLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(0.3)
        }
        
        contentView.addSubview(checkDetailLabel)
        checkDetailLabel.snp.makeConstraints { (make) in
            make.top.equalTo(dividingLine.snp.bottom).offset(10)
            make.bottom.equalToSuperview().inset(10)
            make.leading.equalToSuperview().inset(10)
        }
        
        contentView.addSubview(moreImageView)
        moreImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(checkDetailLabel)
            make.trailing.equalToSuperview().inset(10)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
