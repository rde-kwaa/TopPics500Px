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
    var height: [CGFloat] = []
    var width: [CGFloat] = []
    
    func getImages() {
        
        let consumerKey = "q89i18uOtcklwE2S1XqMjXY9Li4shDrVQzLTGUVq"
        let jsonUrlString = "https://api.500px.com/v1/photos?feature=popular&image_size=4&consumer_key=\(consumerKey)"
        let url = URL(string: jsonUrlString)
        
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            if error != nil {
                print("Error: \(String(describing: error))")
                let alertController = UIAlertController(title: (error?.localizedDescription), message: "", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: ("OK"), style: .default)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
                return
            }
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: Any]
                    var photos = json["photos"] as! [[String:Any]]
                    var index = 0
                    self.images = [Image]()
                    
                    while !(index==20) {
                        let image = Image()
                        let item = photos[index] as [String:Any]
                        image.title = item["name"] as? String
                        image.imageBanner = item["image_url"] as? String
                        
                        let imgHeight = item["height"] as! CGFloat
                        let imgWidth = item["width"] as! CGFloat
                        self.height.append(imgHeight)
                        self.width.append(imgWidth)
                        
                        let user = item["user"] as! [String:Any]
                        let photographer = Photographer()
                        photographer.name = user["fullname"] as? String
                        photographer.profileImage = user["userpic_https_url"] as? String
                        
                        image.photographer = photographer
                        
                        self.images?.append(image)
                        index += 1
                    }
                    
                    DispatchQueue.main.async(execute: {
                        self.collectionView?.reloadData()
                    })
                    
                } catch let jsonErr {
                    print("Attempt at serializing JSON caused an error: ", jsonErr)
                }
        }).resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getImages()
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        titleLabel.text = "Popular"
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        navigationItem.titleView = titleLabel
        
        navigationController?.navigationBar.isTranslucent = false
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(ImageCell.self, forCellWithReuseIdentifier: "cellID")
        
        setupNavBarButtons()
    }
    
    func setupNavBarButtons() {
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refresh))
        refreshButton.tintColor = UIColor.white
        navigationItem.rightBarButtonItems = [refreshButton]
    }
    
    @objc func refresh() {
        getImages()
        DispatchQueue.main.async(execute: {
            self.collectionView?.reloadData()
        })
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
        
        let cellIndex = indexPath.row
        let dynHeight = (view.frame.width - 32) / (width[cellIndex] / height[cellIndex])
        return CGSize(width: view.frame.width, height: dynHeight + 16 + 98)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
