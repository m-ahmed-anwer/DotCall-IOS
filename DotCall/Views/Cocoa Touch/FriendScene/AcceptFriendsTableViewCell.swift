//
//  AcceptFriendsTableViewCell.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-06-03.
//

import UIKit
import Firebase

protocol AcceptFriendCellDelegate: AnyObject {
    func acceptButtonPressed(atIndex index: Int)
}

class AcceptFriendsTableViewCell: UITableViewCell {

    var email:String = ""
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var name: UILabel!
    weak var delegate: AcceptFriendCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


    @IBAction func AddButtonPerform(_ sender: Any) {
        LoadingManager.shared.showLoadingScreen()
        acceptFriend(email: email) { success, message in
            DispatchQueue.main.async {
                LoadingManager.shared.hideLoadingScreen()
                if success {
                    self.delegate?.acceptButtonPressed(atIndex: self.tag)
                } else {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Error", message: "\(message ?? "Unknown error")", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        if let topViewController = UIApplication.shared.keyWindow?.rootViewController {
                            topViewController.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
    @IBOutlet weak var cancelButton: UIButton!
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    private func acceptFriend(email:String, completion: @escaping (Bool, String?) -> Void) {
        // Prepare the URL
        guard let currentUserEmail = Auth.auth().currentUser?.email else {
            completion( false,  "User email not found")
            return
        }
        
        guard let url = URL(string: "https://dot-call-a7ff3d8633ee.herokuapp.com/friends/acceptFriend") else {
            completion(false, "Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "email": email,
            "acceptingUserEmail": currentUserEmail
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
