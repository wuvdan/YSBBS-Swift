//
//  WDPhotoBrowser.swift
//  YSBBS-Swift
//
//  Created by wudan on 2019/5/5.
//  Copyright © 2019 com.wudan. All rights reserved.
//

import UIKit
import Photos
import AssetsLibrary

class WDPhotoBrowserCell: UICollectionViewCell {
    lazy var imageView: UIImageView = {
        let i = UIImageView.init()
        i.contentMode = .scaleAspectFill
        i.clipsToBounds = true
        i.isUserInteractionEnabled = true
        self.scrollView.addSubview(i)
        return i
    }()
    
    lazy var scrollView: UIScrollView = {
        let s = UIScrollView.init(frame: kSCREEN_BOUNDS)
        s.showsVerticalScrollIndicator = false
        s.showsHorizontalScrollIndicator = false
        s.backgroundColor = .clear
        s.minimumZoomScale = 1.0
        s.maximumZoomScale = 4.0;
        s.bouncesZoom = true
        s.delegate = self
        if #available(iOS 11.0, *) {
            s.contentInsetAdjustmentBehavior = .never
        } else {
            
        }
        return s
    }()
    
    public var singleTappedComplete: (() -> Void)?
    public var panChangeComplete: ((_ progress: CGFloat) -> Void)?
    private var firstTouchPoint: CGPoint = .zero
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(scrollView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addPanGusture()
    }
    
    private var url: String = ""
    func setupView(with urlString: String) {
        url = urlString
        imageView.sd_setImage(with: URL(string: API_Http_URL + urlString)) { (image, error, type, nil) in
            self.setImageView(with: image!)
        }
    }
    
    private func addPanGusture() {
        let pan = UIPanGestureRecognizer.init(target: self, action: #selector(didRecognizedPanTap(sender:)))
        pan.delegate = self
        if !(scrollView.gestureRecognizers?.contains(pan))! {
            scrollView.addGestureRecognizer(pan)
        }
    }
    
    private func addTappedGuesture() {
        let doubleTap = UITapGestureRecognizer.init(target: self, action: #selector(didRecognizedDoubleTap(sender:)))
        doubleTap.numberOfTapsRequired = 2
        imageView.addGestureRecognizer(doubleTap)
        
        let singleTap = UITapGestureRecognizer.init(target: self, action: #selector(didRecognizedSingleTap(sender:)))
        singleTap.numberOfTapsRequired = 1
        singleTap.require(toFail: doubleTap)
        scrollView.addGestureRecognizer(singleTap)
    }
    
    private func addLongGuesture() {
        let long = UILongPressGestureRecognizer.init(target: self, action: #selector(didRecognizedLong(sender:)))
        imageView.addGestureRecognizer(long)
    }
    
    @objc func didRecognizedLong(sender: UILongPressGestureRecognizer) {
        if sender.state != .began {
            return;
        }
        LZAlterView.defaltManager().configure(withMainTitle: "温馨提示", subTitle: "是否保存该图片到相册？", actionTitleArray: ["确定"], cancelActionTitle: "取消").setupDelegate(self).showAlter()
    }
    
    @objc func didRecognizedDoubleTap(sender: UITapGestureRecognizer) {
        var newScale = scrollView.zoomScale
        if newScale == scrollView.minimumZoomScale {
            newScale = scrollView.maximumZoomScale / 2
        } else {
            newScale = scrollView.minimumZoomScale
        }
        let zoomRect = zoomRectScale(for: newScale, center: sender.location(in: sender.view))
        scrollView.zoom(to: zoomRect, animated: true)
    }

    private func zoomRectScale(for scale: CGFloat, center: CGPoint) -> CGRect {
        let size: CGSize = CGSize(width: scrollView.bounds.width / scale, height: scrollView.bounds.height / scale)
        let rect: CGRect = CGRect(x: center.x - (size.width / 2.0), y: center.y - (size.height / 2.0), width: size.width, height: size.height)
        return rect
    }
    
    @objc func didRecognizedPanTap(sender: UIPanGestureRecognizer) {
        let point = sender.translation(in: window)
        var scale = 1.0 - abs(point.y) / kSCREEN_HEIGHT
        
        switch sender.state {
        case .began: break
        case .changed:
            scale = max(scale, 0)
            let s = max(scale, 0.5)
            let translation = CGAffineTransform(translationX: point.x / s, y: point.y / s)
            let translationScale = CGAffineTransform(scaleX: s, y: s)
            imageView.transform = translation.concatenating(translationScale)
            if panChangeComplete != nil {
                panChangeComplete!(scale)
            }
        case .cancelled:
            imageView.transform = CGAffineTransform.identity
            if panChangeComplete != nil {
                panChangeComplete!(1)
            }
        case .failed:
            imageView.transform = CGAffineTransform.identity
            if panChangeComplete != nil {
                panChangeComplete!(1)
            }
            
        case .ended:
            UIView.animate(withDuration: 0.35, animations: {
                let transform1 = CGAffineTransform(translationX: 0, y: 0)
                self.imageView.transform = transform1.scaledBy(x: 1, y: 1)
            })
            
            if panChangeComplete != nil {
                panChangeComplete!(scale)
            }
            
            if scale < 0.7 {
                if singleTappedComplete != nil {
                    singleTappedComplete!()
                }
                
            } else {
                if panChangeComplete != nil {
                    panChangeComplete!(1)
                }
            }
        default: break
        }
    }
    
    @objc func didRecognizedSingleTap(sender: UITapGestureRecognizer) {
        scrollView.zoomScale = 1
        if singleTappedComplete != nil {
            singleTappedComplete!()
            scrollView.setContentOffset(.zero, animated: false)
        }
    }
    
    private func setImageView(with image: UIImage) {
        imageView.image = image
        let imageW: CGFloat = frame.width
        var rotaion: CGFloat = (image.size.width / (image.size.height > 0 ? image.size.height : imageW))
        if(rotaion <= 0.0){
            rotaion = 1.0
        }
        let imageH:CGFloat = imageW / rotaion
        var originY: CGFloat = 0.0
        if (imageH > contentView.frame.size.height) {
            originY = 0
        } else {
            originY = (contentView.frame.size.height - imageH) / 2.0
        }
        
        let imgViewRect = CGRect(x: 0, y: originY, width: kSCREEN_WIDTH, height: imageH)
        imageView.frame = imgViewRect
        scrollView.contentSize = CGSize(width: imageW, height: imageH)
        addLongGuesture()
        addTappedGuesture()
    }
}

extension WDPhotoBrowserCell: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        firstTouchPoint = touch.location(in: window)
        return true
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let touchPoint: CGPoint = gestureRecognizer.location(in: window)
        let dirTop: CGFloat = firstTouchPoint.y - touchPoint.y
        
        if (dirTop > -10 && dirTop < 10) {
            return false
        }
        let dirLift: CGFloat = firstTouchPoint.x - touchPoint.x
        if (dirLift > -10 && dirLift < 10 && imageView.frame.height > kSCREEN_HEIGHT) {
            return false
        }
        return true
    }
}

extension WDPhotoBrowserCell: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        
        let boundsSize: CGSize = bounds.size
        var frameToCenter: CGRect = imageView.frame
        
        if frameToCenter.width < boundsSize.width {
            frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2
        } else {
            frameToCenter.origin.x = 0
        }
        
        if frameToCenter.size.height < boundsSize.height {
            frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2
        } else {
            frameToCenter.origin.y = 0
        }
        imageView.frame = frameToCenter
    }
}

