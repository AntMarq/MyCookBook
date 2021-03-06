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
    dynamic var image = ""
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
    
    func setData(dictionary: JSON) -> Recipe{
        
        id                 = dictionary["id"].stringValue
        title              = dictionary["title"].stringValue
        categorie          = dictionary["categorie"].stringValue
        
        //Gestion  image : Si image non présente dans l'appel WS, on entre en base l'image par de la catégorie corespodnante
        if(dictionary["image"].stringValue == ""){
            if(categorie == "1"){
                image          = "placeholder_categorie1"
            }
            else{
                image          = "placeholder_categorie2"
            }
        }
        else{
            image          = dictionary["image"].stringValue
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
        return ["id":self.id, "preparation":self.preparation, "ingredients":self.ingredients, "tps_preparation":self.tps_preparation, "tps_cuisson":self.tps_cuisson, "categorie":self.categorie, "title":self.title, "nb_personne":self.nb_personne, "day":self.date, "image":self.image]
    }
    
    func toDicPOST() -> Dictionary<String, AnyObject> {
        return ["preparation":self.preparation, "ingredients":self.ingredients, "tps_preparation":self.tps_preparation, "tps_cuisson":self.tps_cuisson, "categorie":self.categorie, "title":self.title, "nb_personne":self.nb_personne, "day":self.date, "image":self.image]
    }
    
}
