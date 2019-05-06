//
//  HomeContainerViewController.swift
//  YSBBS-Swift
//
//  Created by wudan on 2019/4/9.
//  Copyright © 2019 com.wudan. All rights reserved.
//

import UIKit
import SnapKit
import JXSegmentedView

class HomeContainerViewController: UIViewController {
    
    var segmentedDataSource: JXSegmentedTitleDataSource?
    let segmentedView = JXSegmentedView()
    
    private lazy var vcArray: [UIViewController] = {
        if UserDefaults.standard.bool(forKey: kIsLogin) {
            return [HomeViewController(), UserInfoViewController(), NotificationViewController()]
        } else {
            return [HomeViewController(), UserInfoViewController()]
        }
    }()
    
    let scrollView: UIScrollView = {
        let s = UIScrollView.init()
        s.isPagingEnabled = true
        s.bounces = false
        s.showsVerticalScrollIndicator = false
        s.showsHorizontalScrollIndicator = false
        return s
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .groupTableViewBackground
        
        extendedLayoutIncludesOpaqueBars = true
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
  
        segmentedView.frame = CGRect(x: 0, y: 0, width: view.bounds.size.width * 0.6, height: 44)
        segmentedView.delegate = self
        
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: segmentedView)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: kGetImage(imageName: "msg_edit").withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(postTopic(sender:)))
        navigationItem.rightBarButtonItem?.tintColor = .black
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(topLayoutGuide.snp.bottom)
            make.bottom.equalTo(bottomLayoutGuide.snp.top)
        }
        scrollView.layoutIfNeeded()
        segmentedView.contentScrollView = scrollView
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reSetViews),
                                               name: NSNotification.Name(rawValue: LoginSuccessNotification),
                                               object: nil)
        reSetViews()
    }
    
    func setupIsLogin() {
        scrollView.contentSize = CGSize(width: kSCREEN_WIDTH * 3, height: 0)
        segmentedDataSource = JXSegmentedTitleDataSource()
        segmentedDataSource?.isTitleColorGradientEnabled = true
        segmentedDataSource?.titleSelectedColor = .black
        segmentedDataSource?.titleNormalColor = .lightGray
        segmentedDataSource?.isTitleZoomEnabled = true
        segmentedDataSource?.titleSelectedZoomScale = 1.3
        segmentedDataSource?.titles = ["帖子", "个人信息", "通知"]
        segmentedDataSource?.reloadData(selectedIndex: 0)
        for (index, vc) in vcArray.enumerated() {
            addChild(vc)
            vc.didMove(toParent: self)
            vc.view.frame = CGRect(x: scrollView.frame.width * CGFloat(index), y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
            scrollView.addSubview(vc.view)
        }
        segmentedView.dataSource = segmentedDataSource
        segmentedView.reloadData()
    }
    
    func setupNOLogin() {
        scrollView.contentSize = CGSize(width: kSCREEN_WIDTH * 2, height: 0)
        segmentedDataSource = JXSegmentedTitleDataSource()
        segmentedDataSource?.titleSelectedColor = .black
        segmentedDataSource?.titleNormalColor = .lightGray
        segmentedDataSource?.isTitleZoomEnabled = true
        segmentedDataSource?.titleSelectedZoomScale = 1.3
        segmentedDataSource?.titles = ["帖子", "个人信息"]
        segmentedDataSource?.reloadData(selectedIndex: 0)
        for (index, vc) in vcArray.enumerated() {
            addChild(vc)
            vc.didMove(toParent: self)
            vc.view.frame = CGRect(x: scrollView.frame.width * CGFloat(index), y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
            scrollView.addSubview(vc.view)
        }
        segmentedView.dataSource = segmentedDataSource
        segmentedView.reloadData()
    }
}

// MARK: - @objc
@objc private extension HomeContainerViewController {
    func reSetViews() {
        if (UserDefaults.standard.bool(forKey: kIsLogin)) {
            setupIsLogin()
        } else {
            setupNOLogin()
        }
    }
    
    func postTopic(sender: Any) {
        if UserDefaults.standard.object(forKey: kIsLogin) == nil {
            self.showLoginController()
        } else {
            navigationController?.pushViewController(PostTopicViewController(), animated: true)
        }
    }
}

// MARK: - JXSegmentedViewDelegate
extension HomeContainerViewController: JXSegmentedViewDelegate {
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        if let dotDataSource = segmentedDataSource as? JXSegmentedDotDataSource {
            dotDataSource.dotStates[index] = false
            segmentedView.reloadItem(at: index)
        }
    }
}
