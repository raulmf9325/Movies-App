//
//  MovieDetails.swift
//  Movies
//
//  Created by Raul Mena on 12/14/18.
//  Copyright © 2018 Raul Mena. All rights reserved.
//

import UIKit

// MARK: MovieDetails Class
class MovieDetails: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    let headerId = "headerId"
    let padding: CGFloat = 16
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupNavigationBar()
    }
    
    fileprivate func setupCollectionView(){
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CellId")
        
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout{
            layout.sectionInset = .init(top: padding, left: padding, bottom: padding, right: padding)
        }
    }
    
    private func setupNavigationBar(){
        // hide native navigation bar
        navigationController?.isNavigationBarHidden = true
        
        // add navBar view
        view.addSubview(navBar)
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        navBar.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        navBar.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        // add blurEffect to navBar
        let blur = UIBlurEffect(style: .dark)
        let effectView = UIVisualEffectView(effect: blur)
        navBar.addSubview(effectView)
        effectView.translatesAutoresizingMaskIntoConstraints = false
        effectView.widthAnchor.constraint(equalTo: navBar.widthAnchor).isActive = true
        effectView.heightAnchor.constraint(equalTo: navBar.heightAnchor).isActive = true
        
        // Add NavBar leftButton And IconView Button
        navBar.addSubview(navBarLeftButton)
        navBar.addConstraintsWithFormat(format: "H:|-20-[v0(30)]", views: navBarLeftButton)
        navBar.addConstraintsWithFormat(format: "V:[v0(30)]-8-|", views: navBarLeftButton)
        navBarLeftButton.addTarget(self, action: #selector(handleBackButtonTap), for: .touchUpInside)

//
        // add navBar title
        navBar.addSubview(navBarTitle)
        let center = view.frame.width / 2
        navBar.addConstraintsWithFormat(format: "H:|-\(center - 40)-[v0]", views: navBarTitle)
        navBar.addConstraintsWithFormat(format: "V:[v0]-12-|", views: navBarTitle)
        
        }
    
    @objc func handleBackButtonTap(){
        navigationController?.popViewController(animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! HeaderView
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellId", for: indexPath)
        cell.backgroundColor = .white
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 2 * padding, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 350)
    }
    
    
    // navBar view
    let navBar: UIView = {
        let bar = UIView()
        bar.backgroundColor = UIColor(white: 0, alpha: 0.5)
        return bar
    }()
    
    // navBar left button
    let navBarLeftButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Hamburger"), for: .normal)
        return button
    }()
    
    // navBar title
    let navBarTitle: UILabel = {
        let title = UILabel()
        title.text = "Featured"
        title.font = UIFont(name: "HelveticaNeue", size: 20)
        title.textColor = .white
        return title
    }()
    
    let profileImage: UIImageView = {
        let image = UIImage(named: "stretchy_header")
        let imageView = UIImageView(image: image)
        imageView.layer.cornerRadius = 4
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let coverImage: UIImageView = {
        let image = UIImage(named: "stretchy_header")
        let imageView = UIImageView(image: image)
      //  imageView.contentMode = .scaleToFill
        return imageView
    }()
    
}
