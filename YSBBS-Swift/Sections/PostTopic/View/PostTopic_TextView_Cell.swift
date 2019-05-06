//
//  PostTopic_TextView_Cell.swift
//  YSBBS-Swift
//
//  Created by wudan on 2019/4/9.
//  Copyright © 2019 com.wudan. All rights reserved.
//

import UIKit

class WDTextView: UITextView, UITextViewDelegate {
    var maxHeight: CGFloat = CGFloat.greatestFiniteMagnitude //定义最大高度
    public var placeholerLabel: UILabel = {
        let l = UILabel.init()
        l.textColor = .lightGray
        return l
    }()
    
    override var font: UIFont? {
        didSet {
            placeholerLabel.font = font
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        placeholerLabel.frame = CGRect(x: textContainerInset.left + 3, y: textContainerInset.top, width: frame.width, height: font!.lineHeight)
    }

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.delegate = self
        addSubview(placeholerLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var getTextWhenTextViewEditComplete:((_ text: String) -> (Void))?
    public var getTextViewHeightWhenDidChange: ((_ textHeight: CGFloat) -> Void)?
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholerLabel.isHidden = textView.text.count != 0
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        placeholerLabel.isHidden = textView.text.count != 0
        if (getTextWhenTextViewEditComplete != nil) {
            getTextWhenTextViewEditComplete!(textView.text)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholerLabel.isHidden = textView.text.count != 0
        //获取frame值
        let frame = textView.frame
        //定义一个constrainSize值用于计算textview的高度
        let constrainSize=CGSize(width:frame.size.width,height:CGFloat(MAXFLOAT))
        // 获取textview的真实高度
        var size = textView.sizeThatFits(constrainSize)
        // 如果textview的高度大于最大高度高度就为最大高度并可以滚动，否则不能滚动
        if size.height >= maxHeight{
            size.height = maxHeight
            textView.isScrollEnabled = true
        } else {
            textView.isScrollEnabled = false
        }
        // 重新设置textview的高度
        textView.frame.size.height = size.height
        if getTextViewHeightWhenDidChange != nil {
            getTextViewHeightWhenDidChange!(size.height)
        }
    }
}

class PostTopic_TextView_Cell: UITableViewCell {

    private let textView: WDTextView = {
        let t = WDTextView.init(frame: .zero)
        t.isScrollEnabled = false
        t.font = UIFont.systemFont(ofSize: 15)
        t.placeholerLabel.text = "请输入内容..."
        return t
    }()

    public var textViewDidChange:((_ textHeight: CGFloat) -> (Void))?
    public var getTextWhenTextViewEditComplete:((_ text: String) -> (Void))?

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.addSubview(textView)
      
        textView.getTextViewHeightWhenDidChange = { [weak self] textViewHeight in
            guard let strongSelf = self else { return }
            if strongSelf.textViewDidChange != nil {
                if (textViewHeight < 80) {
                    strongSelf.textViewDidChange!(80)
                } else {
                    strongSelf.textViewDidChange!(textViewHeight + 20)
                }
            }
        }
        textView.getTextWhenTextViewEditComplete = {
            if (self.getTextWhenTextViewEditComplete != nil) {
                self.getTextWhenTextViewEditComplete!($0)
            }
        }
        textView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.bottom.equalToSuperview().inset(10)
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

