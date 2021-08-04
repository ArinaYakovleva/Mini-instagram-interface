//
//  ProfileInfo.swift
//  Course2FinalTask
//
//  Created by Арина Яковлева on 30.07.2021.
//  Copyright © 2021 e-Legion. All rights reserved.
//

import UIKit
import DataProvider
import DataProvider.Swift

class ProfileInfo: UICollectionReusableView {
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var followers: UILabel!
    @IBOutlet weak var followings: UILabel!
    
    var profileController: ProfileController? = nil
    var userID: User.Identifier? = nil
    
    static let reuseId = "SectionHeader"
    
    func configureHeader(userData: User?, controller: ProfileController){
        self.profileController = controller
        if let user = userData{
            self.userID = userData?.id
            avatar.image = user.avatar
            fullName.text = user.fullName
            followers.text = "Followers: \(user.followedByCount)"
            followings.text = "Followings: \(user.followsCount)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        followers.isUserInteractionEnabled = true
        followings.isUserInteractionEnabled = true
//        self.heightAnchor.constraint(equalToConstant: CGFloat(10))

    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, let controller = profileController{
            if touch.view == followers{
                controller.showUsers(isFollowers: true)
            }else{
                controller.showUsers(isFollowers: false)
            }

        }
    }
}
