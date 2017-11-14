//
//  Image.swift
//  TopPics500Px
//
//  Created by Ryan de Kwaadsteniet on 2017/11/14.
//  Copyright © 2017 Ryan de Kwaadsteniet. All rights reserved.
//

import UIKit

class Image: NSObject {
    var imageBanner: String?
    var title: String?
    
    var photographer: Photographer?
}

class  Photographer: NSObject {
    var name: String?
    var profileImage: String?
}
