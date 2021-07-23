//
//  RepoService.swift
//  githubble
//
//  Created by Nikita Fedorenko on 16.07.2021.
//

import Foundation

protocol RepoServiceProtocol {
    func fetch(name: String, itemsInBatch: Int, page: Int, completion: @escaping (RepoResponse) -> Void)
}

class RepoService: RepoServiceProtocol{
    var session: URLSession
    
    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }
    
    func fetch(name: String, itemsInBatch: Int, page: Int, completion: @escaping (RepoResponse) -> Void) {
        
        let enpoint = Endpoint(path: "/search/repositories",
                               queryItems: [
                                URLQueryItem(name: "q", value: "\(name)"),
                                URLQueryItem(name: "per_page", value: "\(itemsInBatch)"),
                                URLQueryItem(name: "page", value: "\(page)")
                               ])
        
        guard let url = enpoint.url else {return}
        
        var request = URLRequest(url: url)
        request.setValue("request", forHTTPHeaderField: "User-Agent")
        request.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request){ data, response, error  in
            
            if let error = error {
                print("client error \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("server error")
                return
            }
            
            if let data = data{
                do{
                    let strResult = String(data: data, encoding: .utf8)
                    print(strResult ?? "")
                    
                    let result = try JSONDecoder().decode(RepoResponse.self, from: data)
                    completion(result)
                }catch{
                    print("error while decoding data \(error.localizedDescription)")
                }
            }
            
        }
        task.resume()
        
    }
    
}
