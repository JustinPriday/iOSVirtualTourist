//
//  LocationImageCell.swift
//  VirtualTourist
//
//  Created by Justin Priday on 2017/11/29.
//  Copyright © 2017 Justin Priday. All rights reserved.
//

import UIKit

class LocationImageCell: UICollectionViewCell {
    @IBOutlet weak var locationImage: UIImageView!
    @IBOutlet weak var cellBG: UIImageView!
    @IBOutlet weak var loadingActivity: UIActivityIndicatorView!
    
    override var isSelected: Bool {
        didSet {
            locationImage.alpha = ((isSelected) ? 0.5 : 1.0)
        }
    }
    
}
