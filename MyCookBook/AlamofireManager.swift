//
//  AlamofireManager.swift
//  myGymSwift
//
//  Created by SQLI51109 on 13/01/2016.
//  Copyright © 2016 julien gimenez. All rights reserved.
//

import Alamofire
import SwiftyJSON

class AlamofireManager: NSObject {
    
    static let SharedInstance = AlamofireManager()
    
    var token = ""
    
    let login_params            = NetworkConstants.login_parameters
    let post_token              = NetworkConstants.ip_server+NetworkConstants.post_token
    var get_recipes             = NetworkConstants.ip_server+NetworkConstants.get_recipes
    let get_order_recipes       = NetworkConstants.ip_server+NetworkConstants.order_recipe
    let updateRecipe            = NetworkConstants.ip_server+NetworkConstants.updateRecipe

    func setChallenge(){
    
        Alamofire.Manager.sharedInstance.delegate.sessionDidReceiveChallenge = { session, challenge in
            var disposition: NSURLSessionAuthChallengeDisposition = .PerformDefaultHandling
            var credential: NSURLCredential?
            
            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
                disposition = NSURLSessionAuthChallengeDisposition.UseCredential
                credential = NSURLCredential(forTrust: challenge.protectionSpace.serverTrust!)
            } else {
                if challenge.previousFailureCount > 0 {
                    disposition = .CancelAuthenticationChallenge
                } else {
                    credential = Alamofire.Manager.sharedInstance.session.configuration.URLCredentialStorage?.defaultCredentialForProtectionSpace(challenge.protectionSpace)
                    
                    if credential != nil {
                        disposition = .UseCredential
                    }
                }
            }
            return (disposition, credential)
        }
    }
    
    func getToken(completion: (Bool) -> Void) {
        if (self.token != ""){
            completion(true)
        }
        else{
            print("Authentification : \(post_token)...")
            Alamofire.request(.POST, post_token, parameters: login_params, encoding: .JSON) .responseJSON{
                response in
                switch response.result {
                    
                case .Success:
                    if response.response!.statusCode == 200 {
                        let credential = JSON(response.result.value!)
                        print("Token ok")
                        //print("...Token ok: \(credential)")
                        self.token = credential["id"].stringValue
                        completion(true)
                        
                    } else {
                        print("Request failed with error: \(response.response!.statusCode)")
                        completion(false)
                    }
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                    completion(false)
                }
            }
        }
    }
    
    func downloadOrderedRecipes(category:String, completion: (recipes: JSON) -> Void) {
        let uriNews = get_recipes+token+NetworkConstants.filter_recipe+category
      
        Alamofire.request(.GET,uriNews).responseJSON{
            response in
            
            switch response.result {
                
            case .Success:
                if response.response!.statusCode == 200 {
                    completion(recipes:JSON(response.result.value!))
                } else {
                    print("Request failed with error: \(response.response!.statusCode)")
                    completion(recipes:[])
                }
            case .Failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
    
    func putRecipe(recipe:Recipe,completion:(success:Bool)->Void){
        let params = recipe.toDic()
        Alamofire.request(.PUT, updateRecipe+token, parameters:params, encoding: .JSON) .responseJSON{
            response in
            switch response.result {
                case .Success:
                    if response.response!.statusCode == 200 {
                        completion(success: true)
                    } else {
                        print("Request failed with error: \(response.response!.statusCode)")
                        completion(success: false)
                    }
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                    completion(success: false)
                }
            }
        }
    
    func postRecipe(recipe:Recipe,completion:(success:Bool)->Void){
        let params = recipe.toDicPOST()
        Alamofire.request(.POST, updateRecipe+token, parameters:params, encoding: .JSON) .responseJSON{
            response in
            switch response.result {
            case .Success:
                if response.response!.statusCode == 200 {
                    completion(success: true)
                } else {
                    print("Request failed with error: \(response.response!.statusCode)")
                    print("Request failed with error: \(response.debugDescription)")

                    completion(success: false)
                }
            case .Failure(let error):
                print("Request failed with error: \(error)")
                completion(success: false)
            }
        }
    }
}