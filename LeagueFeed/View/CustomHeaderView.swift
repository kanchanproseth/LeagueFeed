//
//  CustomHeaderView.swift
//  LeagueFeed
//
//  Created by kanchanproseth on 11/13/17.
//  Copyright © 2017 kanchanproseth. All rights reserved.
//

import UIKit

class CustomHeaderView: UIView {
    
    func update(withScrollPhasePercentage scrollPhasePercentage: CGFloat) {
        // 1
        let imageAlpha = min(scrollPhasePercentage.scaled(from: 0...0.8, to: 0...1), 1.0)
        imageView.alpha = imageAlpha
        
        // 2
        let fontSize = scrollPhasePercentage.scaled(from: 0...1, to: 22.0...60.0)
        let font = UIFont(name: "CourierNewPS-BoldMT", size: fontSize)
        titleLabel.font = font
    }
    
    
    let imageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "Dark_Hex_Grid"))//#imageLiteral(resourceName: "Dark_Hex_Grid")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("LeagueFeed", comment: "")
        label.textAlignment = .center
        label.textColor = .white
        label.shadowOffset = CGSize(width: 1, height: 1)
        label.shadowColor = .darkGray
        return label
    }()
    
    struct Constants {
        static let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height
        static let tabBarHeight: CGFloat = 48.0
        static let minHeight: CGFloat = 44 + statusBarHeight + tabBarHeight
        static let maxHeight: CGFloat = 300.0
    }
    
    // MARK: Init
    
    // 1
    init() {
        super.init(frame: .zero)
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        clipsToBounds = true
        configureView()
    }
    
    // 2
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View
    
    // 3
    func configureView() {
        backgroundColor = .darkGray
        addSubview(imageView)
        addSubview(titleLabel)
    }
    
    // 4
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
        titleLabel.frame = CGRect(
            x: 0,
            y: Constants.statusBarHeight,
            width: frame.width,
            height: frame.height - Constants.statusBarHeight - Constants.tabBarHeight)
    }
    
}

// MARK: Number Utilities - Based on code from https://github.com/raizlabs/swiftilities
extension FloatingPoint {
    
    public func scaled(from source: ClosedRange<Self>, to destination: ClosedRange<Self>, clamped: Bool = false, reversed: Bool = false) -> Self {
        let destinationStart = reversed ? destination.upperBound : destination.lowerBound
        let destinationEnd = reversed ? destination.lowerBound : destination.upperBound
        
        // these are broken up to speed up compile time
        let selfMinusLower = self - source.lowerBound
        let sourceUpperMinusLower = source.upperBound - source.lowerBound
        let destinationUpperMinusLower = destinationEnd - destinationStart
        var result = (selfMinusLower / sourceUpperMinusLower) * destinationUpperMinusLower + destinationStart
        if clamped {
            result = result.clamped(to: destination)
        }
        return result
    }
    
}

public extension Comparable {
    
    func clamped(to range: ClosedRange<Self>) -> Self {
        return clamped(min: range.lowerBound, max: range.upperBound)
    }
    
    func clamped(min lower: Self, max upper: Self) -> Self {
        return min(max(self, lower), upper)
    }
    
}
