//
//  ProfileController.swift
//  Course2FinalTask
//
//  Created by Арина Яковлева on 30.07.2021.
//  Copyright © 2021 e-Legion. All rights reserved.
//

import UIKit
import DataProvider
import DataProvider.Swift

private let reuseIdentifier = "Cell"
private let headerIdentifier = "Header"

class ProfileController: UICollectionViewController{
    
    var userData: User? = nil
    var userId: User.Identifier? = nil
    var userImages: [UIImage] = []
    var photoImage:UIImage!
    var followsId: User.Identifier? = nil
    var isFollowersRequired = true
    var navigationTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = navigationTitle
        
        if let id = userData?.id,let posts = DataProviders.shared.postsDataProvider.findPosts(by: id){
            posts.forEach { (post) in
                userImages.append(post.image)
            }
            
        }else{
            navigationItem.title = DataProviders.shared.usersDataProvider.currentUser().username
           let currentUserId = DataProviders.shared.usersDataProvider.currentUser().id
            if let posts = DataProviders.shared.postsDataProvider.findPosts(by: currentUserId){
                posts.forEach{(post) in
                    userImages.append(post.image)
                }
            }
        }
        
        collectionView!.register(UINib(nibName: String(describing: ProfileInfo.self), bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        collectionView!.register(UINib(nibName: String(describing: PostsPhotoCell.self), bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)

    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerIdentifier, for: indexPath) as! ProfileInfo
        if let data = userData{
            
            header.configureHeader(userData: data, controller: self)
        } else{
            header.configureHeader(userData: DataProviders.shared.usersDataProvider.currentUser(),  controller: self)
        }

   
        return header
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return userImages.count
        
   
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
            as! PostsPhotoCell
        
            if let _ = userId{
                photoImage = userImages[indexPath.row]
            }else{
                photoImage = userImages[indexPath.row]
            }
        
            cell.setImage(image: photoImage)

            return cell
       

    }
    
    func showUsers(isFollowers: Bool){
        isFollowersRequired = isFollowers
        performSegue(withIdentifier: "toUsersList", sender: self)
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let target  = segue.destination as? UsersListController{
            let user = DataProviders.shared.usersDataProvider

            if isFollowersRequired{
                target.navigationTitle = "Followers"
                if let id = userId{
                    target.users = user.usersFollowingUser(with: id)
                }else{
                    target.users = user.usersFollowingUser(with: user.currentUser().id)
                }
             

            }else{
                target.navigationTitle = "Followings"
                if let id = userId{
                    target.users = user.usersFollowedByUser(with: id)
                }else{
                    target.users = user.usersFollowedByUser(with: user.currentUser().id)
                }
                
            }

            
        }
    }
}
extension ProfileController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width , height: 86)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width / 3
        return CGSize(width: width, height: width)
    }
    
}
