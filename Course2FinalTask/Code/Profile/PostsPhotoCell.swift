//
//  PostsPhotoCell.swift
//  Course2FinalTask
//
//  Created by Арина Яковлева on 03.08.2021.
//  Copyright © 2021 e-Legion. All rights reserved.
//

import UIKit

class PostsPhotoCell: UICollectionViewCell {
    @IBOutlet weak var photoView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        photoView.contentMode = .scaleAspectFill

    }
    
    func setImage(image: UIImage){
        photoView.image = image
//        setNeedsLayout()
    }

}
