//
//  MatchViewController.swift
//  Tindog
//
//  Created by Jorge Gastelum on 19/03/18.
//  Copyright © 2018 Jorge Gastelum. All rights reserved.
//

import UIKit

class MatchViewController: UIViewController {

    @IBOutlet weak var copyMatchLbl: UILabel!
    @IBOutlet weak var firstUserMatchImage: UIImageView!
    @IBOutlet weak var secondUserMatchImage: UIImageView!
    @IBOutlet weak var doneBtn: UIButton!
    
    
    var currentUserProfile: UserModel?
    var currentMatch: MatchModel?
    

    @IBAction func doneBtnAction(_ sender: Any) {
        if let currentMatch = self.currentMatch {
            if currentMatch.matchIsAccepted {
                
            } else {
                DatabaseService.instance.updateFirebaseDBMatch(uid: currentMatch.uid)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.firstUserMatchImage.round()
        self.secondUserMatchImage.round()
        if let match = self.currentMatch {
            print("match: \(match)")
            if let profile = self.currentUserProfile {
                var secondID = ""
                if profile.uid == match.uid {
                    secondID = match.uid2
                } else {
                    secondID = match.uid
                }
                
                DatabaseService.instance.getUserProfile(uid: secondID, handler: { (secondUser) in
                    if let secondUser = secondUser {
                        if profile.uid == match.uid {
                            self.firstUserMatchImage.sd_setImage(with: URL(string: profile.profileImage), completed: nil)
                            self.secondUserMatchImage.sd_setImage(with: URL(string: secondUser.profileImage), completed: nil)
                            self.copyMatchLbl.text = "Esperando a \(secondUser.displayName)"
                            self.doneBtn.alpha = 0
                        } else {
                            self.firstUserMatchImage.sd_setImage(with: URL(string: secondUser.profileImage), completed: nil)
                            self.secondUserMatchImage.sd_setImage(with: URL(string: profile.profileImage), completed: nil)
                            self.copyMatchLbl.text = "Tu mascota le gusta a \(secondUser.displayName)"
                            self.doneBtn.alpha = 1
                        }
                    }
                })
                
                self.secondUserMatchImage.sd_setImage(with: URL(string: profile.profileImage), completed: nil)
                
            }
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
