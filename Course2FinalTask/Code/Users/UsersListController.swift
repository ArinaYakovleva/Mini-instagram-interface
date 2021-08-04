//
//  UsersListController.swift
//  Course2FinalTask
//
//  Created by Арина Яковлева on 28.07.2021.
//  Copyright © 2021 e-Legion. All rights reserved.
//

import UIKit
import DataProvider
import DataProvider.Swift

class UsersListController: UITableViewController {
    
    var usersIds: [User.Identifier]? = nil
    var users: [User]? = nil
    var selectedRow = -1
    var navigationTitle = ""
    
    @IBOutlet var usersTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        navigationItem.title = navigationTitle
        if users == nil, let ids = usersIds{
            users = []
            ids.forEach({ (id) in
                if let user = DataProviders.shared.usersDataProvider.user(with: id){
                    users?.append(user)
                }
            })
        }
        
        usersTable.register(UINib(nibName: String(describing: UserCell.self), bundle: nil), forCellReuseIdentifier: String(describing: UserCell.self))
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        performSegue(withIdentifier: "toProfile", sender: nil)
    }



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users?.count ?? 0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let target = segue.destination as? ProfileController{
            target.userId = users?[selectedRow].id
            target.userData = users?[selectedRow]
        }
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userCell = usersTable.dequeueReusableCell(withIdentifier: String(describing: UserCell.self)) as! UserCell
        userCell.setUser(user: (users?[indexPath.row])!, rowIndex: indexPath.row)
        
        return userCell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(45)
    }

}

