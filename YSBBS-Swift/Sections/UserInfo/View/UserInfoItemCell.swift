//
//  UserInfoItemCell.swift
//  YSBBS-Swift
//
//  Created by wudan on 2019/4/12.
//  Copyright © 2019 com.wudan. All rights reserved.
//

import UIKit

class UserInfoItemCell: UITableViewCell {
    
    public var titleLabel: UILabel = {
        let l = UILabel.init()
        l.font = UIFont.systemFont(ofSize: 15)
        l.textColor = .black
        return l
    }()
    
    public var subTitleLabel: UILabel = {
        let l = UILabel.init()
        l.font = UIFont.systemFont(ofSize: 13)
        l.textColor = .lightGray
        return l
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
