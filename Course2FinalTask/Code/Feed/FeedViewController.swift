//
//  FeedViewController.swift
//  Course2FinalTask
//
//  Created by Арина Яковлева on 26.07.2021.
//  Copyright © 2021 e-Legion. All rights reserved.
//

import UIKit
import DataProvider
import DataProvider.Swift

class FeedViewController: UITableViewController {

    @IBOutlet var feedTableView: UITableView!
    var posts: [DataProvider.Post] = []
    var cell = UITableViewCell()
    var likersPostID:Post.Identifier?
    var userID: User.Identifier?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedTableView.allowsSelection = false
        feedTableView.separatorStyle = .none
        posts = DataProviders.shared.postsDataProvider.feed()
        feedTableView.register(UINib(nibName: String(describing: PostViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: PostViewCell.self))
        
        feedTableView.delegate = self
        feedTableView.dataSource = self
        
    }


    override func numberOfSections(in tableView: UITableView) -> Int {

        return posts.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let postCell = feedTableView.dequeueReusableCell(withIdentifier: String(describing: PostViewCell.self)) as! PostViewCell
        postCell.setPost(post: posts[indexPath.row],feedController: self, rowIndex: indexPath.row)


        return postCell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let target = segue.destination as? UsersListController, let id = likersPostID{
            target.navigationTitle = "Likes"
            target.usersIds = DataProviders.shared.postsDataProvider.usersLikedPost(with: id)
        } else if let target = segue.destination as? ProfileController, let id = userID{
            target.navigationTitle = DataProviders.shared.usersDataProvider.user(with: id)!.username
                target.userData = DataProviders.shared.usersDataProvider.user(with: id)
                target.userId = id
        }
    }
    
    public func updatePostInfo(rowIndex: Int, updatedPost: DataProvider.Post){
        posts[rowIndex] = updatedPost
    }
    
    func showProfile(userId: User.Identifier?){
        guard let id = userId else{ return }
        userID = id
        performSegue(withIdentifier: "toProfile", sender: self)
    }
    
    func showLikers(postID: Post.Identifier?){
        guard let id = postID  else{ return }
        likersPostID = id

        performSegue(withIdentifier: "toUsersList", sender: self)
    
    }
    
}
