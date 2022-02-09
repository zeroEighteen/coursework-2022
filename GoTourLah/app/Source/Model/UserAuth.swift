//
//  UserAuth.swift
//  Barg-InnoFest
//
//  Created by Ryan The on 2/9/20.
//  Copyright © 2020 Ryan The. All rights reserved.
//

import Foundation
import Firebase
import GoogleSignIn

class UserAuth {
    
    static func signIn() {
        GIDSignIn.sharedInstance().signIn()
    }
    
    static func signOut() {
        do {
            try Auth.auth().signOut()
            print("Success")
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        return
    }
    
    var profileImage: UIImage {
        if let url = Auth.auth().currentUser?.photoURL {
            do {
                let imageData = try Data(contentsOf: url)
                return UIImage(data: imageData) ?? K.profilePlaceholderImage
            } catch let error as NSError {
                print("ERROR: %@\(error)")
            }
        }
        return K.profilePlaceholderImage
    }
    
    var isAdmin: Bool {
        stallOwner != nil
    }
    
    var stallOwner: StallOwner? {
        K.stallOwners.filter { $0.uid == Auth.auth().currentUser?.uid }[safe: 0] ?? nil
    }
}
