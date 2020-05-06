//
//  MemberCell.swift
//  Kibble
//
//  Created by VICTOR CHU on 2020-05-05.
//  Copyright © 2020 Victor Chu. All rights reserved.
//

import UIKit

class MemberCell: UITableViewCell {

    let defaultImage = UIImageView()
    let nameLabel = UILabel()
    let cellView = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        backgroundColor = .clear
        addSubview(cellView)
        cellView.addSubview(nameLabel)
        cellView.addSubview(defaultImage)

        //cellView.backgroundColor = UIColor.black.withAlphaComponent(0.05)
        cellView.backgroundColor = UIColor.white
        cellView.layer.cornerRadius = 12
        cellView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16.adjusted),
            cellView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16.adjusted),
            cellView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16.adjusted),
            cellView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])

        defaultImage.translatesAutoresizingMaskIntoConstraints = false
        defaultImage.contentMode = UIView.ContentMode.scaleAspectFit
        defaultImage.image = #imageLiteral(resourceName: "Member")
        NSLayoutConstraint.activate([
            defaultImage.heightAnchor.constraint(equalToConstant: 35),
            defaultImage.widthAnchor.constraint(equalToConstant: 35),
            defaultImage.centerYAnchor.constraint(equalTo: cellView.centerYAnchor),
            defaultImage.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 10.adjusted)
        ])

        nameLabel.textColor = UIColor.black
        nameLabel.font = Device.roundedFont(ofSize: .title2, weight: .medium)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        //nameLabel.heightAnchor.constraint(equalToConstant: 200).isActive = true
        //nameLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: cellView.centerYAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: defaultImage.rightAnchor, constant: 10).isActive = true
    }

    func configureCell(name: String) {
        nameLabel.text = name
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
