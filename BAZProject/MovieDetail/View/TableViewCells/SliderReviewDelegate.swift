//
//  SliderReviewDelegate.swift
//  BAZProject
//
//  Created by Luis Alberto Perez Villar on 08/03/23.
//

import UIKit

final class SliderReviewDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 90, height: 160)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        5
    }
}
