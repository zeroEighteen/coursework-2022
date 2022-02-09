//
//  StallsCollectionViewCell.swift
//  Barg-InnoFest
//
//  Created by Ryan The on 17/8/20.
//  Copyright © 2020 Ryan The. All rights reserved.
//

import UIKit

class StallsCollectionViewCell: UICollectionViewCell {
	
	lazy var image = K.foodPlaceholderImage
	lazy var titleLabel = UILabel()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.backgroundColor = .secondarySystemGroupedBackground
		self.layer.cornerRadius = K.cornerRadius
		self.clipsToBounds = true
		setupUi()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	private func setupUi() {
		let imageView = UIImageView(image: image)
		self.addSubview(imageView)
		imageView.translatesAutoresizingMaskIntoConstraints = false
		self.addConstraints([
			imageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -50),
			imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
			imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
			imageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
		])
		
		let textView = UIView()
		self.addSubview(textView)
		textView.translatesAutoresizingMaskIntoConstraints = false
		self.addConstraints([
			textView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
			textView.heightAnchor.constraint(equalToConstant: 50),
			textView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
			textView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
		])
		
		titleLabel.font = .systemFont(ofSize: titleLabel.font.pointSize, weight: .semibold)
		textView.addSubview(titleLabel)
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		textView.addConstraints([
			titleLabel.centerYAnchor.constraint(equalTo: textView.centerYAnchor),
			titleLabel.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: 10),
			titleLabel.trailingAnchor.constraint(equalTo: textView.trailingAnchor, constant: 10),
		])
	}
}
