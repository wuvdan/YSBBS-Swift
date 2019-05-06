//
//  TopicCommentTableViewCell.swift
//  YSBBS-Swift
//
//  Created by wudan on 2019/4/3.
//  Copyright © 2019 com.wudan. All rights reserved.
//

import UIKit

class TopicCommentTableViewCell: UITableViewCell {
    
    /// 头像
    lazy var headerPic: UIImageView = {
        let i = UIImageView.init()
        i.contentMode = .scaleToFill
        i.clipsToBounds = true
        i.layer.cornerRadius = 15
        i.layer.masksToBounds = true
        return i
    }()
    
    // 昵称
    lazy var nickNameLabel: UILabel = {
        let l = UILabel.init()
        l.textColor = UIColor.lightGray
        l.font = UIFont.systemFont(ofSize: 13)
        return l
    }()
    
    // 标题
    lazy var titleLabel: UILabel = {
        let l = UILabel.init()
        l.textColor = UIColor.black
        l.font = UIFont.systemFont(ofSize: 15)
        l.numberOfLines = 0
        return l
    }()
    
    // 时间
    lazy var timeLabel: UILabel = {
        let l = UILabel.init()
        l.textColor = UIColor.lightGray
        l.font = UIFont.systemFont(ofSize: 11)
        return l
    }()
    
    // 点赞按钮
    lazy var likeButton: UIButton = {
        let l = UIButton.init()
        l.setTitle(" 0", for: .normal)
        l.setImage(kGetImage(imageName: "Coment_Like_Button"), for: .selected)
        l.setImage(kGetImage(imageName: "Coment_UnLike_Button"), for: .normal)
        l.setTitleColor(UIColor.lightGray, for: .normal)
        l.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        l.addTarget(self, action: #selector(didTappedLikeButton(sender:)), for: .touchUpInside)
        return l
    }()
    
    var likeClickBlock: ((_ model: CommentListModel) -> Void)?
    
    var _model: CommentListModel?
    var model: CommentListModel {
        get {
            return _model!
        } set {
            _model = newValue
            headerPic.kf.setImage(with: URL(string: API_Http_URL + newValue.headPic!),
                                  placeholder: UIImage(named: "yundian_tupian"))
            nickNameLabel.text = newValue.nickname
            titleLabel.text = newValue.content
            timeLabel.text = Date.created_at(date: DateUtils.handleStringDate_YYMMDDTHHmmss(dateString: newValue.createTime!))
            likeButton.setTitle(" \(newValue.likeNum)", for: .normal)
            likeButton.isSelected = newValue.isLike
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
    
        contentView.addSubview(headerPic)
        headerPic.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(10)
            make.leading.equalToSuperview().inset(10)
            make.width.height.equalTo(30)
        }
        
        contentView.addSubview(nickNameLabel)
        nickNameLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(headerPic)
            make.leading.equalTo(headerPic.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(10)
        }
        
        contentView.addSubview(likeButton)
        likeButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(headerPic)
            make.trailing.equalToSuperview().inset(10)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(headerPic.snp.bottom).offset(10)
            make.trailing.leading.equalToSuperview().inset(10)
        }
        
        contentView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.trailing.leading.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(10)
        }
    }
    
    @objc func didTappedLikeButton(sender: UIButton) {
        if likeClickBlock != nil {
            likeClickBlock!(model)
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
