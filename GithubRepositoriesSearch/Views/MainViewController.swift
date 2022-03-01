//
//  MainViewController.swift
//  GithubRepositoriesSearch
//
//  Created by Shrimp Hsieh on 2022/3/1.
//

import UIKit
import Combine

class MainViewController: UIViewController {
    
    // MARK: - Property
    var viewModel: MainViewModelPrototype?
    
    // MARK: - Private property
    private let tableView = UITableView() --> {
        $0.register(RepositoriesListTableViewCell.self)
        $0.backgroundColor = .white
    }
    
    private let searchController = UISearchController() --> {
        $0.obscuresBackgroundDuringPresentation = false
        $0.hidesNavigationBarDuringPresentation = true
    }
    
    private var cancelable = Set<AnyCancellable>()
    
    @Published private var models = [RepositoryElementModel]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        guard let viewModel = viewModel else {
            return
        }
        
        bind(viewModel)
    }
    
}

// MARK: - UI configure
private extension MainViewController {
    
    func setupUI() {
        view.backgroundColor = .white
        configureNavigationController()
        configureTableView()
        setupSearchBarListeners()
    }
    
    func configureTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)

        // Make constraints
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        tableView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        
    }
    
    func configureNavigationController() {
        
        navigationItem.searchController = searchController
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Github Repository"
        
    }
    
    func setupSearchBarListeners() {
        
        let publisher = NotificationCenter.default.publisher(for: UISearchTextField.textDidChangeNotification,
                                                                object: searchController.searchBar.searchTextField)
        
        publisher
            .map {
                ($0.object as! UISearchTextField).text
            }
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .sink { (searchString) in
                self.viewModel?.input.searchRepository(by: searchString)
            }
            .store(in: &cancelable)
    }
    
}

// MARK: - Binding
private extension MainViewController {
    
    func bind(_ viewModel: MainViewModelPrototype) {
        viewModel
            .output
            .models.assign(to: \.models, on: self).store(in: &cancelable)
    }
    
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        models.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = RepositoriesListTableViewCell.use(tableView: tableView, for: indexPath)
        let model = models[indexPath.row]
        
        cell.name = model.full_name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }

}
