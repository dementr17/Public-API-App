//
//  ViewController.swift
//  Public API App
//
//  Created by Дмитрий Чепанов on 16.01.2022.
//

import UIKit

class ViewController: UICollectionViewController {

    private let urlMemes = "https://api.imgflip.com/get_memes"
    private var memes: [Memes] = []
    private var memsModel: MemsModel? {
        didSet {
            self.memes = self.memsModel?.data.memes ?? []

            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }
 
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memCell", for: indexPath) as! ViewCell
        
        let mem = memes[indexPath.row]
        cell.configure(with: mem, onTapClosure: {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "MemViewController") as! MemViewController
                    navigationController?.pushViewController(controller, animated: true)
        })
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
//        guard let indexPath = collectionView.indexPathsForSelectedItems else { return }
//        let mems = memes[indexPath.row]
//               let memVC = segue.destination as! MemViewController
////        memVC.name = mems
//
//    }
}


extension ViewController {
    func fetchData() {
        NetworkManager.shared.fetch(dataType: MemsModel.self, from: urlMemes) { result in
            switch result {
                
            case .success(let memes):
                self.memsModel = memes
                self.collectionView.reloadData()
            case .failure(let error):
                self.failedAlert()
                print(error)
            }
        }
    }
}

// MARK: Parameter Items
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
// MARK: UIAlerts
extension ViewController {
    private func successAlert() {
    DispatchQueue.main.async {
        let alert = UIAlertController(
            title: "Success",
            message: "You can see the results in the Debug aria",
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
            self.present(alert, animated: true)
    }
}

private func failedAlert() {
    DispatchQueue.main.async {
        let alert = UIAlertController(
            title: "Failed",
            message: "You can see error in the Debug aria",
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
            self.present(alert, animated: true)
    }
}
}
