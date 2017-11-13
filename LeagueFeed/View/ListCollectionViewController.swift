//
//  ViewController.swift
//  LeagueFeed
//
//  Created by kanchanproseth on 11/13/17.
//  Copyright © 2017 kanchanproseth. All rights reserved.
//

import UIKit
import SafariServices
import MaterialComponents

class ListCollectionViewController: UICollectionViewController {
    
    let tabBar = MDCTabBar()
    let appBar = MDCAppBar()
    let customHeaderView = CustomHeaderView()
    var inProgressTask: Cancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        refreshContent()
        configureAppBar()
        configureTabBar()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

// MARK: UI Configuration
extension ListCollectionViewController {
    
    func configureTabBar() {
        // 1
        tabBar.itemAppearance = .titles
        // 2
        tabBar.items = TabSource.allValues.enumerated().map { index, source in
            return UITabBarItem(title: source.title, image: nil, tag: index)
        }
        // 3
        tabBar.selectedItem = tabBar.items[0]
        // 4
        tabBar.delegate = self
        // 5
        appBar.headerStackView.bottomBar = tabBar
    }
    
    func configureAppBar() {
        
        appBar.headerViewController.layoutDelegate = self
        
        // 1
        self.addChildViewController(appBar.headerViewController)
        
        // 2
        appBar.navigationBar.backgroundColor = .clear
        appBar.navigationBar.title = nil
        
        // 3
        let headerView = appBar.headerViewController.headerView
        headerView.backgroundColor = .clear
        headerView.maximumHeight = CustomHeaderView.Constants.maxHeight
        headerView.minimumHeight = CustomHeaderView.Constants.minHeight
        
        // 4
        customHeaderView.frame = headerView.bounds
        headerView.insertSubview(customHeaderView, at: 0)
        
        // 5
        headerView.trackingScrollView = self.collectionView
        
        // 6
        appBar.addSubviewsToParent()
    }
    
    
    // MARK: UIScrollViewDelegate
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let headerView = appBar.headerViewController.headerView
        if scrollView == headerView.trackingScrollView {
            headerView.trackingScrollDidScroll()
        }
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let headerView = appBar.headerViewController.headerView
        if scrollView == headerView.trackingScrollView {
            headerView.trackingScrollDidEndDecelerating()
        }
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let headerView = appBar.headerViewController.headerView
        if scrollView == headerView.trackingScrollView {
            headerView.trackingScrollDidEndDraggingWillDecelerate(decelerate)
        }
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint,
                                            targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let headerView = appBar.headerViewController.headerView
        if scrollView == headerView.trackingScrollView {
            headerView.trackingScrollWillEndDragging(withVelocity: velocity,
                                                     targetContentOffset: targetContentOffset)
        }
    }
    
    
    func configureCollectionView() {
        let cellNib = UINib(nibName: "ChampCell", bundle: nil)
        collectionView?.register(cellNib, forCellWithReuseIdentifier: ChampCell.cellID)
        collectionView?.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
    }
    
}

// MARK: UICollectionViewDelegateFlowLayout
extension ListCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width - (ChampCell.cellPadding * 2), height: ChampCell.cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: ChampCell.cellPadding, left: ChampCell.cellPadding, bottom: ChampCell.cellPadding, right: ChampCell.cellPadding)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return ChampCell.cellPadding
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
}

// MARK: UICollectionViewDataSource and Delegate
extension ListCollectionViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100//articles.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChampCell.cellID, for: indexPath) as? ChampCell {
//            cell.article = articles[indexPath.row]
            return cell
        } else {
            fatalError("Missing cell for indexPath: \(indexPath)")
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let article = articles[indexPath.row]
//
//        guard let url = article.articleURL else {
//            return
//        }
//
//        let config = SFSafariViewController.Configuration()
//        config.entersReaderIfAvailable = true
//        let safariVC = SFSafariViewController(url: url, configuration: config)
//        self.present(safariVC, animated: true, completion: nil)
    }
    
}

// MARK: Data
extension ListCollectionViewController {
    
    func refreshContent() {
        guard inProgressTask == nil else {
            inProgressTask?.cancel()
            inProgressTask = nil
            return
        }
        
        guard let selectedItem = tabBar.selectedItem else {
            return
        }
        // calling api by select item of tabbar
//        let source = NewsSource.allValues[selectedItem.tag]
        
//        inProgressTask = apiClient.articles(forSource: source) { [weak self] (articles, error) in
//            self?.inProgressTask = nil
//            if let articles = articles {
//                self?.articles = articles
                collectionView?.reloadData()
//            } else {
//                self?.showError()
//            }
//        }
    }
    
    func showError() {
        
    }
    
}


extension ListCollectionViewController: MDCFlexibleHeaderViewLayoutDelegate {
    
    public func flexibleHeaderViewController(_ flexibleHeaderViewController: MDCFlexibleHeaderViewController,
                                             flexibleHeaderViewFrameDidChange flexibleHeaderView: MDCFlexibleHeaderView) {
        customHeaderView.update(withScrollPhasePercentage: flexibleHeaderView.scrollPhasePercentage)
    }
}

// MARK: MDCTabBarDelegate
extension ListCollectionViewController: MDCTabBarDelegate {
    
    func tabBar(_ tabBar: MDCTabBar, didSelect item: UITabBarItem) {
        refreshContent()
    }
}
