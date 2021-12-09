//
//  ViewController.swift
//  Project 1
//
//  Created by User on 28.10.2021.
//

import UIKit

class ViewController: UITableViewController {
    var pictures = [String]()
    var score = [String:Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm viewer"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shapeTapped))
        performSelector(inBackground: #selector(gcdLod), with: nil)
        
        let defaults = UserDefaults.standard
        score = defaults.object(forKey: "Score") as? [String:Int] ?? [String:Int]()
        
    }
    @objc func gcdLod(){
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nssl"){
                self.pictures.append(item)
            }
        }
        print(self.pictures)
        tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
    }
    override func tableView(_ tableView:UITableView, numberOfRowsInSection section: Int)-> Int{
        return pictures.count
    }
    override func tableView(_ tableView:UITableView, cellForRowAt indexPath:IndexPath)->UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Image",for:indexPath)
        pictures.sort(by: <)
        cell.textLabel?.text = pictures[indexPath.row]
        cell.detailTextLabel?.text = "Views: \(score[pictures[indexPath.row], default: 0])"
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController{
            vc.selectedImage = pictures[indexPath.row]
            score[pictures[indexPath.row],default:0] += 1
  
            DispatchQueue.global().async { [weak self] in
                self?.saveScore()
                DispatchQueue.main.async {
                    self?.navigationController?.pushViewController(vc, animated: true)
                    self?.tableView.reloadRows(at: [indexPath], with: .none)
                }
            }
        }
        
        
    }
    @objc func shapeTapped(){
        let message = "Hello, you can send photo your friend!"
        
        let vc = UIActivityViewController(activityItems: [message], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true, completion: nil)
    }
    func saveScore(){
        let defaults = UserDefaults.standard
        defaults.set(score, forKey: "Score")
    }

}

