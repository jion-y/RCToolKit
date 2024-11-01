//
//  RCAppleLoginManager.swift
//  Alamofire
//
//  Created by yoyo on 2024/10/22.
//

import Foundation
import AuthenticationServices

open class AppleLoginManager {
    typealias CompletedBlock = (ASAuthorization?,Error?)->Void
    public weak presentationContextProvider: ASAuthorizationControllerPresentationContextProviding?
    private copy var compeleted:CompletedBlock?
    public init() {}
    
    public func login(completed:CompletedBlock?) {
        self.compeleted = completed
        let nonce = String.rc.randomNonceString()
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = nonce.rc.sha256()
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self.presentationContextProvider
        authorizationController.performRequests()
    }
    
}
extension AppleLoginManager:ASAuthorizationControllerDelegate {
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        self.compeleted?(nil,error)
        
    }
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        self.compeleted?(authorization,nil)
    }
}
