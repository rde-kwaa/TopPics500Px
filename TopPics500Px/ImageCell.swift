//
//  ImageCell.swift
//  TopPics500Px
//
//  Created by Ryan de Kwaadsteniet on 2017/11/14.
//  Copyright © 2017 Ryan de Kwaadsteniet. All rights reserved.
//

import UIKit

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("initialiser not implemented")
    }
}

class ImageCell: BaseCell {

    var image: Image? {
        didSet {
            titleLabel.text = image?.title
            
            setupBannerImage()
            
            setupProfileImage()
            
            if let photographerName = image?.photographer?.name {
                let subtitleText = "\(photographerName)"
                authorTextView.text = subtitleText
            }
            
            //measure title text
            if let title = image?.title {
                let size = CGSize(width: frame.width - 16 - 44 - 8 - 16, height: 1000)
                let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
                let estimatedRect = NSString(string: title).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)], context: nil)
                
                if estimatedRect.size.height > 20 {
                    titleLabelHeightConstraint?.constant = 44
                } else {
                    titleLabelHeightConstraint?.constant = 20
                }
            }
        }
    }
    
    func setupProfileImage() {
        if let profileImageUrl = image?.photographer?.profileImage {
            userImageView.loadImageUsingUrlString(profileImageUrl)
        }
    }
    
    func setupBannerImage() {
        if let imageUrl = image?.imageBanner {
            bannerImageView.loadImageUsingUrlString(imageUrl)
        }
    }
    
    
    let bannerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "stockImage")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "stockPhotographer")
        imageView.layer.cornerRadius = 22
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        //label.text = "Sunrise in Bavaria"
        label.numberOfLines = 2
        return label
    }()
    
    let authorTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        //textView.text =  "Daniel F."
        textView.textContainerInset = UIEdgeInsetsMake(0, -4, 0, 0)
        textView.textColor = UIColor.lightGray
        textView.isEditable = false
        return textView
    }()
    
    var titleLabelHeightConstraint: NSLayoutConstraint?
    
    override func setupViews() {
        addSubview(bannerImageView)
        addSubview(separatorView)
        addSubview(userImageView)
        addSubview(titleLabel)
        addSubview(authorTextView)
        
        //horizontal contsraints
        addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: bannerImageView)
        addConstraintsWithFormat(format: "H:|-16-[v0(44)]|", views: userImageView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: separatorView)
        //vertical constraints
        addConstraintsWithFormat(format: "V:|-16-[v0]-8-[v1(44)]-36-[v2(1)]|", views: bannerImageView, userImageView, separatorView)
        
        // title top constraint
        addConstraints([NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: bannerImageView, attribute: .bottom, multiplier: 1, constant: 4)])
        // title left constraint
        addConstraints([NSLayoutConstraint(item: titleLabel, attribute: .left, relatedBy: .equal, toItem: userImageView, attribute: .right, multiplier: 1, constant: 8)])
        // title right constraint
        addConstraints([NSLayoutConstraint(item: titleLabel, attribute: .right, relatedBy: .equal, toItem: bannerImageView, attribute: .right, multiplier: 1, constant: 0)])
        // title height constraint
        addConstraints([NSLayoutConstraint(item: titleLabel, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 44)])
        
        // photographer top constraint
        addConstraints([NSLayoutConstraint(item: authorTextView, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 4)])
        // photographer left constraint
        addConstraints([NSLayoutConstraint(item: authorTextView, attribute: .left, relatedBy: .equal, toItem: userImageView, attribute: .right, multiplier: 1, constant: 8)])
        // photographer right constraint
        addConstraints([NSLayoutConstraint(item: authorTextView, attribute: .right, relatedBy: .equal, toItem: bannerImageView, attribute: .right, multiplier: 1, constant: 0)])
        // photographer height constraint
        addConstraints([NSLayoutConstraint(item: authorTextView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 30)])
    }
    
}
