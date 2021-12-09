//
//  DetailViewController.swift
//  Project 10-12
//
//  Created by User on 02.12.2021.
//

import UIKit

class DetailViewController: UIViewController {

    var selectImage:Person?
    
    @IBOutlet var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = getDocumentsDirectory().appendingPathComponent(selectImage!.image)
        imageView.image = UIImage(contentsOfFile: path.path)
    
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    func getDocumentsDirectory() -> URL{
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return path[0]
    }
}
