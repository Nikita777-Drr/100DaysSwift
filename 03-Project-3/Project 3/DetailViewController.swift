//
//  DetailViewController.swift
//  Project 3
//
//  Created by User on 04.11.2021.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var selectemImage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = selectemImage
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(largeTapped))
        
        
        if let imageToLoad = selectemImage{
            imageView.image = UIImage(named: imageToLoad)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    @objc func largeTapped(){
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8)else {
            print("Not found image!")
            return
        }
        let message = "Hello, you can sent photo!"
        let vc = UIActivityViewController(activityItems: [image, message, selectemImage ?? ""], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true, completion: nil)
    }
}
