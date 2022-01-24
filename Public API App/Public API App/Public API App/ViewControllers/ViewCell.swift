//
//  ViewCell.swift
//  Public API App
//
//  Created by Дмитрий Чепанов on 16.01.2022.
//

import UIKit

class ViewCell: UICollectionViewCell {

	@IBAction func buttonDidTap(_ sender: Any) {
		onTapAction?()
	}
	@IBOutlet weak var imageMemes: UIImageView! {
        didSet {
            imageMemes.layer.cornerRadius = 10
        }
    }

	private var onTapAction: (() -> Void)?
    private var imageURL: URL? {
        didSet {
            //каждый раз при обращении к юрл, обнуляем imageView и передаем по юрл изображение. Таким образом не происходит накладка изображения при переиндексации картинок
            imageMemes.image = nil
            updateImage()
        }
    }
    
	func configure(with mem: Memes, onTapAction: @escaping () -> Void) {
        imageURL = URL(string: mem.url)
		self.onTapAction = onTapAction
    }
    
    private func updateImage() {
        guard let url = imageURL else { return }
        getImage(from: url) { result in
            switch result {
            case .success(let image):
                if url == self.imageURL {
                    self.imageMemes.image = image
//                    self.activityIndicator?.stopAnimating()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func getImage(from url: URL, completion: @escaping(Result<UIImage, Error>) -> Void) {
        // Get image from cache
        if let cachedImage = ImageCache.shared.object(forKey: url.lastPathComponent as NSString ) {
            print("Image from cache: ", url.lastPathComponent)
            //если изображение есть в кеше по ключу концовки юрл то в комплетишн передаем его
            completion(.success(cachedImage))
            return
        }
        
        // Dowonload image from url
        //если в кеше нет, то грузи из сети или возвращаем ошибку
        NetworkManager.shared.fetchImage(from: url) { result in
            switch result {
            case .success(let data):
                guard let image = UIImage(data: data) else { return }
                ImageCache.shared.setObject(image, forKey: url.lastPathComponent as NSString)
                //подгружаем в кеш, так как его там нет
                print("Image from network: ", url.lastPathComponent)
                completion(.success(image))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
    }
}
