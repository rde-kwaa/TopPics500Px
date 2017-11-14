//
//  ViewController.swift
//  Top500Px
//
//  Created by Ryan de Kwaadsteniet on 2017/11/13.
//  Copyright © 2017 Ryan de Kwaadsteniet. All rights reserved.
//

import UIKit

class TopImagesController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var images: [Image]?
    
    func getImages() {
        
        let consumerKey = "q89i18uOtcklwE2S1XqMjXY9Li4shDrVQzLTGUVq"
        let jsonUrlString = "https://api.500px.com/v1/photos?feature=popular&consumer_key=\(consumerKey)"
        let url = URL(string: jsonUrlString)
        
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            if error != nil {
                print("Error: \(String(describing: error))")
                return
            }
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: Any]
                    let photos = json["photos"] as! [[String:Any]]
                    let item = photos[0] as [String:Any]
                    let imageUrl = item["image_url"]
                    let title = item["name"]
                    let user = item["user"] as! [String:Any]
                    let fullname = user["fullname"]
                    let userPicUrl = user["userpic_https_url"]
                    print(imageUrl as Any)
                    print(title as Any)
                    print(fullname as Any)
                    print(userPicUrl as Any)
                    
                    self.images = [Image]()
                    
                    //for dictionary in json {
                    
                        let image = Image()
                        //image.title = dictionary["name"] as? String
                        //image.imageBanner = dictionary["image_url"] as? String
                        
                        //let channelDictionary = dictionary["channel"] as! [String: AnyObject]
                        
                        //let photographer = Photographer()
                        //photographer.name = channelDictionary["fullname"] as? String
                        //photographer.profileImage = channelDictionary["userpic_https_url"] as? String
                        
                        //image.photographer = photographer
                        
                        //self.images?.append(image)
                    //}
                    
                    self.collectionView?.reloadData()
                    
                } catch let jsonErr {
                    print("Attempt at serializing JSON caused an error: ", jsonErr)
                    return
                }
        }).resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getImages()
        
        navigationItem.title = "Popular"
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(ImageCell.self, forCellWithReuseIdentifier: "cellID")
        collectionView?.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath) as! ImageCell
        
        cell.image = images?[indexPath.item]
        
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
