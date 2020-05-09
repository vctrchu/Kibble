//
//  ViewController.swift
//  Kibble
//
//  Created by VICTOR CHU on 2019-09-07.
//  Copyright © 2019 Victor Chu. All rights reserved.
//

import UIKit
import AuthenticationServices
import FirebaseAuth
import GoogleSignIn
import Pastel

@available(iOS 13.0, *)
class SignInVC: UIViewController {

    // MARK: - Properties

    @IBOutlet weak var kibbleMainIcon: UIImageView!
    @IBOutlet weak var signInApple: UIButton!
    @IBOutlet weak var signInGoogle: UIButton!
    @IBOutlet var pastelView: PastelView!

    fileprivate var currentNonce: String?

    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        pastelView.startPastelPoint = .bottomLeft
        pastelView.endPastelPoint = .topRight
        pastelView.animationDuration = 3
        pastelView.setColors([#colorLiteral(red: 0.9882352941, green: 0.8901960784, blue: 0.5411764706, alpha: 1),#colorLiteral(red: 0.9529411765, green: 0.5058823529, blue: 0.5058823529, alpha: 1),#colorLiteral(red: 0.3843137255, green: 0.1529411765, blue: 0.4549019608, alpha: 1),#colorLiteral(red: 0.09019607843, green: 0.9176470588, blue: 0.8509803922, alpha: 1),#colorLiteral(red: 0.3764705882, green: 0.4705882353, blue: 0.9176470588, alpha: 1),#colorLiteral(red: 0.2588235294, green: 0.9019607843, blue: 0.5843137255, alpha: 1),#colorLiteral(red: 0.231372549, green: 0.6980392157, blue: 0.7215686275, alpha: 1)])
        pastelView.startAnimation()
        kibbleMainIcon.fadeIn(duration: 1, delay: 0) { (Bool) in
            self.signInApple.fadeIn(duration: 1, delay: 0) { (Bool) in
                self.signInGoogle.fadeIn(duration: 1, delay: 0) { (Bool) in
                }
            }
        }
    }

    // MARK: - Auto Constraints

    override func loadView() {
        super.loadView()
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [#colorLiteral(red: 0.9882352941, green: 0.8901960784, blue: 0.5411764706, alpha: 1),#colorLiteral(red: 0.9529411765, green: 0.5058823529, blue: 0.5058823529, alpha: 1)]
        gradientLayer.frame = view.bounds
        pastelView.layer.insertSublayer(gradientLayer, at: 0)

        kibbleMainIcon.translatesAutoresizingMaskIntoConstraints = false
        kibbleMainIcon.contentMode = UIView.ContentMode.scaleAspectFit
        kibbleMainIcon.alpha = 0
        NSLayoutConstraint.activate([
            kibbleMainIcon.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            kibbleMainIcon.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 170.adjusted)
        ])
        self.view.addSubview(kibbleMainIcon)

        signInApple.translatesAutoresizingMaskIntoConstraints = false
        signInApple.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
        signInApple.alpha = 0
        NSLayoutConstraint.activate([
            signInApple.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            signInApple.bottomAnchor.constraint(equalTo: signInGoogle.topAnchor, constant: -25.adjusted)
        ])
        signInApple.addTarget(self, action: #selector(appleSignInTapped), for: .touchUpInside)
        self.view.addSubview(signInApple)

        signInGoogle.translatesAutoresizingMaskIntoConstraints = false
        signInGoogle.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
        signInGoogle.alpha = 0
        NSLayoutConstraint.activate([
            signInGoogle.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            signInGoogle.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -100.adjusted)
        ])
        signInGoogle.addTarget(self, action: #selector(googleSignInTapped), for: .touchUpInside)
        //signInGoogle.addTarget(self, action: #selector(presentNextVC), for: .touchUpInside)
        self.view.addSubview(signInGoogle)
    }

    @objc func appleSignInTapped() {
        let nonce = Nonce.randomNonceString()
        currentNonce = nonce
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = Nonce.sha256(nonce)

        // pass the request to the initializer of the controller
        let authController = ASAuthorizationController(authorizationRequests: [request])

        // similar to delegate, this will ask the view controller
        // which window to present the ASAuthorizationController
        authController.presentationContextProvider = self

        // delegate functions will be called when user data is
        // successfully retrieved or error occured
        authController.delegate = self

        // show the Sign-in with Apple dialog
        authController.performRequests()
    }

    @objc func googleSignInTapped() {
        GIDSignIn.sharedInstance().signIn()
    }

    //    func presentNextVC() {
    @objc func presentNextVC() {
        let addYourPetVC = self.storyboard?.instantiateViewController(withIdentifier: "AddYourPetVC") as! AddYourPetVC
        addYourPetVC.modalPresentationStyle = .fullScreen
        addYourPetVC.isMotionEnabled = true
        addYourPetVC.motionTransitionType = .fade
        self.present(addYourPetVC, animated: true, completion: nil)
    }
}

// MARK: - Google Sign In Delegate

@available(iOS 13.0, *)
extension SignInVC: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        guard let auth = user.authentication else { return }
        let credentials = GoogleAuthProvider.credential(withIDToken: auth.idToken, accessToken: auth.accessToken)
        Auth.auth().signIn(with: credentials) { (authResult, error) in
            guard let user = authResult?.user else {
                print(error?.localizedDescription)
                return
            }
            let googleUser: GIDGoogleUser = GIDSignIn.sharedInstance()!.currentUser
            let userData: Dictionary<String, Any> = ["email": googleUser.profile.name!,
                                                     "fullName": googleUser.profile.email!]
            DataService.instance.updateUser(withUid: user.uid, withUserData: userData)
            self.presentNextVC()
        }
    }
}

// MARK: - Apple Sign In Delegate

@available(iOS 13.0, *)
extension SignInVC : ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate {

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        // return current view to put up authorization screen
        return self.view.window!
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonce,
                                                      accessToken: nil)

            Auth.auth().signIn(with: credential) { (authResult, error) in
                guard let user = authResult?.user else {
                    print(error?.localizedDescription)
                    return
                }
                print("********* SUCCESSFULLY SIGNED INTO FIREBASE WTIH APPLE **********")

                if let email = appleIDCredential.email {
                    // User has never signed in with this appleId once
                    let userData: Dictionary<String, Any> = ["email": email,
                                                             "fullName": (appleIDCredential.fullName?.givenName)! + " " + (appleIDCredential.fullName?.familyName)!]
                    DataService.instance.updateUser(withUid: user.uid, withUserData: userData)
                    self.presentNextVC()
                } else {
                    let uid = Auth.auth().currentUser!.uid
                    DataService.instance.retrieveAllPetsForUser(withUid: uid) { ([String : Any]) in }
                    DataService.instance.downloadPetIds()
                    DataService.instance.retrieveAllUserInfo(withUid: uid) {
                        let mealsVC = self.storyboard?.instantiateViewController(withIdentifier: "MealsVC") as! MealsVC
                        mealsVC.modalPresentationStyle = .fullScreen
                        mealsVC.isMotionEnabled = true
                        mealsVC.motionTransitionType = .fade
                        self.present(mealsVC, animated: true, completion: nil)
                    }
                }
            }
        }
    }
}



