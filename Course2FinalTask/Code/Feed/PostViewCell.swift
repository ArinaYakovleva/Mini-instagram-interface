//
//  PostViewCell.swift
//  Course2FinalTask
//
//  Created by Арина Яковлева on 26.07.2021.
//  Copyright © 2021 e-Legion. All rights reserved.
//

import UIKit
import DataProvider
import DataProvider.Swift

class PostViewCell: UITableViewCell {

    @IBOutlet weak var avatarPhoto: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var postDate: UILabel!
    @IBOutlet weak var postPhoto: UIImageView!
    @IBOutlet weak var likesCount: UIButton!
    @IBOutlet weak var postDescription: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    
    var feedViewController: FeedViewController!
    var post: DataProvider.Post? = nil
    var rowIndex: Int = -1
    var postID: Post.Identifier? = nil
    var dateFormatter = DateFormatter()
    var usersLikedPost:[DataProvider.User.Identifier]? = []
    private var bigLikeView: UIImageView? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func onLikePress(_ sender: Any) {
        likePost()
    }
    @IBAction func toLIkers(_ sender: Any) {
        toLikers()
    }
    
    func likePost(){
        guard var post = post else{ return }
        onToggleLike()
        
        post = DataProviders.shared.postsDataProvider.post(with: post.id)!
        
        likesCount.setTitle("Likes: \(post.likedByCount)", for: .normal)
        
        likeButton.tintColor = isPostLiked(postID: post.id) ? .blue : .lightGray
        if let feedController = feedViewController{
            feedController.updatePostInfo(rowIndex: rowIndex, updatedPost: post)
        }
    }
    
    func onToggleLike(){
        guard let post = post else{ return }
        if isPostLiked(postID: post.id){
            _ = DataProviders.shared.postsDataProvider.unlikePost(with: post.id)
            
        }else{
            _ = DataProviders.shared.postsDataProvider.likePost(with: post.id)
           
        }
    }
    

    
    func toLikers(){
        if  let controller = feedViewController, let id = post?.id{
            controller.showLikers(postID: id)
        }
    }
    
    func isPostLiked(postID: DataProvider.Post.Identifier) -> Bool{
        if let likers = DataProviders.shared.postsDataProvider.usersLikedPost(with: postID){
            let userID = DataProviders.shared.usersDataProvider.currentUser().id
            return likers.contains(userID)
        }else{
            return false
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
  
        if let touch = touches.first, let controller = self.feedViewController{
            if touch.view == avatarPhoto || touch.view == userName, let id = post?.author{

                controller.showProfile(userId: id)
            }
        }
    }
    
    func setPost(post: DataProvider.Post,feedController: FeedViewController, rowIndex: Int){
        self.feedViewController = feedController
        self.post = post
        self.postID = post.id
        self.rowIndex = rowIndex
        avatarPhoto.image = post.authorAvatar
        userName.text = post.authorUsername
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.doesRelativeDateFormatting = true
        likeButton.tintColor = isPostLiked(postID: post.id) ? .blue : .gray
        postDate.text = dateFormatter.string(from: post.createdTime)
        postPhoto.image = post.image
        likesCount.setTitle("Likes \(post.likedByCount)", for: .normal)
        
        postDescription.text = post.description
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(bigLike))
        tap.numberOfTapsRequired = 2
        postPhoto.isUserInteractionEnabled = true
        postPhoto.addGestureRecognizer(tap)
        
        avatarPhoto.isUserInteractionEnabled = true
        userName.isUserInteractionEnabled = true
    }
    
     func performAnimation(likeView: UIImageView){
        let startEndAlpha: Float = 0.0
        let anim = CAKeyframeAnimation(keyPath: #keyPath(CALayer.opacity))
        anim.delegate = self as? CAAnimationDelegate
        anim.values = [startEndAlpha, 1.0, 1.0, startEndAlpha]
        anim.keyTimes = [0.0, 0.17, 0.5, 1.0]
        anim.duration = 0.6 // 0.6 second
        anim.timingFunctions = [CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)]
        likeView.layer.opacity = startEndAlpha
        likeView.layer.add(anim, forKey: "alpha")
        likeView.layer.opacity = startEndAlpha
    }
    
    
    
    @objc func bigLike(sender: UITapGestureRecognizer){
        if sender.state == .ended{
            if bigLikeView == nil{
                let image = UIImage(named: "bigLike")
                bigLikeView = UIImageView(image: image)

            }
            if let likeView = bigLikeView, let mainImage = postPhoto {
                likeView.layer.opacity = 1.0
                contentView.addSubview(likeView)
                likeView.center = mainImage.center
                let animation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
                animation.duration = 1.0
                animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)

                let toValue = 0
                animation.fromValue = likeView.layer.opacity
                animation.toValue = Float(toValue)

                likeView.layer.add(animation, forKey: "bigLikeAnimation")
                likeView.layer.opacity = Float(toValue)
  
            }
        }
        if let postId = post?.id{
            if !isPostLiked(postID: postId){
                likePost()
            }

        }
    }

}
