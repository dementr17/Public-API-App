//
//  NetworkingManager.swift
//  Public API App
//
//  Created by Дмитрий Чепанов on 16.01.2022.
//

import UIKit

enum NetworkingError: Error {
    case invalidURL
    case
    case
}

class NetworkingManager {
    static var shared = NetworkingManager()
     //static дает право обратится через NetworkingManager.
    
    private init() {}
    
//    func fetchMemes(url: String, complition: @escaping(_ mem: MemsModel) -> Void) {
//        guard let url = URL(string: url) else { return }
//
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            guard let data = data, let _ = response else {
////                print(error?.localizedDescription ?? "No error description")
//                return
//            }
//
//            do {
//                let memsDescription = try JSONDecoder().decode(MemsModel.self, from: data)
//                DispatchQueue.main.async {
//                    complition(memsDescription)
////                    print(memsDescription)
//                }
////                self.successAlert()
////                print("MemesDescription: \(memsDescription)")
//            } catch {
////                self.failedAlert()
////                print(error.localizedDescription)
//            }
//        }.resume()
//    }
    
    func fetchMemes(url: String, complition: @escaping(Result<MemsModel, NetworkingError>) -> Void) {
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let _ = response else {
//                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            do {
                let memsDescription = try JSONDecoder().decode(MemsModel.self, from: data)
                DispatchQueue.main.async {
                    complition(memsDescription)
//                    print(memsDescription)
                }
//                self.successAlert()
//                print("MemesDescription: \(memsDescription)")
            } catch {
//                self.failedAlert()
//                print(error.localizedDescription)
            }
        }.resume()
    }
}