extension WDPhotoBrowserCell: LZAlterViewDelegate {
    func alterView(_ alterView: LZAlterView, didSelectedAt index: Int) {

        PhotoAlbumUtil.saveImageInAlbum(image: imageView.image!, albumName: "易社") { (result) in
            
            DispatchQueue.main.async {
                switch result{
                case .success:
                    print("保存成功")
                    LZRemindBar.configuration(with: .info, show: .statusBar, contentText: "保存成功").show(afterTimeInterval: 1.2)
                case .denied:
                    print("被拒绝")
                    LZRemindBar.configuration(with: .warn, show: .statusBar, contentText: "没有权限保存，请前往设置添加权限").show(afterTimeInterval: 1.2)
                case .error:
                    LZRemindBar.configuration(with: .error, show: .statusBar, contentText: "保存失败，请稍后重试").show(afterTimeInterval: 1.2)
                }
            }
        }
    }
}

enum PhotoAlbumUtilResult {
    case success, error, denied
}
//相册操作工具类
class PhotoAlbumUtil: NSObject {
    
    //判断是否授权
    class func isAuthorized() -> Bool {
        return PHPhotoLibrary.authorizationStatus() == .authorized ||
            PHPhotoLibrary.authorizationStatus() == .notDetermined
    }
    
    //保存图片到相册
    class func saveImageInAlbum(image: UIImage, albumName: String = "",
                                completion: ((_ result: PhotoAlbumUtilResult) -> ())?) {
        
        //权限验证
        if !isAuthorized() {
            completion?(.denied)
            return
        }
        var assetAlbum: PHAssetCollection?
        
        //如果指定的相册名称为空，则保存到相机胶卷。（否则保存到指定相册）
        if albumName.isEmpty {
            let list = PHAssetCollection
                .fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary,
                                       options: nil)
            assetAlbum = list[0]
        } else {
            //看保存的指定相册是否存在
            let list = PHAssetCollection
                .fetchAssetCollections(with: .album, subtype: .any, options: nil)
            list.enumerateObjects({ (album, index, stop) in
                let assetCollection = album
                if albumName == assetCollection.localizedTitle {
                    assetAlbum = assetCollection
                    stop.initialize(to: true)
                }
            })
            //不存在的话则创建该相册
            if assetAlbum == nil {
                PHPhotoLibrary.shared().performChanges({
                    PHAssetCollectionChangeRequest
                        .creationRequestForAssetCollection(withTitle: albumName)
                }, completionHandler: { (isSuccess, error) in
                    self.saveImageInAlbum(image: image, albumName: albumName,
                                          completion: completion)
                })
                return
            }
        }
        
