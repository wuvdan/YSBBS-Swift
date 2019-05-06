//
//  PostTopic_Image_Cell.swift
//  YSBBS-Swift
//
//  Created by wudan on 2019/4/10.
//  Copyright © 2019 com.wudan. All rights reserved.
//

import UIKit
import HXPhotoPicker
import SnapKit

class PostTopic_Image_Cell: UITableViewCell {
    
    private lazy var manager: HXPhotoManager = {
        let m = HXPhotoManager.init(type: .photo)
        return m!
    }()
    
    private lazy var photoView: HXPhotoView = {
        let p = HXPhotoView.init(frame: CGRect(x: 15, y: 15, width: kSCREEN_WIDTH - 30, height: 100))
        p.delegate = self
        p.backgroundColor = .white
        return p
    }()
    
    public var getAllAssetListComplete:((_ allAssetList: [PHAsset]) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.addSubview(photoView)
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

extension PostTopic_Image_Cell: HXPhotoViewDelegate {
    func photoViewChangeComplete(_ photoView: HXPhotoView!, allAssetList: [PHAsset]!, photoAssets: [PHAsset]!, videoAssets: [PHAsset]!, original isOriginal: Bool) {
        if (getAllAssetListComplete != nil) {
            getAllAssetListComplete!(allAssetList)
        }
    }
}
