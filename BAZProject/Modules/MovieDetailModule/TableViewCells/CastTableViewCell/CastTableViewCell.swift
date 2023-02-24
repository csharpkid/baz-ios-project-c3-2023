//
//  GenericTableViewCell.swift
//  BAZProject
//
//  Created by Leobardo Gama Muñoz on 15/02/23.
//

import UIKit

final class CastTableViewCell: UITableViewCell, UICollectionViewDelegateFlowLayout {
    static let reusableCell = String(describing: CastTableViewCell.self)
    var data: Credit?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
        registerCollectionViewCell()
    }
    
    private func registerCollectionViewCell() {
        let cell = UINib(nibName: "GenericCollectionViewCell", bundle: nil)
        collectionView.register(cell, forCellWithReuseIdentifier: GenericCollectionViewCell.reusableIdentifier)
    }
}

extension CastTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let data = data {
            return data.cast.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenericCollectionViewCell.reusableIdentifier,
                                                         for: indexPath) as? GenericCollectionViewCell,
           let data = data {
            UIView.fillSkeletons(onView: cell)
            
            if let image = data.cast[indexPath.row].profilePath {
                MovieAPI.getImage(from: image, handler: { image in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        UIView.removeSkeletons(onView: cell)
                        cell.imageMovie.image = image
                    }
                })
            }
            return cell
        }
        return UICollectionViewCell()
    }
}
