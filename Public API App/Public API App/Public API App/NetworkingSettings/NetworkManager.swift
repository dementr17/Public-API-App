//
//  NetworkingManager.swift
//  Public API App
//
//  Created by Дмитрий Чепанов on 16.01.2022.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

class NetworkManager {
    static var shared = NetworkManager()
    //static дает право обратится через NetworkingManager.
    
    private init() {}
    
    func fetch<T: Decodable>(dataType: T.Type, from url: String, convertFromSnakeCase: Bool = true, completion: @escaping(Result<T, NetworkError>) -> Void) {
        // Функция с дженериком принимает любой тип (тип должен быть подписан под протокол Decodable - например в модели), при передаче мы определяем тип передаваемого файла, ссылку на него, функцию конвертирования (конвертирование в кемелкейс, если потребуеутся, то тру), и комплишн, который принимает тот же тип и энум с ошибками
        //по сути это функция для конвертации
        guard let url = URL(string: url) else {
            completion(.failure(.invalidURL))
            //если не прошла валидация - ошибка
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                completion(.failure(.noData))
                print(error?.localizedDescription ?? "No error description")
                return
            }
            do {
                let decoder = JSONDecoder()
                //отдельное свойство для экземпляра
                if convertFromSnakeCase {
                    //если конвертер тру, то декодируем JSON в кемелкейс
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    //включаем параметр декодирования
                }
                
                let type = try decoder.decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(type))
                }
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
    
    func fetchImage(from url: URL, completion: @escaping(Result<Data, NetworkError>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            DispatchQueue.main.async {
                completion(.success(data))
            }
        }.resume()
    }
}
