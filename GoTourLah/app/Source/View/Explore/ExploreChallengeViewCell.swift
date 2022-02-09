//
//  ExploreViewCell.swift
//  Barg-InnoFest
//
//  Created by Ryan The on 21/10/20.
//  Copyright © 2020 Ryan The. All rights reserved.
//

import UIKit

class ExploreChallengeViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .secondarySystemGroupedBackground
        self.layer.cornerRadius = K.cornerRadius
        self.clipsToBounds = true
        
        let imageView = UIImageView(image: K.locationPlaceholderImage)
        self.contentView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addConstraints([
            imageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
            imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),

        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