        //保存图片
        PHPhotoLibrary.shared().performChanges({
            //添加的相机胶卷
            let result = PHAssetChangeRequest.creationRequestForAsset(from: image)
            //是否要添加到相簿
            if !albumName.isEmpty {
                let assetPlaceholder = result.placeholderForCreatedAsset
                let albumChangeRequset = PHAssetCollectionChangeRequest(for:
                    assetAlbum!)
                albumChangeRequset!.addAssets([assetPlaceholder!]  as NSArray)
            }
        }) { (isSuccess: Bool, error: Error?) in
            if isSuccess {
                completion?(.success)
            } else{
                print(error!.localizedDescription)
                completion?(.error)
            }
        }
    }
}

class WDPhotoBrowser: UIView {
    
    lazy var pageControl: UIPageControl = {
        let p = UIPageControl.init(frame: .zero)
        return p
    }()

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = kSCREEN_BOUNDS.size
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        let c = UICollectionView.init(frame: kSCREEN_BOUNDS, collectionViewLayout: layout)
        c.backgroundColor = .clear
        c.dataSource = self
        c.delegate = self
        c.isPagingEnabled = true
        c.showsHorizontalScrollIndicator = false
        c.showsVerticalScrollIndicator = false
        c.bounces = false
        if #available(iOS 11.0, *) {
            c.contentInsetAdjustmentBehavior = .never
        } else {

        }
        c.register(WDPhotoBrowserCell.classForCoder(), forCellWithReuseIdentifier: "WDPhotoBrowserCell")
        return c
    }()
    
    private var _originView: UIView?
    private var _imageUrls: [String]?
    private var _originImageRect: CGRect = .zero

    private var _tappedIndex = 0
    
    typealias ViewOfCurrentShowViewBlock = ((_ currentIndex: Int) -> UIView)
    private var viewOfCurrentShowViewBlock: ViewOfCurrentShowViewBlock?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(collectionView)
        addSubview(pageControl)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        pageControl.frame = CGRect(x: 0, y: kSCREEN_HEIGHT - 100, width: kSCREEN_WIDTH, height: 10)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(with originView: UIView, originImageRect: CGRect = .zero, imageUrls: [String], tappedIndex: Int) {
        _originView = originView
        _imageUrls = imageUrls
        _tappedIndex = tappedIndex
        _originImageRect = originImageRect
        if imageUrls.count > 1 {
            pageControl.numberOfPages = imageUrls.count
            pageControl.currentPage = tappedIndex
        }
        collectionView.reloadData()
    }
    
    func showBrowser(scrollBlock: @escaping ViewOfCurrentShowViewBlock) {
        viewOfCurrentShowViewBlock = scrollBlock
        UIApplication.shared.keyWindow?.addSubview(self)
        backgroundColor = UIColor(white: 0, alpha: 0)
        frame = kSCREEN_BOUNDS
        if _tappedIndex > 0 {
            collectionView.scrollToItem(at: IndexPath(item: _tappedIndex, section: 0), at: .left, animated: false)
            collectionView.layoutIfNeeded()
            let cell = collectionView.cellForItem(at: IndexPath(item: self._tappedIndex, section: 0)) as! WDPhotoBrowserCell
            let originFrame = self._originView?.convert(self._originView!.bounds, to: cell.contentView)
            cell.imageView.frame = originFrame!
            UIView.animate(withDuration: 0.35) {
                self.backgroundColor = UIColor(white: 0, alpha: 1)
                cell.imageView.frame = self._originImageRect
            }
        } else {
            collectionView.layoutIfNeeded()
            let cell = self.collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as! WDPhotoBrowserCell
            let originFrame = self._originView?.convert(self._originView!.bounds, to: cell.contentView)
            cell.imageView.frame = originFrame!
            UIView.animate(withDuration: 0.35) {
                self.backgroundColor = UIColor(white: 0, alpha: 1)
                cell.imageView.frame = self._originImageRect
            }
        }
    }
    
    func hidenBrowser(cell: WDPhotoBrowserCell) {
        let toRect: CGRect = (_originView?.convert(_originView!.bounds, to: window))!
        UIView.animate(withDuration: 0.35, animations: {
            cell.imageView.clipsToBounds = true
            cell.imageView.frame = toRect
            self.backgroundColor = UIColor(white: 0, alpha: 0)
        }) { (finished) in
            self.removeFromSuperview()
        }
    }
}

extension WDPhotoBrowser: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _imageUrls!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WDPhotoBrowserCell", for: indexPath) as! WDPhotoBrowserCell
        cell.setupView(with: _imageUrls![indexPath.item])
        cell.singleTappedComplete = {
            self.hidenBrowser(cell: cell)
        }
        cell.panChangeComplete = {
            self.backgroundColor = UIColor(white: 0, alpha: $0)
            self.pageControl.alpha = $0
        }
        return cell
    }
}

extension WDPhotoBrowser: UICollectionViewDelegate {
    
}

extension WDPhotoBrowser: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / kSCREEN_WIDTH)
        pageControl.currentPage = index
        if viewOfCurrentShowViewBlock != nil {
            _originView = viewOfCurrentShowViewBlock!(index)
        }
    }
}
