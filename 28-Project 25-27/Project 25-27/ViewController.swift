//
//  ViewController.swift
//  Project 25-27
//
//  Created by User on 04.01.2022.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var textTop: UIButton!
    @IBOutlet var textBottom: UIButton!
    
    @IBOutlet var imageTop: UIImageView!
    @IBOutlet var imageBottom: UIImageView!
    @IBOutlet var importImage: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(sendMemImage))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(warningAddImage))
        importImage.addTarget(self, action: #selector(addImage), for: .touchUpInside)
        importImage.layer.cornerRadius = 12
        
        textTop.addTarget(self, action: #selector(addTextTop), for: .touchUpInside)
        textTop.layer.cornerRadius = 12
        
        textBottom.addTarget(self, action: #selector(addTextBottom), for: .touchUpInside)
        textBottom.layer.cornerRadius = 12
        
        warningAddImage()
        
        _ = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(addTextTop), userInfo: nil, repeats: false)
    }
    @objc func warningAddImage(){
        let ac = UIAlertController(title: "Which action to add?", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Add image", style: .default){[weak self] _ in
            self?.addImage()
        })
        ac.addAction(UIAlertAction(title: "Add text top", style: .default){[weak self] _ in
            self?.addTextTop()
        })
        ac.addAction(UIAlertAction(title: "Add text bottom", style: .default){[weak self] _ in
            self?.addTextBottom()
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .default))
        present(ac, animated: true)
    }
    
    @objc func sendMemImage(){
        let message = "You can send image now!"
        
        let actVC = UIActivityViewController(activityItems: [message], applicationActivities: [])
        actVC.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(actVC, animated: true)
    }
    @objc func addImage(){
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        
        dismiss(animated: true)
        imageView.image = image
    }
    
    @objc func addTextTop(){
        let ac = UIAlertController(title: "Enter text Top", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Add text", style: .default){[weak self, weak ac] _ in
            guard let textTop = ac?.textFields?[0].text else {return}
            self?.drawText(textAdd: textTop, position: CGRect(x: 153, y: 50, width: 100, height: 100), images: (self?.imageTop)!)
        } )
        ac.addAction(UIAlertAction(title: "Not add", style: .cancel))
        present(ac, animated: true)
        
        _ = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(addTextBottom), userInfo: nil, repeats: false)
    }
    
    @objc func addTextBottom(){
        let ac = UIAlertController(title: "Enter text Bottom", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Add text", style: .default){[weak self, weak ac] _ in
            guard let textTop = ac?.textFields?[0].text else {return}
            self?.drawText(textAdd: textTop, position: CGRect(x: 153, y: 50, width: 100, height: 100), images: (self?.imageBottom)!)
        } )
        ac.addAction(UIAlertAction(title: "Not add", style: .cancel))
        present(ac, animated: true)
    }
    
    func drawText(textAdd:String, position:CGRect, images:UIImageView){
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 414, height: 128))
        
        let image = renderer.image {ctx in
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attributs:[NSAttributedString.Key:Any] = [
                .font:UIFont.systemFont(ofSize: 36),
                .paragraphStyle:paragraphStyle,
                .foregroundColor:UIColor.white
            ]
            
            let string = textAdd
            let attributedString = NSAttributedString(string: string, attributes: attributs)
            
            attributedString.draw(with: position, options: .usesLineFragmentOrigin, context: nil)
            
        }
        images.image = image
    }


}

