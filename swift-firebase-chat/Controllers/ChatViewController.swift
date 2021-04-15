//
//  CharViewController.swift
//  swift-firebase-chat
//
//  Created by Сергей Смирнов on 24.03.2021.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {
    
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    let db = Firestore.firestore()
    
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        self.tableView.separatorColor = UIColor.init(white: 0, alpha: 0)
        
        // Do any additional setup after loading the view.
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign out", style: .plain, target: self, action: #selector(signOut))
        
        prepareSendButton()
        
        //Looks for single or multiple taps.
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
        loadMessages()
    }
    
    func loadMessages() {
        db.collection("messages").order(by: "timestamp").addSnapshotListener { (querySnapshot, error) in
            
            self.messages = []
            
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error!)")
                return
            }
            
            for doc in documents {
                let data = doc.data()
                if let messageSender = data["sender"] as? String, let messageBody = data["body"] as? String {
                    self.messages.append(Message(sender: messageSender, body: messageBody))
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    @IBAction func sendMessage(_ sender: UIButton) {
        if let messageSender = Auth.auth().currentUser?.email, let messageBody = messageTextField.text {
            // Add a new document with a generated ID
            db.collection("messages").addDocument(data: [
                "sender": messageSender,
                "body": messageBody,
                "timestamp": Date().timeIntervalSince1970
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Message added")
                    self.messageTextField.text = ""
                }
            }
        }
    }
    
    func prepareSendButton() {
        sendButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 4))
    }
    
    @objc func signOut() {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch {
            self.showSimpleError(with: error.localizedDescription)
        }
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension ChatViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let user = Auth.auth().currentUser
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! MessageCell
        
        cell.bodyLabel.text = message.body
        cell.senderLabel.text = message.sender
        
        if (message.sender == user?.email) {
            cell.messageView.backgroundColor = UIColor(named: "AppCyan")
            cell.messageView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -10).isActive = true
            cell.senderLabel.isHidden = true
        } else {
            cell.messageView.leadingAnchor.constraint(greaterThanOrEqualTo: cell.contentView.leadingAnchor, constant: 10).isActive = true
        }
        
        return cell
    }
    
}

extension ChatViewController: UITableViewDelegate {
}
