//
//  AddFriendCell.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-06-02.
//

import UIKit
import Firebase

protocol AddFriendCellDelegate: AnyObject {
    func addButtonPressed()
}

class AddFriendCell: UITableViewCell {

    var email:String = ""
    var username:String = ""
    var name:String = ""
    weak var delegate: AddFriendCellDelegate?
    
    
    @IBOutlet weak var friendUsername: UILabel!
    @IBOutlet weak var friendName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func AddButtonPressed(_ sender: UIButton) {
        LoadingManager.shared.showLoadingScreen()
            acceptFriend(email: email, name: name, username: username) { success, message in
                DispatchQueue.main.async {
                    LoadingManager.shared.hideLoadingScreen()
                    if success {
                        self.delegate?.addButtonPressed()
                    } else {
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "Error", message: "\(message ?? "Unknown error")", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            if let topViewController = UIApplication.shared.keyWindow?.rootViewController {
                                topViewController.present(alert, animated: true, completion: nil)
                            }
                        }
                    }}
            }
        }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func acceptFriend (email:String,name:String,username:String, completion: @escaping (Bool, String?) -> Void) {
        // Prepare the URL
        guard let currentUserEmail = Auth.auth().currentUser?.email else {
            completion( false,  "User email not found")
            return
        }
        
        guard let url = URL(string: "https://dot-call-a7ff3d8633ee.herokuapp.com/friends/addFriends/\(currentUserEmail)") else {
            completion(false, "Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "email": email,
            "username": username,
            "name": name
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch {
            completion(false, "Failed to serialize parameters")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(false, "Error: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(false, "Invalid response")
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(false, "HTTP status code: \(httpResponse.statusCode)")
                return
            }
            
            guard let data = data else {
                completion(false, "No data received")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                let success = json?["success"] as? Bool ?? false
                let message = json?["message"] as? String
                completion(success, message)
            } catch {
                completion(false, "Failed to parse response")
            }
        }
        
        task.resume()
    }
    
}
