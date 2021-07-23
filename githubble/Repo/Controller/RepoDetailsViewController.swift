//
//  RepoDetailsViewController.swift
//  githubble
//
//  Created by Nikita Fedorenko on 15.07.2021.
//

import UIKit
import Cache

protocol RepoDetailsViewControllerDelegate: AnyObject {
    func getUser(user: User)
    func setFavoriteImageType(filled: Bool)
}

class RepoDetailsViewController: UIViewController {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var btnFavorite: UIBarButtonItem!
    
    @IBOutlet weak var lblOwner: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    
    let viewModel = RepoDetailsViewModel()
    
    var name: String? = ""
    var fullName: String? = ""
    var desc: String? = ""
    var login: String? = ""
    
    var doneCompletion: (() -> Void) = {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Details"
        
        viewModel.delegate = self
        
        lblName.text = self.name
        lblDesc.text = self.desc
        
        viewModel.fetchUser(login: login)
        
        viewModel.fetchCachedRepos()
        viewModel.isFavorite(fullName: fullName)
    }
    
    @IBAction func done(_ sender: Any) {
        dismiss(animated: true, completion: {
            self.doneCompletion()
        })
    }
    
    @IBAction func favorite(_ sender: Any) {
        let repo = Repo(name: name, fullName: fullName, description: desc, owner: Owner(login: login))
        viewModel.favorite(repo: repo)
    }
}

extension RepoDetailsViewController: RepoDetailsViewControllerDelegate{
    
    func getUser(user: User) {
        DispatchQueue.main.async {
            self.lblOwner.text = user.name
            self.lblEmail.text = user.email
        }
    }
    
    func setFavoriteImageType(filled: Bool) {
        btnFavorite.image = filled ? Image(systemName: "heart.fill") : Image(systemName: "heart")
    }
}
