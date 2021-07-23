//
//  FavoriteListViewModel.swift
//  githubble
//
//  Created by Nikita Fedorenko on 15.07.2021.
//

import Foundation

protocol FavoritesViewModelDelegate {
    func fetch()
}

class FavoritesViewModel: FavoritesViewModelDelegate {
    
    weak var delegate: FavoritesViewControllerDelegate?
    
    func fetch() {
        if let cachedRepos = try? CacheManager.shared.storage?.object(forKey: "repos"){
            delegate?.getFavorites(data: cachedRepos)
        }
    }
}
