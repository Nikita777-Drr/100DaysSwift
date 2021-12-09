//
//  ViewController.swift
//  Project 10
//
//  Created by User on 22.11.2021.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var people = [Person]()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
        
        let defaults = UserDefaults.standard
        
        if let savedPeople = defaults.object(forKey: "people") as? Data{
            let jsonDecode = JSONDecoder()
            do{
                people = try jsonDecode.decode([Person].self, from: savedPeople)
            } catch{
                print("Failed to saved people.")
            }
        }
    }
    
    @objc func addNewPerson(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let ac = UIAlertController(title: "Photo or Camera?", message: nil, preferredStyle: .actionSheet)
            ac.addAction(UIAlertAction(title: "Photo", style: .cancel){[weak self, weak ac] action in
                self?.showCamera(fromCamera: false)
            })
            ac.addAction(UIAlertAction(title: "Camera", style: .cancel){[weak self, weak ac]action in
                self?.showCamera(fromCamera: true)
            })
        }else{
            self.showCamera(fromCamera: false)
        }
    }
    func showCamera(fromCamera:Bool){
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate  = self
        if fromCamera{
            picker.sourceType = .camera
        }
        present(picker,animated: true)
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
            fatalError("Error")
        }
        let person = people[indexPath.item ]
        cell.name.text = person.name
        
        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var person = people[indexPath.item]
        if person.name == "Unknown"{
            
            let ac = UIAlertController(title: "Rename person", message: nil, preferredStyle: .alert)
            ac.addTextField()
            
            ac.addAction(UIAlertAction(title: "cancel", style: .cancel))
            
            ac.addAction(UIAlertAction(title: "ok", style: .default){[weak self, weak ac] action in
                guard let newValue = ac?.textFields?[0].text else {return }
                person.name = newValue
                self?.collectionView.reloadData()
                self?.save()
            })
            present(ac, animated: true)
        }else if person.name != "Unknown"{
            let ac = UIAlertController(title: "Rename or delete?", message: nil, preferredStyle: .alert)
            ac.addTextField()
            ac.addAction(UIAlertAction(title: "Rename", style: .default){[weak self, weak ac] action in
                guard let newValue =  ac?.textFields?[0].text else {return}
                person.name = newValue
                self?.collectionView.reloadData()
                self?.save()
            })
            ac.addAction(UIAlertAction(title: "Delete", style: .default){[weak self, weak ac] action in
                self?.people.remove(at: indexPath.item)
                self?.collectionView.deleteItems(at: [indexPath])
                self?.save()
            })
            present(ac, animated: true)
        }
    }
    func imagePickerController(_ picker:UIImagePickerController, didFinishPickingMediaWithInfo info:[UIImagePickerController.InfoKey:Any]){
        guard let image = info[.editedImage] as? UIImage else {return}
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        if let jpegData = image.jpegData(compressionQuality: 0.8){
            try? jpegData.write(to:imagePath)
            
        }
        dismiss(animated: true)
        
        let person = Person(name: "Unknown", image: imageName)
        people.append(person)
        collectionView.reloadData()
        save()
    }
    func getDocumentsDirectory() -> URL{
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return path[0]
    }
    func save(){
        let jsonEncecode  = JSONEncoder()
        if let saveData = try? jsonEncecode.encode(people){
            let defaults  = UserDefaults.standard
            defaults.set(saveData, forKey: "people")
            
        }else {
            print("Failed to save people")
        }
    }

}

