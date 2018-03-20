//
//  LoginViewController.swift
//  Tindog
//
//  Created by Jorge Gastelum on 11/03/18.
//  Copyright © 2018 Jorge Gastelum. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var loginCopyLbl: UILabel!
    @IBOutlet weak var subLoginBtn: UIButton!
    var registerMode = true
    
    @IBAction func closeBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func showAlert(title: String, message: String) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertView, animated: true, completion: nil)
    }
    
    @IBAction func loginActionBtn(_ sender: Any) {
        if self.emailTextField.text == "" || self.passwordTextField.text == "" {
            self.showAlert(title: "Error", message: "Alguno de los campos está vacío")
        } else {
            if let email = self.emailTextField.text {
                if let password = self.passwordTextField.text {
                    if registerMode {
                        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                            if error != nil {
                                self.showAlert(title: "Error", message: error!.localizedDescription)
                            } else {
                                print("Cuenta creada")
                                if let user = user {
                                    let userData = ["provider": user.providerID, "email": user.email!, "profileImage": "https://i.imgur.com/OM6nGyP.jpg", "displayName":  "Perro Perrón del Oscar", "userIsOnMatch": false] as [String: Any]
                                    
                                    DatabaseService.instance.createFirebaseDBUser(uid: user.uid, userData: userData)
                                }
                            }
                        })
                    } else {
                        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                            if error != nil {
                                self.showAlert(title: "Error", message: error!.localizedDescription)
                            } else {
                                print("Login correcto")
                                self.dismiss(animated: true, completion: nil)
                            }
                        })
                    }
                }
            }
        }
    }
    
    @IBAction func subLoginActionBtn(_ sender: Any) {
        if self.registerMode {
            self.loginBtn.setTitle("Login", for: .normal)
            self.loginCopyLbl.text = "Eres Nuevo?"
            self.subLoginBtn.setTitle("Registrate", for: .normal)
            self.registerMode = false
        } else {
            self.loginBtn.setTitle("Crear Cuenta", for: .normal)
            self.loginCopyLbl.text = "Ya tienes cuenta?"
            self.subLoginBtn.setTitle("Login", for: .normal)
            self.registerMode = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.bindKeyboard()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        self.view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
