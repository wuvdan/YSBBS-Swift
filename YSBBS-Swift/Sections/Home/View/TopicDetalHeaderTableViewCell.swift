//
//  TopicDetalHeaderTableViewCell.swift
//  YSBBS-Swift
//
//  Created by wudan on 2019/4/3.
//  Copyright © 2019 com.wudan. All rights reserved.
//

import UIKit

class TopicDetalHeaderTableViewCell: UITableViewCell {

    class SudokuImageContainerView: UIView {
        
        var imageTapEventBlock: ((_ imageView: UIImageView, _ imageViews: Array<UIImageView>)->(Void))?
        private var imageViews: [UIImageView]?
        
        func setup(images: Array<String>) {
            imageViews = Array()
            if images.count == 2 {
                for (index) in images.enumerated() {
                    let imageV = UIImageView.init()
                    imageV.backgroundColor = kCOLOR(R: 233, G: 233, B: 233)
                    imageV.contentMode = .scaleAspectFill
                    imageV.clipsToBounds = true
                    let url = API_Http_URL + index.element
                    imageV.sd_setImage(with: URL(string: url), completed: nil)
                    imageV.layer.cornerRadius = 5
                    imageV.layer.masksToBounds = true
                    imageV.isUserInteractionEnabled = true
                    imageV.tag = index.offset
                    imageV.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(imageTapped(tapGestureRecognizer:))))
                    imageViews?.append(imageV)
                }
                
