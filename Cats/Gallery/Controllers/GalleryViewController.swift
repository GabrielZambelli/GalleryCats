//
//  GalleryViewController.swift
//  Cats
//
//  Created by Gabriel Zambelli on 11/06/20.
//  Copyright © 2020 Gabriel Zambelli. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController {

    //MARK: - Properties
    
    private lazy var galleryViewModel = GalleryViewModel()
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var listGalleryCollectionView: UICollectionView!
    
    
    //MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listGalleryCollectionView.delegate = self
        listGalleryCollectionView.dataSource = self
        listGalleryCollectionView.register(UINib(nibName: "GalleryCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "ImageCollectionCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        galleryViewModel.loadGallery(complete: galleryLoaded)
    }
    
    //MARK: - Methods
    
    func galleryLoaded() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.listGalleryCollectionView.reloadData()
        }
    }
}

//MARK: - Collection DataSource

extension GalleryViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return galleryViewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let collectionCell = listGalleryCollectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionCell", for: indexPath) as! GalleryColletionViewCell
        collectionCell.tag = indexPath.row
        
        collectionCell.catImage.image = UIImage(named: "carregando")
        guard let galleryImage = galleryViewModel.getGalleryImage(at: indexPath) else{ return UICollectionViewCell() }
        
        let cellViewModel = GalleryCollectionCellViewModel(galleryImage)
        cellViewModel.getImage {  (image) in
            DispatchQueue.main.async() {
                if(collectionCell.tag == indexPath.row){
                    collectionCell.catImage.image = image
                }
            }
        }
        
        return collectionCell
    }
    
}


//MARK: - Collection Delegate Flow

extension GalleryViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let device = UIDevice.current
        
        if device.userInterfaceIdiom == .phone{
            switch device.orientation {
            case .portrait:
                return CGSize(width: collectionView.bounds.width/2 - 10, height: 180)
            default:
                return CGSize(width: collectionView.bounds.width/3 - 10, height: 180)
            }
        }
        else {
            return CGSize(width: collectionView.bounds.width/3 - 20, height: 250)
        }
    }
}
//MARK: - Collection Delegate

extension GalleryViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == galleryViewModel.count - 1 {
            galleryViewModel.loadGallery(complete: galleryLoaded)
        }
        
    }
    
    
    
}
