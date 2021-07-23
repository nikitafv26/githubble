//
//  RepoListViewController.swift
//  githubble
//
//  Created by Nikita Fedorenko on 15.07.2021.
//

import UIKit

protocol ReposViewControllerDelegate: AnyObject {
    func getRepos(data: [Repo]?, pageCount: Int?)
}

class ReposViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var viewModel = ReposViewModel()
    var data = [Repo]()
    var pageCount: Int?
    var page: Int = 0
    var timer: Timer?
    var searchText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Repos"
        
        viewModel.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setupSearchBar()
    }
    
    func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false;
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationVC = segue.destination as! UINavigationController
        if let vc = navigationVC.topViewController as? RepoDetailsViewController{
            if let row = tableView.indexPathForSelectedRow?.row{
                vc.name = data[row].name
                vc.fullName = data[row].fullName
                vc.desc = data[row].description
                vc.login = data[row].owner?.login
            }
        }
    }
}

//MARK: UITableView
extension ReposViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = data[indexPath.row]
        
        cell.textLabel?.text = item.fullName
        
        if let pageCount = pageCount,
           indexPath.row == data.count - 1,
           let searchText = searchText,
           page <= pageCount{
            page += 1
            self.viewModel.fetch(name: searchText, page: page)
            return cell
        }
        
        return cell
    }
}

extension ReposViewController: ReposViewControllerDelegate{
   
    func getRepos(data: [Repo]?, pageCount: Int?) {
        guard let data = data else { return }
        self.data.append(contentsOf: data)
        
        self.pageCount = pageCount
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}

extension ReposViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let name = searchBar.text, !name.isEmpty{
            self.searchText = name
            timer?.invalidate()
            
            timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false,
                                         block: {_ in
                                            self.data = []
                                            self.viewModel.fetch(name: name, page: 0)
                                         })
        }
    }
}
