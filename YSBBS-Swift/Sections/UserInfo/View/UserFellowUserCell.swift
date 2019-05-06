//
//  UserFellowUserCell.swift
//  YSBBS-Swift
//
//  Created by wudan on 2019/4/15.
//  Copyright © 2019 com.wudan. All rights reserved.
//

import UIKit

class UserFellowUserCell: UITableViewCell {
    
    private let titleLabel: UILabel = {
        let l = UILabel.init()
        l.font = UIFont.systemFont(ofSize: 15)
        l.textColor = .black
        return l
    }()
    
    private let headPic: UIImageView = {
        let i = UIImageView.init()
        i.clipsToBounds = true
        i.contentMode = .scaleAspectFill
        i.layer.cornerRadius = 22.5
        i.layer.masksToBounds = true
        return i
    }()
    
    func setup(model: UserFellowUserModel) {
        titleLabel.text = model.nickname
        headPic.kf.setImage(with: URL(string: API_Http_URL + model.headPic!),
                                   placeholder: UIImage(named: "yundian_tupian"))
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        contentView.addSubview(headPic)
        headPic.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview().inset(15)
            make.height.width.equalTo(45)
            make.leading.equalToSuperview().inset(15)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalTo(headPic.snp.trailing).offset(10)
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
