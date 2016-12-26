//
//  AlamofireManager.swift
//  myGymSwift
//
//  Created by SQLI51109 on 13/01/2016.
//  Copyright © 2016 julien gimenez. All rights reserved.
//

import Alamofire
import AlamofireImage
import SwiftyJSON

class AlamofireManager: NSObject {
    
    static let SharedInstance = AlamofireManager()
    let imageCache = AutoPurgingImageCache(
        memoryCapacity: 200 * 1024 * 1024,
        preferredMemoryUsageAfterPurge: 60 * 1024 * 1024
    )
    
    var token = ""
    
    let login_params            = NetworkConstants.login_parameters
    let post_token              = NetworkConstants.ip_server+NetworkConstants.post_token
    var get_recipes             = NetworkConstants.ip_server+NetworkConstants.get_recipes
    let get_order_recipes       = NetworkConstants.ip_server+NetworkConstants.order_recipe
    let updateRecipe            = NetworkConstants.ip_server+NetworkConstants.updateRecipe
    let uploadRecipe            = NetworkConstants.ip_server+NetworkConstants.uploadRecipe
    let downladImageRecipe      = NetworkConstants.ip_server+NetworkConstants.downloadImage

    func setChallenge(){
        
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            NetworkConstants.ip_server: .disableEvaluation
        ]
        
        let sessionManager = Alamofire.SessionManager(
            configuration: URLSessionConfiguration.default,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
        
        let delegate: Alamofire.SessionDelegate = sessionManager.delegate
        
        delegate.sessionDidReceiveChallenge = {
            session, challenge in
            var disposition: URLSession.AuthChallengeDisposition = .performDefaultHandling
            var credential: URLCredential?
            
            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
                disposition = URLSession.AuthChallengeDisposition.useCredential
                credential = URLCredential(trust: challenge.protectionSpace as! SecTrust)
            } else {
                if challenge.previousFailureCount > 0 {
                    disposition = .cancelAuthenticationChallenge
                } else {
                    credential = sessionManager.session.configuration.urlCredentialStorage?.defaultCredential(for: challenge.protectionSpace)
                    
                    if credential != nil {
                        disposition = .useCredential
                    }
                }
            }
            return (disposition, credential)
        }
        /*Alamofire.Manager.sharedInstance.delegate.sessionDidReceiveChallenge = { session, challenge in
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
        }*/
    }
    
    func getToken(_ completion: @escaping (Bool) -> Void) {
        if NetworkReachabilityManager.NetworkReachabilityStatus.notReachable == .notReachable {
            if (self.token != ""){
                completion(true)
            }
            else{
                print("Authentification : \(post_token)...")
                Alamofire.request(post_token, method: .post, parameters: login_params, encoding: JSONEncoding.default) .responseJSON{
                    response in
                    switch response.result {
                        
                    case .success:
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
                    case .failure(let error):
                        print("Request failed with error: \(error)")
                        completion(false)
                    }
                }
            }
        }
        else{
            completion(false)
        }
        
    }
    
    func downloadOrderedRecipes(_ category:String, completion: @escaping (_ recipes: JSON) -> Void) {
        let uriNews = get_recipes+token+NetworkConstants.filter_recipe+category
      
        Alamofire.request(uriNews,method: .get).responseJSON{
            response in
            
            switch response.result {
                
            case .success:
                if response.response!.statusCode == 200 {
                    completion(JSON(response.result.value!))
                } else {
                    print("Request failed with error: \(response.response!.statusCode)")
                    completion([])
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
    
    func putRecipe(_ recipe:Recipe,completion:@escaping (_ success:Bool)->Void){
        let params = recipe.toDic()
        let url = updateRecipe+token
        Alamofire.request(url, method: .put , parameters:params, encoding: JSONEncoding.default) .responseJSON{
            response in
            switch response.result {
                case .success:
                    if response.response!.statusCode == 200 {
                        completion(true)
                    } else {
                        print("Request failed with error: \(response.response!.statusCode)")
                        completion(false)
                    }
                case .failure(let error):
                    print("Request failed with error: \(error)")
                    completion(false)
                }
            }
        }
    
    func postRecipe(_ recipe:Recipe,completion:@escaping (_ success:Bool)->Void){
        let params = recipe.toDicPOST()
        let url = updateRecipe+token
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON{
            response in
            switch response.result {
            case .success:
                if response.response!.statusCode == 200 {
                    completion(true)
                } else {
                    print("Request failed with error: \(response.response!.statusCode)")
                    print("Request failed with error: \(response.debugDescription)")
                    
                    completion(false)
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
                completion(false)
            }
        }
    }
    
    func uploadImageRecipeNetwork(_ title:String, image:UIImage, completion:@escaping (_ success:Bool)->Void){
        let imageData = UIImageJPEGRepresentation(image, 0.5)!
        let fileName = title+".jpg"
        let url = uploadRecipe + token
        
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(imageData, withName: fileName, mimeType: "image/jpeg")
        },
            to: url,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.uploadProgress { progress in // main queue by default
                        print("Upload Progress: \(progress.fractionCompleted)")
                        DispatchQueue.main.async {
                            print("Async1")
                        }
                    }
                    upload.responseJSON { response in
                        DispatchQueue.main.async {
                            print("Async1")
                        }
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
        }
        )
    }
    

       /*Alamofire.upload(.POST,
            uploadRecipe + token,
            multipartFormData: { multipartFormData in
                multipartFormData.appendBodyPart(data: imageData, name: "file", fileName: title+".jpg", mimeType: "image/jpeg")
            },
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.progress { (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) in
                        print("Uploading Avatar \(totalBytesWritten) / \(totalBytesExpectedToWrite)")
                        dispatch_async(dispatch_get_main_queue(),{
                            /**
                            *  Update UI Thread about the progress
                            */
                        })
                    }
                    upload.responseJSON { (JSON) in
                        dispatch_async(dispatch_get_main_queue(),{
                            //Show Alert in UI
                            print("Avatar uploaded");
                            completion(success: true)
                        })
                    }
                    
                case .Failure(let encodingError):
                    //Show Alert in UI
                    print(encodingError);
                    completion(success: false)

                }
            }
        );*/
    
    
    func getNetworkImage(_ urlString: String, completion:@escaping (_ image:UIImage?, _ success:Bool)->Void){
        let urlStringWithoutSpace = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        let imagePath = downladImageRecipe+urlStringWithoutSpace!+"?access_token=" + token
        Alamofire.download(imagePath).responseData { response in
            switch response.result{
            case .success :
                if response.response!.statusCode == 200 {
                    if let data = response.result.value {
                        let image = UIImage(data: data)
                        completion(image, true)
                        self.cacheImage(image!, urlString: urlString)
                    }
                }
            case .failure(let error):
                print(error)
                completion(nil, false)
            }
        }
    }
    
    
    //MARK: = Image Caching
    
    func cacheImage(_ image: Image, urlString: String) {
        imageCache.add(image, withIdentifier: urlString)
    }
    
    func cachedImage(_ urlString: String) -> Image? {
        return imageCache.image(withIdentifier:(urlString))
    }
}
