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
    let get_news                = NetworkConstants.ip_server+NetworkConstants.get_news
    let get_ordered_news        = NetworkConstants.order_news
    let get_sports              = NetworkConstants.ip_server+NetworkConstants.get_sports
    let get_sports_descriptions = NetworkConstants.ip_server+NetworkConstants.get_sports_descritptions

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
    
    func downloadOrderedNews(completion: (news: JSON) -> Void) {
       
        let uriNews = get_news+token+get_ordered_news
        //print("Get news : \(uriNews)...")
        Alamofire.request(.GET,uriNews).responseJSON{
            response in
            
            switch response.result {
                
            case .Success:
                if response.response!.statusCode == 200 {
                    print("News ok")
                    //print("...News ok : \(response.result.value)")
                    completion(news:JSON(response.result.value!))
                } else {
                    print("Request failed with error: \(response.response!.statusCode)")
                    completion(news:[])
                }
            case .Failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
    
    func downloadSports(completion: (sports: JSON) -> Void) {
        
        let uriSports = get_sports+token
        //print("Get news : \(uriNews)...")
        Alamofire.request(.GET,uriSports).responseJSON{
            response in
            
            switch response.result {
                
            case .Success:
                if response.response!.statusCode == 200 {
                    print("Sports ok")
                    //print("...Sports ok : \(response.result.value)")
                    completion(sports:JSON(response.result.value!))
                } else {
                    print("Request failed with error: \(response.response!.statusCode)")
                    completion(sports:[])
                }
            case .Failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
    
    func downloadSportsDescriptions(completion: (sportsDescriptions: JSON) -> Void) {
        
        let uriSportsDescriptions = get_sports_descriptions+token
        //print("Get news : \(uriNews)...")
        Alamofire.request(.GET,uriSportsDescriptions).responseJSON{
            response in
            
            switch response.result {
                
            case .Success:
                if response.response!.statusCode == 200 {
                    print("Sports descriptions ok")
                    //print("...Sports descriptions ok : \(response.result.value)")
                    completion(sportsDescriptions:JSON(response.result.value!))
                } else {
                    print("Request failed with error: \(response.response!.statusCode)")
                    completion(sportsDescriptions:[])
                }
            case .Failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
}