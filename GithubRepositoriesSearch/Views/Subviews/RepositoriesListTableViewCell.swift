//
//  RepositoriesListTableViewCell.swift
//  GithubRepositoriesSearch
//
//  Created by Shrimp Hsieh on 2022/3/1.
//

import UIKit
import Combine

class RepositoriesListTableViewCell: UITableViewCell {
    
    // MARK: - Property
    @Published var name: String?
    
    // MARK: - Life cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        
        bind()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private property
    private let nameLabel = UILabel() --> {
        $0.font = .systemFont(ofSize: 14, weight: .semibold)
        $0.textColor = .black
    }
    
    private var cancelableSet = Set<AnyCancellable>()
}

private extension RepositoriesListTableViewCell {
    
    func setupUI() {
        configureBackground()
        configureNameLabel()
    }
    
    func configureBackground() {
        
        backgroundColor = .clear
                
    }
    
    func configureNameLabel() {
        
        contentView.addSubview(nameLabel)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
    }
    
}

private extension RepositoriesListTableViewCell {
    
    func bind() {
        
        $name.assign(to: \.text, on: nameLabel).store(in: &cancelableSet)
        
    }
    
}
