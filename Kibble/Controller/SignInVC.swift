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

@available(iOS 13.0, *)
class SignInVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var kibbleMainIcon: UIImageView!
    @IBOutlet weak var signInApple: UIButton!
    @IBOutlet weak var signInGoogle: UIButton!

    fileprivate var currentNonce: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        //setUpAppearance()

    }

    override func loadView() {
        super.loadView()
        self.view.addSubview(kibbleMainIcon)
        self.view.addSubview(signInApple)
        self.view.addSubview(signInGoogle)

        kibbleMainIcon.translatesAutoresizingMaskIntoConstraints = false
        kibbleMainIcon.contentMode = UIView.ContentMode.scaleAspectFit
        NSLayoutConstraint.activate([
            kibbleMainIcon.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            kibbleMainIcon.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 170.adjusted)
        ])

        signInApple.translatesAutoresizingMaskIntoConstraints = false
        signInApple.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
        NSLayoutConstraint.activate([
            signInApple.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            signInApple.bottomAnchor.constraint(equalTo: signInGoogle.topAnchor, constant: -25.adjusted)
        ])
        signInApple.addTarget(self, action: #selector(appleSignInTapped), for: .touchUpInside)

        signInGoogle.translatesAutoresizingMaskIntoConstraints = false
        signInGoogle.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
        NSLayoutConstraint.activate([
            signInGoogle.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            signInGoogle.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -100.adjusted)
        ])
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

}

@available(iOS 13.0, *)
extension SignInVC : ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate{

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

                let userData: Dictionary<String, Any> = ["email": appleIDCredential.email!,
                                                         "fullName": (appleIDCredential.fullName?.givenName)!]
                DataService.instance.createDBUser(uid: user.uid, userData: userData)

                let mealsVC = self.storyboard?.instantiateViewController(withIdentifier: "AddYourPetVC")
                mealsVC?.modalPresentationStyle = .fullScreen
                mealsVC?.isMotionEnabled = true
                mealsVC?.motionTransitionType = .fade
                self.present(mealsVC!, animated: true, completion: nil)
            }
        }
    }

}



