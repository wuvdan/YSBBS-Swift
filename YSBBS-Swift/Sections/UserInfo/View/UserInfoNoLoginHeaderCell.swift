//
//  UserInfoNoLoginHeaderCell.swift
//  YSBBS-Swift
//
//  Created by wudan on 2019/4/12.
//  Copyright © 2019 com.wudan. All rights reserved.
//

import UIKit

class UserInfoNoLoginHeaderCell: UITableViewCell {

    private lazy var backImageView: UIImageView = {
        let i           = UIImageView.init()
        i.contentMode   = .scaleAspectFill
        i.image         = kGetImage(imageName: "UserInfo_Default_Back.jpg")
        i.clipsToBounds = true
        return i
    }()

    private lazy var nickNameLabel: UILabel = {
        let l                 = UILabel.init()
        l.textColor           = .white
        l.font                = UIFont.systemFont(ofSize: 18)
        l.text                = "登录"
        l.textAlignment       = .center
        l.backgroundColor     = .black
        l.layer.cornerRadius  = 50
        l.layer.masksToBounds = true
        return l
    }()
    
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
        
        contentView.addSubview(backImageView)
        backImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        contentView.addSubview(nickNameLabel)
        nickNameLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(100)
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
