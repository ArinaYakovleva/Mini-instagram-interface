//
//  UserCell.swift
//  Course2FinalTask
//
//  Created by Арина Яковлева on 28.07.2021.
//  Copyright © 2021 e-Legion. All rights reserved.
//

import UIKit
import DataProvider
import DataProvider.Swift

class UserCell: UITableViewCell {
    @IBOutlet weak var avatarPhoto: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setUser(user: User, rowIndex: Int){
        avatarPhoto.image = user.avatar
        userName.text = user.username
        
    }
}
