//
//  Recipe.swift
//  MyCookBook
//
//  Created by Anthony MARQUET on 16/01/2016.
//  Copyright © 2016 MARQUET. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class Recipe: Object {
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
    dynamic var id = ""
    dynamic var title = ""
    dynamic var imagePath = ""
    dynamic var date = ""
    dynamic var preparation = ""
    dynamic var ingredients = ""
    dynamic var tps_preparation = ""
    dynamic var tps_cuisson = ""
    dynamic var categorie = ""
    dynamic var nb_personne = ""
    dynamic var lastUpdated = ""
    
    override class func primaryKey() -> String {
        return "id"
    }
    
    func setData(_ dictionary: JSON) -> Recipe{
        
        id                 = dictionary["id"].stringValue
        title              = dictionary["title"].stringValue
        categorie          = dictionary["categorie"].stringValue
        
        //Gestion  image : Si image non présente dans l'appel WS, on entre en base l'image par de la catégorie corespodnante
        if(dictionary["image"].stringValue == ""){
            if(categorie == "1"){
                imagePath          = "placeholder_categorie1"
            }
            else{
                imagePath          = "placeholder_categorie2"
            }
        }
        else{
            imagePath          = dictionary["image"].stringValue
        }
        //Fin gestion image
        date               = dictionary["day"].stringValue
        preparation        = dictionary["preparation"].stringValue
        ingredients        = dictionary["ingredients"].stringValue
        tps_preparation    = dictionary["tps_preparation"].stringValue
        tps_cuisson        = dictionary["tps_cuisson"].stringValue
        nb_personne        = dictionary["nb_personne"].stringValue
        lastUpdated        = dictionary["lastUpdated"].stringValue

        return self
    }
  
    
    /*func createJSONOBject() -> AnyObject  {
        let para = self.toDic()
        
        do {
            let jsonData = try NSJSONSerialization.dataWithJSONObject(para, options: NSJSONWritingOptions.PrettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
            var string:String = String()
            string = String(data: jsonData, encoding: NSUTF8StringEncoding)! as String

            return string
        } catch let error as NSError {
            print(error)
        }
        return para
    }*/
    
    
    func toDic() -> Dictionary<String, AnyObject> {
        let dic = ["id":self.id , "preparation":self.preparation , "ingredients":self.ingredients , "tps_preparation":self.tps_preparation, "tps_cuisson":self.tps_cuisson , "categorie":self.categorie, "title":self.title as AnyObject, "nb_personne":self.nb_personne, "day":self.date, "image":self.imagePath] as [String : Any]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
            
            let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
            // here "decoded" is of type `Any`, decoded from JSON data
            
            // you can now cast it with the right type
            if let dictFromJSON = decoded as? [String:String] {
                // use dictFromJSON
                return dictFromJSON as Dictionary<String, AnyObject>
            }
        } catch {
            print(error.localizedDescription)
            let dictFromJSON = ["null":"null"]
            return dictFromJSON as Dictionary<String, AnyObject>
        }
        
        let dictFromJSON = ["null":"null"]
        return dictFromJSON as Dictionary<String, AnyObject>
    }
    
    func toDicPOST() -> Dictionary<String, AnyObject> {
        
        let dic = ["preparation":self.preparation , "ingredients":self.ingredients , "tps_preparation":self.tps_preparation, "tps_cuisson":self.tps_cuisson , "categorie":self.categorie, "title":self.title as AnyObject, "nb_personne":self.nb_personne, "day":self.date, "image":self.imagePath] as [String : Any]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
            
            let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
            // here "decoded" is of type `Any`, decoded from JSON data
            
            // you can now cast it with the right type
            if let dictFromJSON = decoded as? [String:String] {
                // use dictFromJSON
                return dictFromJSON as Dictionary<String, AnyObject>
            }
        } catch {
            print(error.localizedDescription)
        }
        
        let dictFromJSON = ["null":"null"]
        return dictFromJSON as Dictionary<String, AnyObject>
    }
    
}
