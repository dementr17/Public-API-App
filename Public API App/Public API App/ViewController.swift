//
//  ViewController.swift
//  Public API App
//
//  Created by Дмитрий Чепанов on 16.01.2022.
//

import UIKit

private let reuseIdentifier = "memCell"

private var memModel: MemsModel!
private var memes: [Memes] = []
let memesURL = "https://api.imgflip.com/get_memes"


class ViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkingManager.shared.fetchMemes(url: memesURL) { mem in
            memModel = mem
        }
        
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ViewCell
        cell.backgroundColor = .white
        memes = memModel.data.memes
        let mem = memes[indexPath.row]
        cell.configure(with: mem)
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width - 48, height: 100)
    }
}
