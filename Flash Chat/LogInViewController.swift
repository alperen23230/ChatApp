//
//  LogInViewController.swift
//  Flash Chat



import UIKit
import Firebase
import SVProgressHUD
import GoogleSignIn


class LogInViewController: UIViewController ,GIDSignInUIDelegate,GIDSignInDelegate{

    //Google sign in button
    let googleButton = GIDSignInButton()
    
    //Textfields pre-linked with IBOutlets
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance()?.delegate = self
    
        setupGoogleButtons()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    //Google delegate methods
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any])
        -> Bool {
            return GIDSignIn.sharedInstance().handle(url,
                                                     sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                     annotation: [:])
    }
    
    func googleButtonTapped(_ sender:   Any){
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        SVProgressHUD.show()
        
        if let err = error {
            SVProgressHUD.dismiss()
            print("Error about sign in with google Error:\(err)")
            return
        }
        
        guard let idToken = user.authentication.idToken else { return }
        guard let accessToken = user.authentication.accessToken else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                       accessToken: accessToken)
        
        Auth.auth().signInAndRetrieveData(with: credential) { (user, error) in
            if let err = error {
                SVProgressHUD.dismiss()
                print("Error about sign in with google Error:\(err)")
                return
            }
            else{
                print("Login Successful")
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "goToChat", sender: self)
            }
            
        }
        
    }
    
    
    //Setup Google sign in button
    
    func setupGoogleButtons(){
        //Add Google Sign In Button
        googleButton.frame = CGRect(x: 16, y: 116+190, width: view.frame.width - 32, height: 50)
        view.addSubview(googleButton)
        
        GIDSignIn.sharedInstance()?.uiDelegate = self
    }
   
    //Normal Login button press
    
    @IBAction func logInPressed(_ sender: AnyObject) {

        SVProgressHUD.show()
        
        //TODO: Log in the user
        Auth.auth().signIn(withEmail: emailTextfield.text!, password: passwordTextfield.text!) {
            (user,error ) in
            if error != nil{
                SVProgressHUD.dismiss()
                print(error!)
            }
            else{
                print("Login Successful")
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "goToChat", sender: self)
            }
            
        }
    }
    


    
}  
