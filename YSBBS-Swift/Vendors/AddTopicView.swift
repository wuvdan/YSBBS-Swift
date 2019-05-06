//
//  AddTopicView.swift
//  YSBBS-Swift
//
//  Created by wudan on 2019/3/1.
//  Copyright © 2019 com.wudan. All rights reserved.
//

import UIKit

class AddTopicView: UIButton {
    private var mainButton: UIButton = {
        let b = UIButton.init()
        b.setImage(kGetImage(imageName: "Home_Spread_Button"), for: .normal)
        b.backgroundColor = .black
        b.layer.cornerRadius = 45 / 2
        b.layer.masksToBounds = true
        b.addTarget(self, action: #selector(mainButtonTouched(sender:)), for: .touchUpInside)
        return b
    }()
    
    private var userInfoButton: UIButton = {
        let b = UIButton.init()
        b.setImage(kGetImage(imageName: "Home_UserInfo_Button"), for: .normal)
        b.backgroundColor = .black
        b.layer.cornerRadius = 45 / 2
        b.layer.masksToBounds = true
        b.addTarget(self, action: #selector(userButtonTouched(sender:)), for: .touchUpInside)
        return b
    }()
    
    private var addButton: UIButton = {
        let b = UIButton.init()
        b.setImage(kGetImage(imageName: "Home_Add_Button"), for: .normal)
        b.backgroundColor = .black
        b.layer.cornerRadius = 45 / 2
        b.layer.masksToBounds = true
        b.addTarget(self, action: #selector(addButtonTouched(sender:)), for: .touchUpInside)
        return b
    }()
    
    private var oldRect: CGRect = CGRect.zero
    private var oldSupview: UIView = UIView.init()
    
    private let originRect = CGRect(x: 15, y: kSCREEN_HEIGHT - kSafeAreaBottomHeight - 15 - 45 , width: 45, height: 45)
    
    var addTopicBlock:(()-> Void)?
    var userInfoBlock:(()-> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        addTarget(self, action: #selector(originButtonTouched(sender:)), for: .touchUpInside)
        addSubview(addButton)
        addSubview(userInfoButton)
        addSubview(mainButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if oldRect.width == 0 {
            oldSupview = superview!
            oldRect = self.frame
            mainButton.frame = self.bounds
            addButton.frame = self.bounds
            userInfoButton.frame = self.bounds
        }
    }
}

@objc
extension AddTopicView {
    func originButtonTouched(sender: UIButton)  {
        dismiss()
        mainButton.isSelected = false
    }
    
    func addButtonTouched(sender: UIButton)  {
        dismiss()
        mainButton.isSelected = false
        if (addTopicBlock != nil) {
            addTopicBlock!()
        }
    }
    
    func userButtonTouched(sender: UIButton)  {
        dismiss()
        mainButton.isSelected = false
        if (userInfoBlock != nil) {
            userInfoBlock!()
        }
    }
    
    func mainButtonTouched(sender: UIButton)  {
        if sender.isSelected {
            dismiss()
        } else {
            show()
        }
        
        sender.isSelected = !sender.isSelected
    }
    
    func show() {
        self.removeFromSuperview()
        UIApplication.shared.delegate?.window!!.addSubview(self)
        self.frame = kSCREEN_BOUNDS
        mainButton.frame = originRect
        addButton.frame = originRect
        userInfoButton.frame = originRect
        
        UIView.animate(withDuration: 0.3) {
            self.mainButton.transform = CGAffineTransform(rotationAngle: -.pi / 2)
            self.addButton.frame = CGRect(x: 15 + self.mainButton.frame.maxX, y: kSCREEN_HEIGHT - kSafeAreaBottomHeight - 15 - 45 , width: 45, height: 45)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.userInfoButton.frame = CGRect(x: 15 + self.addButton.frame.maxX, y: kSCREEN_HEIGHT - kSafeAreaBottomHeight - 15 - 45 , width: 45, height: 45)
        }
    }
    
    func dismiss() {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.mainButton.frame = self.originRect
            self.addButton.frame = self.originRect
            self.userInfoButton.frame = self.originRect
            self.mainButton.transform = CGAffineTransform.identity
        }) { (complete) in
            self.removeFromSuperview()
            self.oldSupview.addSubview(self)
            self.mainButton.frame = CGRect(x: 0, y: 0 , width: 45, height: 45)
            self.addButton.frame = CGRect(x: 0, y: 0 , width: 45, height: 45)
            self.userInfoButton.frame = CGRect(x: 0, y: 0 , width: 45, height: 45)
            self.frame = CGRect(x: 15, y: kSCREEN_HEIGHT - kSafeAreaBottomHeight - 15 - 45 , width: 45, height: 45)
        }
    }
}
