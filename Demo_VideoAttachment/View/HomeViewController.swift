//
//  HomeViewController.swift
//  Demo_VideoAttachment
//
//  Created by Duy Tran N. on 3/25/19.
//  Copyright © 2019 MBA0204. All rights reserved.
//

import UIKit

final class HomeViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var galleryButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!      // TODO: - NOT USE YET

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
}

// MARK: -Extension HomeViewController
extension HomeViewController {

    // MARK: Private
    private func configureUI() {
        galleryButton.addTarget(self, action: #selector(openGalleryButtonTapped), for: .touchUpInside)
    }

    @objc private func openGalleryButtonTapped() {
        let videoGalleryVC = VideoGalleryViewController()
        navigationController?.pushViewController(videoGalleryVC, animated: true)
    }
}
