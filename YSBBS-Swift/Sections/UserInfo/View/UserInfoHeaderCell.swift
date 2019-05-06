//
//  UserInfoHeaderCell.swift
//  YSBBS-Swift
//
//  Created by wudan on 2019/4/11.
//  Copyright © 2019 com.wudan. All rights reserved.
//

import UIKit

class WDControl: UIControl {
    public let numLabel: UILabel = {
        let l           = UILabel.init()
        l.text          = "0"
        l.font          = UIFont.boldSystemFont(ofSize: 18)
        l.textAlignment = .center
        return l
    }()
    
    public let nameLabel: UILabel = {
        let l           = UILabel.init()
        l.textColor     = .lightGray
        l.font          = UIFont.systemFont(ofSize: 15)
        l.textAlignment = .center
        return l
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(numLabel)
        numLabel.snp.makeConstraints { (make) in
            make.top.centerX.equalToSuperview()
        }
        
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.bottom.leading.trailing.equalToSuperview()
            make.top.equalTo(numLabel.snp.bottom).offset(10)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class UserInfoHeaderCell: UITableViewCell {
    
    private lazy var backImageView: UIImageView = {
        let i           = UIImageView.init()
        i.contentMode   = .scaleAspectFill
        i.clipsToBounds = true
        return i
    }()
    
    private lazy var headerImageView: UIImageView = {
        let i                 = UIImageView.init()
        i.layer.cornerRadius  = 30
        i.layer.masksToBounds = true
        i.contentMode         = .scaleAspectFill
        i.clipsToBounds       = true
        return i
    }()
    
    private lazy var nickNameLabel: UILabel = {
        let l       = UILabel.init()
        l.textColor = .black
        l.font      = UIFont.systemFont(ofSize: 15)
        return l
    }()
    
    private lazy var emailLabel: UILabel = {
        let l       = UILabel.init()
        l.textColor = .black
        l.font      = UIFont.systemFont(ofSize: 15)
        return l
    }()
    
    private lazy var speaceLine: UIView = {
        let v             = UIView.init()
        v.backgroundColor = kCOLOR(R: 233, G: 233, B: 233)
        return v
    }()
    
    public var userInfoHeaderItmeClickBlock: ((_ tag: Int) -> Void)?
    
    private lazy var likeNumButton: WDControl = {
        let l            = WDControl.init(frame: .zero)
        l.nameLabel.text = "获赞"
        l.tag            = 1001
        l.addTarget(self, action: #selector(didTappedControl(sender:)), for: .touchUpInside)
        return l
    }()
    
    private lazy var fansNumButton: WDControl = {
        let l            = WDControl.init(frame: .zero)
        l.nameLabel.text = "粉丝"
        l.addTarget(self, action: #selector(didTappedControl(sender:)), for: .touchUpInside)
        l.tag            = 1002
        return l
    }()
    
    private lazy var topicNumButton: WDControl = {
        let l            = WDControl.init(frame: .zero)
        l.nameLabel.text = "帖子"
        l.addTarget(self, action: #selector(didTappedControl(sender:)), for: .touchUpInside)
        l.tag            = 1003
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
    
    private func setShadow(view:UIView,
                           width:CGFloat,
                           bColor:UIColor,
                           sColor:UIColor,
                           offset:CGSize,
                           opacity:Float,
                           radius:CGFloat) {
        //设置视图边框宽度
        view.layer.borderWidth = width
        //设置边框颜色
        view.layer.borderColor = bColor.cgColor
        //设置边框圆角
        view.layer.cornerRadius = radius
        //设置阴影颜色
        view.layer.shadowColor = sColor.cgColor
        //设置透明度
        view.layer.shadowOpacity = opacity
        //设置阴影半径
        view.layer.shadowRadius = 1
        //设置阴影偏移量
        view.layer.shadowOffset = offset
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        setShadow(view: self, width: 0, bColor: .white, sColor: .black, offset: CGSize(width: 0, height: 5), opacity: 0.1, radius: 10)
        
        contentView.addSubview(backImageView)
        backImageView.snp.makeConstraints { (make) in
           make.edges.equalToSuperview()
        }
        
        contentView.addSubview(headerImageView)
        headerImageView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().inset(10)
            make.top.equalToSuperview().inset(45)
            make.height.width.equalTo(60)
        }
        
        contentView.addSubview(nickNameLabel)
        nickNameLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().inset(10 + 60 + 10)
            make.bottom.equalTo(headerImageView.snp.centerY).offset(-7.5)
        }
        
        contentView.addSubview(emailLabel)
        emailLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().inset(10 + 60 + 10)
            make.top.equalTo(headerImageView.snp.centerY).offset(7.5)
        }
        
        contentView.addSubview(speaceLine)
        speaceLine.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(headerImageView.snp.bottom).offset(15)
            make.height.equalTo(0.3)
        }
        
        contentView.addSubview(likeNumButton)
        contentView.addSubview(fansNumButton)
        contentView.addSubview(topicNumButton)

        [likeNumButton, fansNumButton, topicNumButton].snp.distributeViewsAlong(axisType: .horizontal, fixedSpacing: 0, leadSpacing: 0, tailSpacing: 0)
        [likeNumButton, fansNumButton, topicNumButton].snp.makeConstraints { (make) in
            make.top.equalTo(speaceLine.snp.bottom).offset(15)
            make.height.equalTo(50)
        }
    }
    
    func setup(_ model: UserInfoModel) {
//        backImageView.kf.setImage(with: URL(string: API_Http_URL + model.headPic!))
        headerImageView.kf.setImage(with: URL(string: API_Http_URL + model.headPic!),
                             placeholder: UIImage(named: "UserInfo_Default_Back.jpg"))
//        let blur = UIBlurEffect(style: .extraLight)
//        let blurView = UIVisualEffectView(effect: blur)
//        blurView.frame = CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: 200)
//        backImageView.addSubview(blurView)
        nickNameLabel.text = model.nickname
        emailLabel.text = model.email
        likeNumButton.numLabel.text = "\(model.getLikeNum)"
        fansNumButton.numLabel.text = "\(model.fansNum)"
        topicNumButton.numLabel.text = "\(model.topicNum)"
    }
    
    @objc func didTappedControl(sender: WDControl) {
        if userInfoHeaderItmeClickBlock != nil {
            userInfoHeaderItmeClickBlock!(sender.tag)
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
