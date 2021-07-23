//
//  RepoDetailsViewModel.swift
//  githubble
//
//  Created by Nikita Fedorenko on 18.07.2021.
//

import Foundation

protocol RepoDetailsViewModelDelegate {
    func fetchUser(login: String?)
    func fetchCachedRepos()
    func isFavorite(fullName: String?)
    func favorite(repo: Repo)
}

class RepoDetailsViewModel: RepoDetailsViewModelDelegate {
    
    var cachedRepos = [Repo]()
    let service: UserServiceProtocol
    weak var delegate: RepoDetailsViewControllerDelegate?
    var isFavorite: Bool = false
    
    init(service: UserServiceProtocol = UserService()) {
        self.service = service
    }
    
    func fetchUser(login: String?) {
        if let login = login{
            service.fetch(login: login, completion: { user in
                self.delegate?.getUser(user: user)
            })
        }
    }
    
    func fetchCachedRepos() {
        if let cachedRepos = try? CacheManager.shared.storage?.object(forKey: "repos"){
            self.cachedRepos = cachedRepos
        }
    }
    
    func favorite(repo: Repo) {
        guard let fullName = repo.fullName else {return}
        
        if isFavorite{
            removeFavorite(fullName: fullName)
        }else{
            addFavorite(repo: repo)
            self.delegate?.setFavoriteImageType(filled: true)
        }
    }
    
    func isFavorite(fullName: String?) {
        if let fullName = fullName, cachedRepos.contains(where: {$0.fullName == fullName}){
            isFavorite = true
            self.delegate?.setFavoriteImageType(filled: true)
        }
    }
    
    func addFavorite(repo: Repo) {
        do{
            cachedRepos.append(repo)
            try CacheManager.shared.storage?.setObject(cachedRepos, forKey: "repos")
        }catch{
            print("error while adding \(repo.fullName!) object to cache")
        }
    }
    
    func removeFavorite(fullName: String){
        do{
            if let index = cachedRepos.firstIndex(where: {$0.fullName == fullName}){
                cachedRepos.remove(at: index)
                try CacheManager.shared.storage?.setObject(cachedRepos, forKey: "repos")
                self.delegate?.setFavoriteImageType(filled: false)
            }
        }catch{
            print("error while removing \(fullName) object form cache")
        }
    }
}
