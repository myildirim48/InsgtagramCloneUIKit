//
//  FeedController.swift
//  InstagramCloneUIKit
//
//  Created by YILDIRIM on 26.05.2023.
//

import UIKit
private let reuseIdentifier = "identifier"

class FeedController: UICollectionViewController {
    
    //MARK: -  Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - Helpers
    func configureUI() {
        collectionView.backgroundColor = .white
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
}

//MARK: -  CollectionView Datasource
extension FeedController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedCell 
        return cell
    }
}

//MARK: -  CollectionView FlowLayout Delegate
extension FeedController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.frame.width
        let hegiht = width + 166
        
        return CGSize(width: view.frame.width, height: hegiht)
    }
}
