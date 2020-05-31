//
//  FavoritesView.swift
//  AVPlayerLayer Video Playback
//
//  Created by Sam LoBue on 5/30/20.
//  Copyright © 2020 DjangoEarnhardt. All rights reserved.
//

import UIKit

class FavoritesView: UIView {

    /*
     |------------|
     | -Favorite- |
     |   Button   |
     |            |
     | -Favorite- |
     |   Button   |
     |------------|
     */
    
    // TODO: Add scroll view to this, and include multiple favorites
    // MARK: PROPERTIES
    weak var favoritesViewDelegate: FavoritesViewDelegate? // Delegate favorites button name and controls
    
    let favoritesButton: UIButton = {
        let favoritesButton = UIButton()
        favoritesButton.setTitle("00:00", for: .normal)
        // FIXME: Why isn't this changing color
        favoritesButton.titleLabel?.tintColor = .red
        favoritesButton.titleLabel?.textAlignment = .center
        favoritesButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return favoritesButton
    }()
    
    let horizontalStackView: UIStackView = {
        let horizontalStackView = UIStackView()
        horizontalStackView.axis = NSLayoutConstraint.Axis.horizontal
        horizontalStackView.distribution = .fillEqually
        return horizontalStackView
    }()
    
    let scrollView: UIView = {
        let scrollView = UIView()
        scrollView.backgroundColor = .white
        return scrollView
    }()
    
    // MARK: LIFECYCLE
    public override init(frame: CGRect) {
        super.init(frame: frame)
        constructSubviews()
        constructSubviewConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: HELPER FUNCTIONS
    func constructSubviews() {
        horizontalStackView.addArrangedSubview(favoritesButton)
        addSubview(horizontalStackView)
//        addSubview(scrollView)
    }
    
    func constructSubviewConstraints() {
        let views = [horizontalStackView, favoritesButton]
        // Allow to specify autolayout constraints by setting .translatesAutoresizingMaskIntoConstraints to false
        views.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        // favoritesButton
        NSLayoutConstraint.activate([
            favoritesButton.topAnchor.constraint(equalTo: horizontalStackView.topAnchor),
            favoritesButton.leadingAnchor.constraint(equalTo: horizontalStackView.leadingAnchor),
            favoritesButton.trailingAnchor.constraint(equalTo: horizontalStackView.trailingAnchor),
        ])
        
        // horizontalStackView
        NSLayoutConstraint.activate([
            horizontalStackView.topAnchor.constraint(equalTo: self.topAnchor),
            horizontalStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            horizontalStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            horizontalStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        // scrollView
//        NSLayoutConstraint.activate([
//            scrollView.topAnchor.constraint(equalTo: self.topAnchor),
//            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
//            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
//            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
//        ])
    }
    
    // MARK: DELEGATE FUNCTIONS
    @objc private func buttonTapped(_ sender: UIButton) {
        guard let title = sender.titleLabel?.text else { return }
        favoritesViewDelegate?.buttonTapped(title: title)
    }
}
