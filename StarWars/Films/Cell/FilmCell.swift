//
//  FilmCell.swift
//  StarWars
//
//  Created by Angel Duarte on 24/11/25.
//

import UIKit

final class FilmCell: UITableViewCell {
  
  static let reuseIdentifier = "FilmCell"
  
  private lazy var titleLabel: UILabel = {
    let titleLabel = UILabel()
    titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
    return titleLabel
  }()
  
  private lazy var directorLabel: UILabel = {
    let directorLabel = UILabel()
    directorLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
    directorLabel.textColor = .secondaryLabel
    return directorLabel
  }()
  
  private lazy var releaseDateLabel: UILabel = {
    let releaseDateLabel = UILabel()
    releaseDateLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
    releaseDateLabel.textColor = .secondaryLabel
    return releaseDateLabel
  }()
  
  private lazy var stack: UIStackView = {
    let stack = UIStackView()
    stack.axis = .vertical
    stack.spacing = 4
    stack.translatesAutoresizingMaskIntoConstraints = false
    return stack
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }
  
  private func setupUI() {
    accessoryType = .none
    contentView.addSubview(stack)
    stack.addArrangedSubview(titleLabel)
    stack.addArrangedSubview(directorLabel)
    stack.addArrangedSubview(releaseDateLabel)
    
    NSLayoutConstraint.activate([
      stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
      stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
      stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
    ])
  }
  
  func configure(with viewModel: FilmCellViewModel) {
    titleLabel.text = viewModel.titleText
    directorLabel.text = viewModel.directorText
    releaseDateLabel.text = viewModel.releaseDateText
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
