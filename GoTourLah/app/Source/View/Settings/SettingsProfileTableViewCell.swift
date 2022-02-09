//
//  SettingsProfileTableViewCell.swift
//  Barg-InnoFest
//
//  Created by Ryan The on 28/8/20.
//  Copyright © 2020 Ryan The. All rights reserved.
//

import UIKit

class SettingsProfileTableViewCell: UITableViewCell {
    let profileImageSize: CGFloat = 70
    override func layoutSubviews() {
        super.layoutSubviews()
        let oldImageWidth = self.imageView!.frame.width
        self.imageView?.frame = CGRect(x: self.imageView!.frame.minX, y: (self.contentView.frame.height - profileImageSize) / 2, width: profileImageSize, height: profileImageSize)
        self.imageView?.layer.cornerRadius = profileImageSize / 2
        self.imageView?.clipsToBounds = true
        let newLabelOriginX = self.textLabel!.frame.minX + (profileImageSize - oldImageWidth)
        self.textLabel?.frame.origin = CGPoint(x: newLabelOriginX, y: self.textLabel!.frame.minY)
        self.detailTextLabel?.frame.origin = CGPoint(x: newLabelOriginX, y: self.detailTextLabel!.frame.minY)
    }
}
