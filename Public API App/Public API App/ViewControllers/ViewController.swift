//
//  ViewController.swift
//  Public API App
//
//  Created by Дмитрий Чепанов on 16.01.2022.
//

import UIKit

class ViewController: UICollectionViewController {

    private let memesURL = "https://api.imgflip.com/get_memes"
    private var memes: [Memes] = []
    private var memModel: MemsModel? {
        didSet {
            self.memes = self.memModel?.data.memes ?? []
            
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        NetworkingManager.shared.fetchMemes(url: memesURL) { mem in
            self.memModel = mem
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memCell", for: indexPath) as! ViewCell
        
        let mem = memes[indexPath.row]
        cell.configure(with: mem)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let memInfo = memes[indexPath.item]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let infoVC = storyboard.instantiateViewController(identifier: "InfoViewController") as? InfoViewController else { return }
        infoVC.memesInfo = memInfo
        show(infoVC, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showInfoVC" {
            performSegue(withIdentifier: "showInfoVC", sender: nil)
        }
        guard let destination = segue.destination as? InfoViewController else { return }
        destination.memesInfo = memes[0]
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 2
        let paddingWidth = 20 * (itemsPerRow + 1)
        let avialableWidth = collectionView.frame.width - paddingWidth
        let widthPerItem = avialableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        20
    }
}
