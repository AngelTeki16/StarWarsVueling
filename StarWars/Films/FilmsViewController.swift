//
//  FilmsViewController.swift
//  StarWars
//
//  Created by Angel Duarte on 24/11/25.
//

import UIKit

class FilmsViewController: UIViewController {
  
  var viewModel: FilmsViewModel?
  
  private lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.register(FilmCell.self, forCellReuseIdentifier: FilmCell.reuseIdentifier)
    return tableView
  }()
  
  private lazy var activityIndicator: UIActivityIndicatorView = {
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    return activityIndicator
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    viewModel?.delegate = self
    viewModel?.load()
  }
  
  private func setupUI() {
    title = viewModel?.title
    view.backgroundColor = .systemBackground
    
    tableView.dataSource = self
    view.addSubview(tableView)
    view.addSubview(activityIndicator)
    
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      
      activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ])
  }
}

extension FilmsViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let viewModel else { return 0 }
    return viewModel.items.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: FilmCell.reuseIdentifier, for: indexPath) as? FilmCell,
          let viewModel else { return UITableViewCell() }
    let cellViewModel = viewModel.items[indexPath.row]
    cell.configure(with: cellViewModel)
    return cell
  }
}

extension FilmsViewController: CommonViewModelDelegate {
  
  func didUpdateData() {
    tableView.reloadData()
  }
  
  func didUpdateLoadingState(isLoading: Bool) {
    if isLoading {
      activityIndicator.startAnimating()
    } else {
      activityIndicator.stopAnimating()
    }
  }
  
  func didReceiveError(_ message: String) {
    let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default))
    present(alert, animated: true)
  }
}
