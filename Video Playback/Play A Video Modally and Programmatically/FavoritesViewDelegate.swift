//
//  FavoritesViewDelegate.swift
//  AVPlayerLayer Video Playback
//
//  Created by Sam LoBue on 5/30/20.
//  Copyright © 2020 DjangoEarnhardt. All rights reserved.
//

import UIKit

/// Allow parent view to tap a FavoritesView button, then seek to that time
protocol FavoritesViewDelegate: class {
    func buttonTapped(title: String) 
}
