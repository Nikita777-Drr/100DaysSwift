//
//  ViewController.swift
//  Project 10-12
//
//  Created by User on 02.12.2021.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var people = [Person]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
        
        let defaults = UserDefaults.standard
        if let savePeople = defaults.object(forKey: "people") as? Data{
            let jsonDecode = JSONDecoder()
            
            do{
                people = try jsonDecode.decode([Person].self, from: savePeople)
            }catch{
                print("Error")
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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Person", for: indexPath) as? PersonCell else {
            fatalError("Error")
        }
        let person = people[indexPath.item ]
        cell.name.text = person.name
        
        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.imageViews.image = UIImage(contentsOfFile: path.path)
        cell.imageViews.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageViews.layer.borderWidth = 2
        cell.imageViews.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let person = people[indexPath.row]
        
        if person.name == "Unknown"{
            let ac = UIAlertController(title: "Rename or Delete person?", message: nil, preferredStyle: .alert)
            ac.addTextField()
            ac.addAction(UIAlertAction(title: "Rename", style: .default){[weak self, weak ac] _ in
                guard let newName = ac?.textFields?[0].text else {return}
                person.name = newName
                self?.tableView.reloadData()
                self?.save()
            })
            ac.addAction(UIAlertAction(title: "Delete", style: .default){[weak self, weak ac] _ in
                self?.people.remove(at: indexPath.row)
                self?.tableView.deleteRows(at: [indexPath], with: .none)
                self?.save()
            })
            present(ac, animated: true)
        }else if person.name != "Unknown"{
            if let sb = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController{
                let person = people[indexPath.row]
                sb.selectImage = person
                navigationController?.pushViewController(sb, animated: true)
            }
            
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
        tableView.reloadData()
        save()
    }
    func getDocumentsDirectory() -> URL{
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return path[0]
    }
    func save(){
        let jsonEncoder = JSONEncoder()
        if let saveData = try? jsonEncoder.encode(people){
            let defaults = UserDefaults.standard
            defaults.set(saveData, forKey: "people")
        }else{
            print("Error")
        }
            
    }
}

