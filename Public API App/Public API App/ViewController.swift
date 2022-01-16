//
//  ViewController.swift
//  Public API App
//
//  Created by Дмитрий Чепанов on 16.01.2022.
//

import UIKit

class ViewController: UICollectionViewController {

    let memesURL = "https://api.imgflip.com/get_memes"
    var memModel: MemsModel!
    var memes: [Memes] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkingManager.shared.fetchMemes(url: memesURL) { mem in
            self.memModel = mem
            print(self.memModel!)
        }
        
        print("Mem model: \(self.memModel)")
        memes = memModel.data.memes
//            print(memes)
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
//        print(memes.count)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memCell", for: indexPath) as! ViewCell
        cell.backgroundColor = .white
        
        let mem = memes[indexPath.row]
        print(mem)
        cell.configure(with: mem)
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width - 48, height: 100)
    }
}
