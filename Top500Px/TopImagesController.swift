//
//  ViewController.swift
//  Top500Px
//
//  Created by Ryan de Kwaadsteniet on 2017/11/13.
//  Copyright © 2017 Ryan de Kwaadsteniet. All rights reserved.
//

import UIKit

struct topPics {
    let imageURL: String
    let title: String
    let photographer: String
    let profile: String
}

class TopImagesController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var images: [Image] = {
        var userDaniel = Photographer()
        userDaniel.name = "Daniel F."
        userDaniel.profileImage = "photographerDaniel"
        
        var himImage = Image()
        himImage.title = "Sunrise in Bavaria"
        himImage.imageBanner = "topImage"
        return [himImage]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let consumerKey = "q89i18uOtcklwE2S1XqMjXY9Li4shDrVQzLTGUVq"
//        let jsonUrlString = "https://api.500px.com/v1/photos?feature=popular&consumer_key=\(consumerKey)"
//        let url = URL(string: jsonUrlString)
//
//        URLSession.shared.dataTask(with: url!) { (data, response, err) in
//
//            guard let data = data else { return }
//
//            do {
//                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
//                print(json)
//            } catch let jsonErr {
//                print("Attempt at serializing JSON caused an error: ", jsonErr)
//            }
//        }.resume()
        
        navigationItem.title = "Popular"
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(ImageCell.self, forCellWithReuseIdentifier: "cellID")
        collectionView?.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath)
        
        // cell.video = videos[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = (view.frame.width - 16 - 16) * 9 / 16
        return CGSize(width: view.frame.width, height: height + 16 + 88)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
