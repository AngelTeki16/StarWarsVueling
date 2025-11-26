//
//  PublicityCell.swift
//  StarWars
//
//  Created by Angel Duarte on 25/11/25.
//

import UIKit

final class PublicityCell: UITableViewCell {
  static let reuseIdentifier = "PublicityCell"
  
  private let label: UILabel = {
    let l = UILabel()
    l.text = "PUBLICIDAD"
    l.font = .boldSystemFont(ofSize: 24)
    l.textAlignment = .center
    return l
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    contentView.addSubview(label)
    label.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
      label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
      label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
