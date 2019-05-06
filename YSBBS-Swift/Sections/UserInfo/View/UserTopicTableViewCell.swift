//
//  UserTopicTableViewCell.swift
//  YSBBS-Swift
//
//  Created by wudan on 2019/4/12.
//  Copyright © 2019 com.wudan. All rights reserved.
//

import UIKit
import SDWebImage


class UserTopicTableViewCell: UITableViewCell {

    private let titleLabel: UILabel = {
        let l = UILabel.init()
        l.textColor = .black
        l.numberOfLines = 0
        l.font = UIFont.systemFont(ofSize: 15)
        return l
    }()
    
    private let contentLabel: UILabel = {
        let l = UILabel.init()
        l.textColor = .lightGray
        l.numberOfLines = 3
        l.font = UIFont.systemFont(ofSize: 14)
        return l
    }()
    
    // 时间
    private let timeLabel: UILabel = {
        let l = UILabel.init()
        l.textColor = UIColor.lightGray
        l.font = UIFont.systemFont(ofSize: 11)
        return l
    }()
    
    // 点赞按钮
    private let likeButton: UIButton = {
        let l = UIButton.init()
        l.setTitle(" 0", for: .normal)
        l.setTitleColor(UIColor.lightGray, for: .normal)
        l.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        l.setImage(kGetImage(imageName: "UnLike_Button"), for: .normal)
        return l
    }()
    
    // 评论按钮
    private let commentButton: UIButton = {
        let l = UIButton.init()
        l.setTitle(" 0", for: .normal)
        l.setTitleColor(UIColor.lightGray, for: .normal)
        l.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        l.setImage(kGetImage(imageName: "Comment"), for: .normal)
        return l
    }()
    
    private let coverImageView: UIImageView = {
        let i = UIImageView.init()
        i.contentMode = .scaleAspectFill
        i.clipsToBounds = true
        return i
    }()
    
    private var _model: HomeTopicListModel?
    public var model: HomeTopicListModel {
        get {
            return _model!
        } set {
            _model = newValue
            titleLabel.text = newValue.title
            contentLabel.text = newValue.content
            timeLabel.text = Date.created_at(date: DateUtils.handleStringDate_YYMMDDTHHmmss(dateString: newValue.createTime!))
            commentButton.setTitle(" \(newValue.commentNum)", for: .normal)
            likeButton.setTitle(" \(newValue.likeNum)", for: .normal)
            let imageUrls = newValue.img!.components(separatedBy: ",")
            coverImageView.kf.setImage(with: URL(string: API_Http_URL + imageUrls.first!),
                                  placeholder: UIImage(named: "yundian_tupian"))
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        contentView.addSubview(coverImageView)
        coverImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(10)
            make.trailing.equalToSuperview().inset(10)
            make.width.height.equalTo(100)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().inset(10)
            make.trailing.equalTo(coverImageView.snp.leading).offset(-10)
        }
        
        contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(10)
            make.trailing.equalTo(coverImageView.snp.leading).offset(-10)
            make.bottom.lessThanOrEqualTo(coverImageView)
        }
        
        contentView.addSubview(commentButton)
        commentButton.snp.makeConstraints { (make) in
            make.top.equalTo(coverImageView.snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(10)
        }
        
        contentView.addSubview(likeButton)
        likeButton.snp.makeConstraints { (make) in
            make.leading.equalTo(commentButton.snp.trailing).offset(10)
            make.centerY.equalTo(commentButton)
        }
        
        contentView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().inset(10)
            make.centerY.equalTo(commentButton)
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
