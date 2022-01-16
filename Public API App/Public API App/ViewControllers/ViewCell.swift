//
//  ViewCell.swift
//  Public API App
//
//  Created by Дмитрий Чепанов on 16.01.2022.
//

import UIKit

class ViewCell: UICollectionViewCell {
    @IBOutlet weak var imageMemes: UIImageView!
    
    func configure(with memes: Memes) {
        DispatchQueue.global().async {
            guard let url = URL(string: memes.url) else { return }
            
            guard let imageData = try? Data(contentsOf: url) else { return }
            
            DispatchQueue.main.async {
                self.imageMemes.image = UIImage(data: imageData)
            }
        }
    }
}
