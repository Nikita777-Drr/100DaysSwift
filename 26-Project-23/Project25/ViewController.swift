//
//  ViewController.swift
//  Project25
//
//  Created by User on 31.12.2021.
//

import UIKit
import MultipeerConnectivity

class ViewController: UICollectionViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, MCSessionDelegate, MCBrowserViewControllerDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .notConnected:
            //challenge 1
            let ac = UIAlertController(title: "Disconnect", message: peerID.displayName, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            
        case .connecting:
            print("Connected: \(peerID.displayName)")
        case .connected:
            print("Connected: \(peerID.displayName)")
        @unknown default:
            print("Unknown state received: \(peerID.displayName)")
        }
    
        
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        DispatchQueue.main.async {[weak self] in
            if let image = UIImage(data: data){
                self?.images.insert(image, at: 0)
                self?.collectionView.reloadData()
            }else{
                
            }
            
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        //no
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        //no
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        //no
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    
    var images = [UIImage]()
    var peerID = MCPeerID(displayName: UIDevice.current.name)
    var mcSession:MCSession?
    var mcAdvertiserAssistant:MCAdvertiserAssistant?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Selfie Share"
        let importPic = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(importPicture))
        let viewPeers =  UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(listPeers))
        navigationItem.rightBarButtonItems = [importPic, viewPeers]
        
        let showConnection = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showConnectionPrompt))
        let showMessage = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(sendMessage))
        
        navigationItem.leftBarButtonItems = [showConnection, showMessage]
        
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession?.delegate = self
    }
    
    @objc func importPicture(){
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        
        dismiss(animated: true)
        images.insert(image, at: 0)
        collectionView.reloadData()
        
        if let imageData = image.pngData(){
            sendData(imageData)
        }

    }
    func sendData(_ data:Data){
        guard let mcSession = mcSession else {return}
        if mcSession.connectedPeers.count > 0{
            if mcSession.connectedPeers.count > 0{
                do{
                    try mcSession.send(data, toPeers: mcSession.connectedPeers, with: .reliable)
                }catch{
                    let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    present(ac, animated: true)
                }
            }
                
        }
    }
    //challenge 2
    @objc func sendMessage(){
        let ac = UIAlertController(title: "Message", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "Send", style: .default){[weak self, weak ac] _ in
            guard let text = ac?.textFields![0].text else {return}
            let dataText = Data(text.utf8)
            self?.sendData(dataText)
        })
        present(ac, animated: true)
    }
    //challenge3
    @objc func listPeers(){
        var list = ""
        var count = false
        if let mcSession = mcSession {
            if mcSession.connectedPeers.count > 0{
                count = true
                for peer in mcSession.connectedPeers {
                    list += "\n\(peer.displayName)"
                }
            }
        }
        if !count{
            list += "No peer connect"
        }
        
        let ac = UIAlertController(title: "Connectiong peers", message: list, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @objc func showConnectionPrompt(){
        let ac = UIAlertController(title: "Connect to other", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Host a session", style: .default, handler: startHosting))
        ac.addAction(UIAlertAction(title: "Join a session", style: .default, handler: joinSession))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageView", for: indexPath)

        if let imageView = cell.viewWithTag(1000) as? UIImageView {
            imageView.image = images[indexPath.item]
        }

        return cell
    }
    func startHosting(action:UIAlertAction){
        guard let mcSession = mcSession else {return}
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "hws-Project25", discoveryInfo: nil, session: mcSession)
        mcAdvertiserAssistant?.start()
    }
    func joinSession(action:UIAlertAction){
        guard let mcSession = mcSession else {return}
        let mcBrows = MCBrowserViewController(serviceType: "hws-Project25", session: mcSession)
        mcBrows.delegate = self
        present(mcBrows, animated: true)
    }

}

