//
//  FavoriteListViewController.swift
//  githubble
//
//  Created by Nikita Fedorenko on 15.07.2021.
//

import UIKit

protocol FavoritesViewControllerDelegate: AnyObject {
    func getFavorites(data: [Repo]?)
}

class FavoritesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = FavoritesViewModel()
    var data = [Repo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Favorites"
        
        viewModel.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navigationVC = segue.destination as? UINavigationController{
            if let vc = navigationVC.topViewController as? RepoDetailsViewController{
                if let row = tableView.indexPathForSelectedRow?.row{
                    vc.name = data[row].name
                    vc.fullName = data[row].fullName
                    vc.desc = data[row].description
                    vc.login = data[row].owner?.login
                    vc.doneCompletion = {
                        self.viewModel.fetch()
                    }
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel.fetch()
    }
}

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row].fullName
        return cell
    }
}

extension FavoritesViewController: FavoritesViewControllerDelegate{
    func getFavorites(data: [Repo]?) {
        guard let data = data else {return}
        self.data = data
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
