//
//  ViewController.swift
//  Top500Px
//
//  Created by Ryan de Kwaadsteniet on 2017/11/13.
//  Copyright © 2017 Ryan de Kwaadsteniet. All rights reserved.
//

import UIKit

class TopImagesController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // instantiate object array and CGFloat array (dimensions of pictures)
    var images: [Image]?
    var height: [CGFloat] = []
    var width: [CGFloat] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // call the method to fetch popular images
        getImages()
        
        // setup navigation title
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        titleLabel.text = "Popular"
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        navigationItem.titleView = titleLabel
        navigationController?.navigationBar.isTranslucent = false
        
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(ImageCell.self, forCellWithReuseIdentifier: "cellID")
        
        // add navigation refresh button on the right
        setupNavBarButtons()
    }
    
    @objc func getImages() {
        
        // consumer key is appended onto the query link
        let consumerKey = "q89i18uOtcklwE2S1XqMjXY9Li4shDrVQzLTGUVq"
        let jsonUrlString = "https://api.500px.com/v1/photos?feature=popular&image_size=4&consumer_key=\(consumerKey)"
        
        // pass the interpolated string into type URL
        let url = URL(string: jsonUrlString)
        
        // create a url session, 3 params are completed when service returns from json request
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            // error handling, ussually a network connectivity error
            if error != nil {
                print("Error: \(String(describing: error))")
                let alertController = UIAlertController(title: (error?.localizedDescription), message: "", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: ("OK"), style: .default)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
                return
            }
            
            do {
                // using UIKit's json parser
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: Any]
                // downcast array of objects from json (dictionary)
                var photos = json["photos"] as! [[String:Any]]
                var index = 0
                // initialise object array
                self.images = [Image]()
                
                // only returns top 20 most popular therfore loop 20 times
                while !(index==20) {
                    //simple json navigation and reading into object class
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
                
                // get back onto main UI thread and and update UI based on a successful image request
                DispatchQueue.main.async(execute: {
                    self.collectionView?.reloadData()
                })
                
                // catches an error if there is a problem with json serialisation
            } catch let jsonErr {
                print("Attempt at serializing JSON caused an error: ", jsonErr)
            }
        }).resume()
    }
    
    // setup refresh button in navigation bar
    func setupNavBarButtons() {
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(getImages))
        refreshButton.tintColor = UIColor.white
        navigationItem.rightBarButtonItems = [refreshButton]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // count elements in object array to return the number of items in collection view
        return images?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // dynamically populate collection view according to data read through ImageCell class
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath) as! ImageCell
        // cell at row of indexPath equals to the object in the object array with the ordinal equivalent
        cell.image = images?[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // aspect ratio calculation to satisfy constraints
        let cellIndex = indexPath.row
        let dynHeight = (view.frame.width - 32) / (width[cellIndex] / height[cellIndex])
        return CGSize(width: view.frame.width, height: dynHeight + 16 + 98)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
