//
//  NotificationDetailHeaderView.swift
//  YSBBS-Swift
//
//  Created by wudan on 2019/4/11.
//  Copyright © 2019 com.wudan. All rights reserved.
//

import UIKit

class NotificationDetailHeaderView: UIView {

    public lazy var timeLabel: UILabel = {
        let l = UILabel.init()
        l.textColor = .white
        l.textAlignment = .center
        l.font = UIFont.systemFont(ofSize: 13)
        l.backgroundColor = UIColor.init(white: 0, alpha: 0.2)
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
