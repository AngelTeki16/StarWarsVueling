//
//  CharacterListViewController.swift
//  StarWars
//
//  Created by Angel Duarte on 19/11/25.
//

import UIKit

class CharacterListViewController: UIViewController {
  
  private lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.register(CharacterCell.self, forCellReuseIdentifier: CharacterCell.reuseIdentifier)
    tableView.register(PublicityCell.self, forCellReuseIdentifier: PublicityCell.reuseIdentifier)
    tableView.refreshControl = refreshControl
    return tableView
  }()
  
  private lazy var activityIndicator: UIActivityIndicatorView = {
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    return activityIndicator
  }()
  
  private lazy var refreshControl: UIRefreshControl = {
    let refreshControl = UIRefreshControl()
    return refreshControl
  }()
  
  private lazy var searchController: UISearchController = {
    let searchController = UISearchController(searchResultsController: nil)
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Buscar personaje"
    return searchController
  }()
  
  var viewModel: CharacterListViewModel?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigation()
    setupUI()
    setupSearch()
    viewModel?.delegate = self
    viewModel?.load()
  }
  
  private func setupNavigation() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(didTapSettings))
  }
  
  private func setupUI() {
    title = "Characters"
    view.backgroundColor = .systemBackground
    refreshControl.addTarget(self, action: #selector(refreshTriggered), for: .valueChanged)
    tableView.dataSource = self
    tableView.delegate = self
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
  
  private func setupSearch() {
    searchController.searchResultsUpdater = self
    navigationItem.searchController = searchController
    navigationItem.hidesSearchBarWhenScrolling = false
    definesPresentationContext = true
  }
  
  @objc private func refreshTriggered() {
    guard let viewModel else { return }
    viewModel.refresh()
  }
  
  @objc private func didTapSettings() {
    guard let viewModel else { return }
    let alert = UIAlertController(title: "Configuración", message: nil, preferredStyle: .alert)
    
    let stack = UIStackView()
    stack.axis = .horizontal
    stack.spacing = 8
    stack.alignment = .center
    
    let label = UILabel()
    label.text = "Mostrar publicidad"
    
    let toggle = UISwitch()
    toggle.isOn = viewModel.adsEnabled
    toggle.addTarget(self, action: #selector(adsSwitchChanged(_:)), for: .valueChanged)
    
    stack.addArrangedSubview(label)
    stack.addArrangedSubview(toggle)
    
    let contentVC = UIViewController()
    contentVC.view.addSubview(stack)
    stack.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      stack.topAnchor.constraint(equalTo: contentVC.view.topAnchor, constant: 8),
      stack.leadingAnchor.constraint(equalTo: contentVC.view.leadingAnchor, constant: 8),
      stack.trailingAnchor.constraint(equalTo: contentVC.view.trailingAnchor, constant: -8),
      stack.bottomAnchor.constraint(equalTo: contentVC.view.bottomAnchor, constant: -8)
    ])
    
    alert.setValue(contentVC, forKey: "contentViewController")
    alert.addAction(UIAlertAction(title: "Cerrar", style: .default))
    
    present(alert, animated: true)
  }
  
  @objc private func adsSwitchChanged(_ sender: UISwitch) {
    guard let viewModel else { return }
    viewModel.setAdsEnabled(sender.isOn)
  }
}

extension CharacterListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let viewModel else { return 0 }
    let count = viewModel.items.count
    guard showAds() else { return count }
    let adsCount = count / 5
    return count + adsCount
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let viewModel else { return UITableViewCell() }
    if isAdRow(indexPath.row) {
      let cell = tableView.dequeueReusableCell(withIdentifier: PublicityCell.reuseIdentifier, for: indexPath) as! PublicityCell
      return cell
    } else {
      let characterIndex = characterIndex(for: indexPath.row)
      let cell = tableView.dequeueReusableCell(withIdentifier: CharacterCell.reuseIdentifier, for: indexPath) as! CharacterCell
      let vm = viewModel.items[characterIndex]
      cell.configure(with: vm)
      return cell
    }
  }
}

extension CharacterListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let viewModel else { return }
    viewModel.didSelectItem(at: indexPath.row)
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    guard let viewModel = viewModel else { return }
    let count = viewModel.items.count
    guard count > 0 else { return }
    let threshold = 5
    let lastIndex = count - 1
    if indexPath.row >= max(0, lastIndex - threshold) {
      viewModel.loadPage()
    }
  }
}

extension CharacterListViewController: CommonViewModelDelegate {
  func didUpdateData() {
    tableView.reloadData()
  }
  
  func didUpdateLoadingState(isLoading: Bool) {
    if isLoading {
      activityIndicator.startAnimating()
    } else {
      activityIndicator.stopAnimating()
      refreshControl.endRefreshing()
    }
  }
  
  func didReceiveError(_ message: String) {
    let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default))
    present(alert, animated: true)
  }
}

extension CharacterListViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    guard let viewModel else { return }
    let text = searchController.searchBar.text ?? ""
    viewModel.updateSearch(query: text)
  }
}

extension CharacterListViewController {
  private func showAds() -> Bool {
    guard let viewModel else { return false }
    return viewModel.adsEnabled
  }
  
  private func isAdRow(_ row: Int) -> Bool {
    showAds() && (row + 1) % 6 == 0
  }
  
  private func characterIndex(for row: Int) -> Int {
    guard showAds() else { return row }
    let adsBefore = (row + 1) / 6
    return row - adsBefore
  }
}