                wd_masLayoutSubViews(viewArray: imageViews!,
                                     columnOfRow:2,
                                     topBottomOfItemSpeace: 5,
                                     leftRightItemSpeace: 5,
                                     topOfSuperViewSpeace: 0,
                                     leftRightSuperViewSpeace: 0,
                                     addToSubperView: self,
                                     viewHeight: (kSCREEN_WIDTH - 60) / 3)
                
            } else if images.count == 3 {
                for (index) in images.enumerated() {
                    let imageV = UIImageView.init()
                    imageV.backgroundColor = kCOLOR(R: 233, G: 233, B: 233)
                    imageV.contentMode = .scaleAspectFill
                    imageV.clipsToBounds = true
                    let url = API_Http_URL + index.element
                    imageV.sd_setImage(with: URL(string: url), completed: nil)
                    imageV.layer.cornerRadius = 5
                    imageV.layer.masksToBounds = true
                    imageV.isUserInteractionEnabled = true
                    imageV.tag = index.offset
                    imageV.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(imageTapped(tapGestureRecognizer:))))
                    imageViews?.append(imageV)
                }
                
                wd_masLayoutSubViews(viewArray: imageViews!,
                                     columnOfRow:3,
                                     topBottomOfItemSpeace: 5,
                                     leftRightItemSpeace: 5,
                                     topOfSuperViewSpeace: 0,
                                     leftRightSuperViewSpeace: 0,
                                     addToSubperView: self,
                                     viewHeight: (kSCREEN_WIDTH - 60) / 3)
            } else if images.count == 4 {
                for (index) in images.enumerated() {
                    let imageV = UIImageView.init()
                    imageV.contentMode = .scaleAspectFill
                    imageV.backgroundColor = kCOLOR(R: 233, G: 233, B: 233)
                    imageV.clipsToBounds = true
                    let url = API_Http_URL + index.element
                    imageV.sd_setImage(with: URL(string: url), completed: nil)
                    imageV.layer.cornerRadius = 5
                    imageV.layer.masksToBounds = true
                    imageV.isUserInteractionEnabled = true
                    imageV.tag = index.offset
                    imageV.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(imageTapped(tapGestureRecognizer:))))
                    imageViews?.append(imageV)
                }
                
                wd_masLayoutSubViews(viewArray: imageViews!,
                                     columnOfRow:2,
                                     topBottomOfItemSpeace: 5,
                                     leftRightItemSpeace: 5,
                                     topOfSuperViewSpeace: 0,
                                     leftRightSuperViewSpeace: 0,
                                     addToSubperView: self,
                                     viewHeight: (kSCREEN_WIDTH - 60) / 3)
            } else {
                for (index) in images.enumerated() {
                    let imageV = UIImageView.init()
                    imageV.contentMode = .scaleAspectFill
                    imageV.backgroundColor = kCOLOR(R: 233, G: 233, B: 233)
                    imageV.clipsToBounds = true
                    let url = API_Http_URL + index.element
                    imageV.sd_setImage(with: URL(string: url), completed: nil)
                    imageV.layer.cornerRadius = 5
                    imageV.layer.masksToBounds = true
                    imageV.isUserInteractionEnabled = true
                    imageV.tag = index.offset
                    imageV.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(imageTapped(tapGestureRecognizer:))))
                    imageViews?.append(imageV)
                }
                
                wd_masLayoutSubViews(viewArray: imageViews!,
                                     columnOfRow: 3,
                                     topBottomOfItemSpeace: 5,
                                     leftRightItemSpeace: 5,
                                     topOfSuperViewSpeace: 0,
                                     leftRightSuperViewSpeace: 0,
                                     addToSubperView: self,
                                     viewHeight: (kSCREEN_WIDTH - 60) / 3)
            }
        }
        
        @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
            imageTapEventBlock!(tapGestureRecognizer.view as! UIImageView, imageViews!)
        }
        
        /// 多视图布局
        ///
        /// - Parameters:
        ///   - viewArray: 视图数组
        ///   - columnOfRow: 列数
        ///   - topBottomOfItemSpeace: 视图上下间距
        ///   - leftRightItemSpeace: 视图左右间距
        ///   - topOfSuperViewSpeace: 和父视图上间距
        ///   - leftRightSuperViewSpeace: 父视图左右间距
        ///   - addToSubperView: 父视图
        ///   - viewHeight: 视图高度
        func wd_masLayoutSubViews(viewArray:Array<UIView>,
                                  columnOfRow:Int,
                                  topBottomOfItemSpeace:CGFloat,
                                  leftRightItemSpeace:CGFloat,
                                  topOfSuperViewSpeace:CGFloat,
                                  leftRightSuperViewSpeace:CGFloat,
                                  addToSubperView:UIView,
                                  viewHeight:CGFloat) -> Void {
            
            for v in addToSubperView.subviews {
                v.removeFromSuperview()
            }
            let viewWidth = addToSubperView.bounds.width
            let tempW = leftRightSuperViewSpeace * 2 + CGFloat(columnOfRow - 1) * leftRightItemSpeace
            let itemWidth = (viewWidth - tempW) / CGFloat(columnOfRow)
            let itemHeight = viewHeight
            var lastView:UIView?
            for (i, element) in viewArray.enumerated() {
                let item: UIView = element
                addToSubperView.addSubview(item)
                item.snp.makeConstraints { (make) in
                    make.width.equalTo(itemWidth)
                    make.height.equalTo(itemHeight)
                    let top = topOfSuperViewSpeace + CGFloat(i / columnOfRow) * (itemHeight + topBottomOfItemSpeace)
                    make.top.equalTo(top)
                    
                    if !(lastView != nil) || i%columnOfRow == 0 {
                        make.left.equalTo(leftRightSuperViewSpeace)
                    } else {
                        make.left.equalTo((lastView?.snp.right)!).offset(leftRightItemSpeace)
                    }
                    lastView = item
                }
            }
        }
    }
    
    /// 头像
    private let headerPic: UIImageView = {
        let i = UIImageView.init()
        i.contentMode = .scaleToFill
        i.clipsToBounds = true
        i.layer.cornerRadius = 20
        i.layer.masksToBounds = true
        return i
    }()
    
    // 昵称
    private let nickNameLabel: UILabel = {
        let l = UILabel.init()
        l.textColor = UIColor.lightGray
        l.font = UIFont.systemFont(ofSize: 13)
        return l
    }()
    
    // 标题
    private let titleLabel: UILabel = {
        let l = UILabel.init()
        l.textColor = UIColor.black
        l.numberOfLines = 0
        l.font = UIFont.systemFont(ofSize: 15)
        return l
    }()
    
    // 内容
    private let contentLabel: UILabel = {
        let l = UILabel.init()
        l.textColor = UIColor.lightGray
        l.font = UIFont.systemFont(ofSize: 13)
        l.numberOfLines = 0
        l.lineBreakMode = NSLineBreakMode.byTruncatingTail
        return l
    }()
    
    // 时间
    private let timeLabel: UILabel = {
        let l = UILabel.init()
        l.textColor = UIColor.lightGray
        l.font = UIFont.systemFont(ofSize: 11)
        return l
    }()
    
    // 点赞按钮
    private lazy var shareButton: UIButton = {
        let l = UIButton.init()
        l.setImage(kGetImage(imageName: "share"), for: .normal)
        l.addTarget(self, action: #selector(didTappedLikeButton), for: .touchUpInside)
        return l
    }()
    
    
    // 单图
    private lazy var singleImageView: UIImageView = {
        let img = UIImageView.init()
        img.backgroundColor = kCOLOR(R: 233, G: 233, B: 233)
        img.contentMode = .scaleAspectFill
        img.layer.cornerRadius = 5
        img.layer.masksToBounds = true
        img.isUserInteractionEnabled = true
        img.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(imageTappedTarget(sender:))))
        return img
    }()
    
    // 九宫格图片
    private let sudoImagesContainerView: SudokuImageContainerView = {
        let v = SudokuImageContainerView.init()
        v.layer.masksToBounds = true
        return v
    }()
    
    public var didTappedLikeButtonBlock: ((_ model: HomeTopicListModel) -> Void)?
    public var didTappedCommentButtonBlock: (() -> Void)?
    
    private var _model: HomeTopicListModel?
    public var model: HomeTopicListModel {
        get {
            return _model!
        } set {
            _model = newValue
            if newValue.img!.count > 0 {
                let imageUrls = newValue.img!.components(separatedBy: ",")
                if imageUrls.count == 1 {
                    singleImageView.isHidden = false
                    sudoImagesContainerView.isHidden = true
                    singleImageView.sd_setImage(with: URL.init(string: API_Http_URL + newValue.imgURLArray!.first!), completed: nil)
                    singleImageView.snp.updateConstraints { (make) in
                        make.width.equalTo(newValue.imgWidthArray.first!)
                        make.height.equalTo(newValue.imgHeightArray.first!)
                    }
                } else {
                    sudoImagesContainerView.isHidden = false
                    singleImageView.isHidden = true
                    sudoImagesContainerView.snp.updateConstraints { (make) in
                        if imageUrls.count <= 3 {
                            make.height.equalTo((kSCREEN_WIDTH - 60) / 3)
                            make.width.equalTo((kSCREEN_WIDTH - 60) / 3 * CGFloat(imageUrls.count))
                        } else if imageUrls.count == 4 {
                            make.height.equalTo((kSCREEN_WIDTH - 60) / 3 * 2 + 5)
                            make.width.equalTo((kSCREEN_WIDTH - 60) / 3 * 2)
                        } else if imageUrls.count < 7 {
                            make.height.equalTo((kSCREEN_WIDTH - 60) / 3 * 2 + 5)
                            make.width.equalTo((kSCREEN_WIDTH - 60))
                        } else {
                            make.height.equalTo((kSCREEN_WIDTH - 60) / 3 * 3 + 10)
                            make.width.equalTo((kSCREEN_WIDTH - 60))
                        }
                    }
                    sudoImagesContainerView.setup(images: imageUrls)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                        self.sudoImagesContainerView.setup(images: imageUrls)
                    }
                }
            } else {
                singleImageView.isHidden = true
                sudoImagesContainerView.isHidden = true
            }
            
            headerPic.kf.setImage(with: URL(string: API_Http_URL + newValue.headPic!),
                                  placeholder: UIImage(named: "yundian_tupian"))
            nickNameLabel.text = newValue.nickname
            titleLabel.text = newValue.title
            contentLabel.text = newValue.content
            timeLabel.text = Date.created_at(date: DateUtils.handleStringDate_YYMMDDTHHmmss(dateString: newValue.createTime!))
        }
    }
    
    @objc func imageTappedTarget(sender: UITapGestureRecognizer) {
        
        let v = WDPhotoBrowser()
        v.setup(with: sender.view!, originImageRect: model.imgOrignRectArray!.first!, imageUrls: model.imgURLArray!, tappedIndex: 0)
        v.showBrowser { (index) -> UIView in
            return sender.view!
        }
    }
    
    @objc func didTappedCommentButton() {
        if (didTappedCommentButtonBlock != nil) {
            didTappedCommentButtonBlock!()
        }
    }
    
    @objc func didTappedLikeButton() {
        let textShare = "易社，一个专注于帖子的APP"
        let imageShare = UIImage(named: "Y")
        let urlShare = URL(string: "http://www.wudan.ink")
        let activityItems = [textShare,imageShare as Any,urlShare as Any]
        let vc = UIActivityViewController.init(activityItems: activityItems, applicationActivities: nil)
        vc.excludedActivityTypes = [.postToWeibo, .postToVimeo, .postToTwitter]
        vc.completionWithItemsHandler = { (activityType, completed, returnedItems, activityError) -> Void in
            print(completed ? "成功" : "失败")
        }
        window?.rootViewController?.present(vc, animated: true, completion: nil)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        contentView.addSubview(headerPic)
        headerPic.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(10)
            make.leading.equalToSuperview().inset(10)
            make.width.height.equalTo(40)
        }
        
        contentView.addSubview(nickNameLabel)
        nickNameLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(headerPic)
            make.leading.equalTo(headerPic.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(10)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(headerPic.snp.bottom).offset(10)
            make.trailing.leading.equalToSuperview().inset(10)
        }
        
        contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.trailing.leading.equalToSuperview().inset(10)
        }
        
        contentView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(10)
        }
        
        contentView.addSubview(shareButton)
        shareButton.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().inset(10)
            make.centerY.equalTo(timeLabel)
        }

        contentView.addSubview(singleImageView)
        singleImageView.snp.makeConstraints { (make) in
            make.top.equalTo(contentLabel.snp.bottom).offset(30)
            make.leading.equalToSuperview().inset(10)
            make.height.equalTo(0)
            make.width.equalTo(0)
        }
        
        contentView.addSubview(sudoImagesContainerView)
        sudoImagesContainerView.snp.makeConstraints { (make) in
            make.top.equalTo(contentLabel.snp.bottom).offset(30)
            make.leading.equalToSuperview().inset(30)
            make.height.equalTo(0)
            make.width.equalTo(0)
        }
        
        sudoImagesContainerView.imageTapEventBlock = { [weak self] (view, imageViews) in
            guard let strongSelf = self else { return }
            let v = WDPhotoBrowser()
            v.setup(with: view, originImageRect: strongSelf.model.imgOrignRectArray![view.tag], imageUrls: strongSelf.model.imgURLArray!, tappedIndex: view.tag)
            v.showBrowser(scrollBlock: { (index) -> UIView in
                return imageViews[index]
            })
            return
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
