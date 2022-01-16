//
//  NetworkingManager.swift
//  Public API App
//
//  Created by Дмитрий Чепанов on 16.01.2022.
//

import UIKit

class NetworkingManager {
    static var shared = NetworkingManager()
    
    private init() {}
    
    func fetchMemes(url: String, complition: @escaping(_ mem: MemsModel) -> Void) {
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
                self.successAlert()
//                print("MemesDescription: \(memsDescription)")
            } catch {
                self.failedAlert()
//                print(error.localizedDescription)
            }
        }.resume()
    }
    
}

extension NetworkingManager {
    private func successAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "Success",
                message: "You can see the results in the Debug aria",
                preferredStyle: .alert
            )
            //передача в основной поток действия
            let okAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okAction)
//            self.present(alert, animated: true)
        }
    }
    //алерты для обработки ошибки передачи
    private func failedAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "Failed",
                message: "You can see error in the Debug aria",
                preferredStyle: .alert
            )
            
            let okAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okAction)
//            self.present(alert, animated: true)
        }
    }
}
