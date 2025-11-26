//
//  CharacterCell.swift
//  StarWars
//
//  Created by Angel Duarte on 24/11/25.
//

import UIKit

final class CharacterCell: UITableViewCell {
  
  static let reuseIdentifier = "CharacterCell"
  private lazy var iconImageView: UIImageView = {
    let iconImageView = UIImageView()
    iconImageView.translatesAutoresizingMaskIntoConstraints = false
    iconImageView.contentMode = .scaleAspectFit
    return iconImageView
  }()
  
  private lazy var nameLabel: UILabel = {
    let nameLabel = UILabel()
    nameLabel.font = UIFont.preferredFont(forTextStyle: .headline)
    return nameLabel
  }()
  
  private let birthYearLabel: UILabel = {
    let birthYearLabel = UILabel()
    birthYearLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
    birthYearLabel.textColor = .secondaryLabel
    return birthYearLabel
  }()
  
  private lazy var stack: UIStackView = {
    let stack = UIStackView()
    stack.axis = .vertical
    stack.spacing = 2
    stack.translatesAutoresizingMaskIntoConstraints = false
    return stack
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }
  
  private func setupUI() {
    accessoryType = .disclosureIndicator
    contentView.addSubview(iconImageView)
    contentView.addSubview(stack)
    
    stack.addArrangedSubview(nameLabel)
    stack.addArrangedSubview(birthYearLabel)
    
    NSLayoutConstraint.activate([
      iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      iconImageView.heightAnchor.constraint(equalToConstant: 24),
      iconImageView.widthAnchor.constraint(equalToConstant: 24),
      stack.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
      stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
      stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
      stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
    ])
  }
  
  func configure(with viewModel: CharacterCellViewModel) {
    nameLabel.text = viewModel.nameText
    birthYearLabel.text = "Born: \(viewModel.birthYearText)"
    iconImageView.image = UIImage(named: viewModel.genderIcon)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
