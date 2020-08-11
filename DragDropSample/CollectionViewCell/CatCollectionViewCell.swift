//
//  CatCollectionViewCell.swift
//  DragDropSample
//
//  Created by Gaurav on 11/08/20.
//  Copyright © 2020 Gaurav. All rights reserved.
//

import UIKit

class CatCollectionViewCell: UICollectionViewCell{

    @IBOutlet weak var imageView: UIImageView!
    
    func configureCell(image: UIImage) {
        self.imageView.image = image
    }
    
}
