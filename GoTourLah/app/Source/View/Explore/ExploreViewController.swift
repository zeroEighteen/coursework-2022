//
//  ExploreViewController.swift
//  Barg-InnoFest
//
//  Created by Ryan The on 21/10/20.
//  Copyright © 2020 Ryan The. All rights reserved.
//

import UIKit

struct SectionDetails {
    var name: String
}

private let cellReuseIdentifier = "cellReuseIdentifier"
private let headerReuseIdentifier = "headerReuseIdentifier"

private let sections = [
    SectionDetails(name: "Challenges"),
    SectionDetails(name: "Tours"),
]

class ExploreViewController: UICollectionViewController {
    
    var challengeViewController = UIViewController()
    var tourViewController = UIViewController()

    init() {
        let createGridLayout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            var itemSize: NSCollectionLayoutSize
            var groupSize: NSCollectionLayoutSize
            var scrollBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior = .none
            
            let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50))
            
            switch sectionIndex {
            case 0:
                itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1.0))
                groupSize = NSCollectionLayoutSize(widthDimension: .absolute(UIScreen.main.bounds.width-K.margin*3), heightDimension: .absolute(270))
                scrollBehavior = .continuous
            case 1:
                itemSize = NSCollectionLayoutSize(widthDimension: .absolute((UIScreen.main.bounds.width-K.margin*3)/2), heightDimension: .fractionalHeight(1.0))
                groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(220))
            default:
                // same as case 1
                itemSize = NSCollectionLayoutSize(widthDimension: .absolute((UIScreen.main.bounds.width-K.margin*3)/2), heightDimension: .fractionalHeight(1.0))
                groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(220))
            }
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.interItemSpacing = NSCollectionLayoutSpacing.fixed(K.margin)
            
            let section = NSCollectionLayoutSection(group: group)
            
            let headerLayout = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerFooterSize, elementKind: headerReuseIdentifier, alignment: .top)
            
            section.boundarySupplementaryItems = [headerLayout]
            section.interGroupSpacing = K.margin
            section.supplementariesFollowContentInsets = true
            section.contentInsets = NSDirectionalEdgeInsets(top: K.margin, leading: K.margin, bottom: K.margin, trailing: K.margin)
            section.orthogonalScrollingBehavior = scrollBehavior
            return section
        }
        super.init(collectionViewLayout: createGridLayout)
        
        self.collectionView.backgroundColor = .systemGroupedBackground
        self.collectionView?.register(ExploreChallengeViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        self.collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: headerReuseIdentifier, withReuseIdentifier: headerReuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: headerReuseIdentifier, withReuseIdentifier: headerReuseIdentifier, for: indexPath)
        
        let label = UILabel()
        view.addSubview(label)
        label.text = sections[indexPath.section].name
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        return view
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.challengeViewController = ModalActionViewController(contentView: createContentView(for: Location(name: "Sentosa", desc: "Somewhere in Singapore!", advisory: [.mask]), locationIsHidden: true), actions: [
            ModalActionAction(title: "Take Challenge", action: #selector(startChallenge), isPrimary: true),
            ModalActionAction(title: "Reveal Location", action: #selector(challengeShowAnswer)),
        ], target: self)
        
        self.tourViewController = ModalActionViewController(contentView: createContentView(for: Location(name: "Sentosa", desc: "Somewhere in Singapore!", advisory: [.mask])), actions: [
            ModalActionAction(title: "Begin Tour", action: #selector(startTour), isPrimary: true),
        ], target: self)
        
        
        switch indexPath.section {
        case 0:
            self.present(challengeViewController, animated: true)
        case 1:
            self.present(tourViewController, animated: true)
        default: break
        }
    }
    
    private func createContentView(for location: Location, locationIsHidden: Bool? = false) -> UIView {
        let view = UIView()
        let imageView = UIImageView(image: K.locationPlaceholderImage)
        imageView.contentMode = .scaleAspectFill
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        ])
        
        let gradient = GradientView.blackShadowOverlay
        view.addSubview(gradient)
        gradient.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([
            gradient.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            gradient.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gradient.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gradient.heightAnchor.constraint(equalToConstant: 200),
        ])

        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        let titleLabel = UILabel()
        titleLabel.text = (locationIsHidden ?? false) ? "???" : location.name
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .semibold)

//        let priceLabel = UILabel()
//        priceLabel.text = "S$" + String(format: "%.2f", foodItem.price)
//        priceLabel.textColor = .secondaryLabel
//        priceLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)

        let descLabel = UILabel()
        descLabel.textColor = .white
        descLabel.text = location.desc
        descLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        
        let detailsView = UIStackView(arrangedSubviews: [spacer, titleLabel, descLabel])
        view.addSubview(detailsView)
        detailsView.axis = .vertical
        detailsView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([
            detailsView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -K.margin),
            detailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: K.margin),
            detailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: K.margin),
            detailsView.heightAnchor.constraint(equalToConstant: 200),
        ])
        
        return view
    }
    
    @objc func startTour() {
        let alert = UIAlertController(title: "Initiated on Glass", message: "The tour has been initiated on Glass.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        tourViewController.present(alert, animated: true)
    }
    
    @objc func startChallenge() {
        let alert = UIAlertController(title: "Initiated on Glass", message: "The challenge has been initiated on Glass.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        challengeViewController.present(alert, animated: true)
        self.dismiss(animated: true)
    }
    
    @objc func challengeShowAnswer() {
        challengeViewController.present(tourViewController, animated: true)
    }
    
}
