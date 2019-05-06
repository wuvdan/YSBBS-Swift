//
//  UserInfoSettingCell.swift
//  YSBBS-Swift
//
//  Created by wudan on 2019/4/12.
//  Copyright © 2019 com.wudan. All rights reserved.
//

import UIKit

class UserInfoSettingCell: UITableViewCell {

    public var titleLabel: UILabel = {
        let l = UILabel.init()
        l.font = UIFont.systemFont(ofSize: 15)
        l.textColor = .black
        return l
    }()
    
    public lazy var subTitleLabel: UILabel = {
        let l = UILabel.init()
        l.font = UIFont.systemFont(ofSize: 13)
        l.textColor = .lightGray
        return l
    }()
    
    public lazy var headerImageView: UIImageView = {
        let i = UIImageView.init()
        i.layer.cornerRadius = 30
        i.layer.masksToBounds = true
        i.clipsToBounds = true
        i.contentMode = .scaleAspectFill
        return i
    }()
    
    public lazy var switchControl: UISwitch = {
        let s = UISwitch.init()
        return s
    }()
    
    override var frame: CGRect {
        didSet{
            var newFrame = frame
            newFrame.origin.y += 5
            newFrame.origin.x += 15
            newFrame.size.width -= 30
            newFrame.size.height -= 10
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
            make.leading.equalTo(15)
            make.centerY.equalToSuperview()
        }
        
        contentView.addSubview(subTitleLabel)
        subTitleLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(-15)
            make.centerY.equalToSuperview()
        }
        
        contentView.addSubview(switchControl)
        switchControl.snp.makeConstraints { (make) in
            make.trailing.equalTo(-15)
            make.centerY.equalToSuperview()
        }
        
        contentView.addSubview(headerImageView)
        headerImageView.snp.makeConstraints { (make) in
            make.trailing.equalTo(-15)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(60)
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
