//
//  ArticleCell.swift
//  LeagueFeed
//
//  Created by kanchanproseth on 11/13/17.
//  Copyright © 2017 kanchanproseth. All rights reserved.
//

import UIKit
import SDWebImage
import MaterialComponents

class ArticleCell: UICollectionViewCell {
    
    static let cellID = "ArticleCellID"
    static let cellHeight: CGFloat = 370.0
    static let cellPadding: CGFloat = 8.0
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    var inkTouchController: MDCInkTouchController?
    
    override class var layerClass: AnyClass {
        return MDCShadowLayer.self
    }
    
    var shadowLayer: MDCShadowLayer? {
        return self.layer as? MDCShadowLayer
    }
    
    var article: Article? {
        didSet {
            guard let article = article else {
                return
            }

            imageView.sd_setImage(with: article.imageURL)
            titleLabel.text = article.title
            subtitleLabel.text = article.description
            if let date = article.publishedAt {
                dateLabel.isHidden = false
                dateLabel.text = Formatters.shortDateFormatter.string(from: date)
            } else {
                dateLabel.isHidden = true
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        inkTouchController = MDCInkTouchController(view: self)
        inkTouchController?.addInkView()
        
        // 1
        shadowLayer?.elevation = ShadowElevation.cardResting//MDCShadowElevationCardResting
        
        // 2
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        
        // 3
        clipsToBounds = false
        imageView.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.sd_cancelCurrentImageLoad()
        titleLabel.text = nil
        subtitleLabel.text = nil
        dateLabel.text = nil
    }
    
}
