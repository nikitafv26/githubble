//
//  RepoListViewModel.swift
//  githubble
//
//  Created by Nikita Fedorenko on 15.07.2021.
//

import Foundation

protocol ReposViewModelDelegate {
    func fetch(name: String, page: Int)
}

class ReposViewModel: ReposViewModelDelegate {
    let service: RepoServiceProtocol
    weak var delegate: ReposViewControllerDelegate?
    let itemsInBatch = 20
    
    init(service: RepoServiceProtocol = RepoService()) {
        self.service = service
    }
    
    func fetch(name: String, page: Int) {
        service.fetch(name: name, itemsInBatch: itemsInBatch, page: page, completion: { response in
            let pageCount = self.pageCount(totalCount: response.count)
            self.delegate?.getRepos(data: response.items, pageCount: pageCount)
        })
    }
    
    private func pageCount(totalCount: Int?) -> Int {
        if let totalCount = totalCount{
            let pageCount = Double(totalCount / itemsInBatch).rounded(.up)
            return Int(pageCount)
        }
        return 0
    }
}
