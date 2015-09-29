//
//  Meme.swift
//  MemeMe
//
//  Created by ANISHA AGARWAL on 9/28/15.
//  Copyright (c) 2015 Anisha Agarwal. All rights reserved.
//

import Foundation
import UIKit

class Meme: NSObject {
    
    var topText: String
    var bottomText: String
    var initialImage: UIImage
    
    // Meme Image
    var memeImage: UIImage
    
    init(topText: String, bottomText: String, initialImage: UIImage, memeImage: UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.initialImage = initialImage
        self.memeImage = memeImage
    }
}
