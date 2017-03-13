//
//  NodeHeadImageView.swift
//  DGNode
//
//  Created by DSKcpp on 2017/3/9.
//  Copyright © 2017年 DSKcpp. All rights reserved.
//

import UIKit
import PureLayout

class NodeHeadImageView: UIView, UIScrollViewDelegate {

    let scrollView = DGScrollView()
    let imageContainerView = UIView()
    let imageView = UIImageView()
    let deleteHeadImageButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 200.0))
        
        backgroundColor = .white
        
        scrollView.delegate = self
        scrollView.maximumZoomScale = 3
        scrollView.minimumZoomScale = 1
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.scrollsToTop = false
        scrollView.bouncesZoom = true
        scrollView.alwaysBounceVertical = false
        scrollView.clipsToBounds = true
        scrollView.frame = self.frame
        addSubview(scrollView)
        
        imageContainerView.clipsToBounds = true
        scrollView.contentView.addSubview(imageContainerView)
        
        imageContainerView.addSubview(imageView)
        
        deleteHeadImageButton.setTitle("X", for: .normal)
        deleteHeadImageButton.setTitleColor(.black, for: .normal)
        deleteHeadImageButton.layer.borderColor = UIColor.black.cgColor
        deleteHeadImageButton.layer.borderWidth = 1.0
        deleteHeadImageButton.layer.cornerRadius = 5.0
        addSubview(deleteHeadImageButton)

        deleteHeadImageButton.autoSetDimensions(to: CGSize(width: 40, height: 40))
        deleteHeadImageButton.autoPinEdge(toSuperviewEdge: .right, withInset: 12)
        deleteHeadImageButton.autoPinEdge(toSuperviewEdge: .bottom, withInset: 12)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImage(_ image: UIImage?) {
        guard let image = image else { return }
        scrollView.setZoomScale(1.0, animated: false)
        scrollView.maximumZoomScale = 1
        imageView.image = image
        scrollView.maximumZoomScale = 3
        resize()
    }

    func resize() {
        imageContainerView.frame = bounds
        guard let image = imageView.image else { return }
        if (image.size.height / image.size.width > scrollView.frame.height / scrollView.frame.width) {
            imageContainerView.frame.size.height = floor(image.size.height / (image.size.width / scrollView.frame.width));
        } else {
            var height = image.size.height / image.size.width * scrollView.frame.width;
            if (height < 1 || height.isNaN) {
                height = scrollView.frame.height
            }
            imageContainerView.frame.size.height = floor(height)
            imageContainerView.center.y = scrollView.frame.height / 2
        }
        if (imageContainerView.frame.height > scrollView.frame.height && imageContainerView.frame.height - scrollView.frame.height <= 1) {
            imageContainerView.frame.size.height = scrollView.frame.height
        }
        let h = max(imageContainerView.frame.height, scrollView.frame.height)
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: h)
        scrollView.scrollRectToVisible(scrollView.bounds, animated: false)
        
        if (imageContainerView.frame.height <= scrollView.frame.height) {
            scrollView.alwaysBounceVertical = false
        } else {
            scrollView.alwaysBounceVertical = true
        }
        imageView.frame = imageContainerView.bounds
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageContainerView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let frame = scrollView.bounds
        let size = scrollView.contentSize
        let offsetX = (frame.width > size.width) ? (frame.width - size.width) * 0.5 : 0.0;
        let offsetY = (frame.height > size.height) ? (frame.height - size.height) * 0.5 : 0.0;
        imageContainerView.center = CGPoint(x: size.width * 0.5 + offsetX, y: size.height * 0.5 + offsetY);
    }
}
