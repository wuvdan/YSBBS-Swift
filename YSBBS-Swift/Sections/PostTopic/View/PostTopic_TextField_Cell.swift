//
//  PostTopic_TextField_Cell.swift
//  YSBBS-Swift
//
//  Created by wudan on 2019/4/9.
//  Copyright © 2019 com.wudan. All rights reserved.
//

import UIKit

class PostTopic_TextField_Cell: UITableViewCell {
    
    private let textField: UITextField = {
        let t = UITextField.init()
        t.placeholder = "请输入标题"
        t.font = UIFont.systemFont(ofSize: 16)
        return t
    }()
    
    private let bottomLine: UIView = {
        let v =  UIView.init()
        v.backgroundColor = kCOLOR(R: 233, G: 233, B: 233)
        return v
    }()
    
    public var getTextWhenTextFieldEditComplete: ((_ text: String) -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        contentView.addSubview(textField)
        textField.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
        }
        
        contentView.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-0.5)
            make.height.equalTo(0.3)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(getTextWhenTextFieldEndEdit), name: UITextField.textDidEndEditingNotification, object: nil)
    }
    
    @objc func getTextWhenTextFieldEndEdit() {
        if getTextWhenTextFieldEditComplete != nil {
            getTextWhenTextFieldEditComplete!(textField.text!)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
