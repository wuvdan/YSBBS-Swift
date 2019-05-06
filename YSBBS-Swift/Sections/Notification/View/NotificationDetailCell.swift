//
//  NotificationDetailCell.swift
//  YSBBS-Swift
//
//  Created by wudan on 2019/4/11.
//  Copyright © 2019 com.wudan. All rights reserved.
//

import UIKit

class NotificationDetailCell: UITableViewCell {
    
    private let titleLabel: UILabel = {
        let t = UILabel.init()
        t.font = UIFont.systemFont(ofSize: 16)
        t.textAlignment = .center
        t.textColor = .black
        t.numberOfLines = 0
        return t
    }()
    
    private let contentLabel: UILabel = {
        let t = UILabel.init()
        t.font = UIFont.systemFont(ofSize: 15)
        t.textColor = .lightGray
        t.numberOfLines = 0
        return t
    }()
    
    func setup(_ model: MessageDetalModel) {
        titleLabel.text = model.title
        contentLabel.text = model.content
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
        layer.cornerRadius = 5
        layer.masksToBounds = true
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(10)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        
        contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview().inset(10)
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
