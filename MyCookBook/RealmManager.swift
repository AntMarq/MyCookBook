//
//  RealmManager.swift
//  myGymSwift
//
//  Created by julien gimenez on 29/11/2015.
//  Copyright © 2015 julien gimenez. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftyJSON

class RealmManager: NSObject {
    
    static let SharedInstance = RealmManager()
    
    func writeRecipesInDB(result: JSON, needUpdate: Bool, completion:(bool:Bool)->Void) {
        for object in result {
            let recipeResult = self.generateRecipes(object.1)
            getRecipeWithId(recipeResult.id, completion: { (recipe) -> Void in
                if (recipe.count==0){
                    self.writeData(recipeResult)
                }
                else if(recipe.count == 1 && recipeResult.lastUpdated != recipe[0].lastUpdated){
                    self.updateDataWithKey(recipeResult, propertyNeedUpdate: "", keyField:"")
                }
            })
        }
        completion(bool: true)
    }
    
    //Mapping => creation d'objet
    func generateRecipes(dictionary: JSON) -> Recipe {
        return Recipe().setData(dictionary)
    }
    
    //DB => recherche d'un objet similaire
    func getRecipeWithId(_id: String, completion: (description: Results<(Recipe)>) -> Void) {
        let realm = try! Realm()
        completion(description: realm.objects(Recipe).filter("id = %@", _id))
    }
    
    //DB => ecriture en base
    func writeData(object:Object){
        let realm = try! Realm()
        try! realm.write {
            realm.add(object)
        }
    }
    
    func updateDataWithKey(let object:Recipe, propertyNeedUpdate:String, keyField:String){
            let realm = try! Realm()
            try! realm.write {
                if(keyField == KeyFieldConstants.preparationKey){
                    object.preparation = propertyNeedUpdate
                }
                else if(keyField == KeyFieldConstants.imageKey){
                    /*if(propertyNeedUpdate != ""){
                        parent!.image = propertyNeedUpdate
                    }*/
                }
                else if(keyField == KeyFieldConstants.ingredientsKey){
                    object.ingredients = propertyNeedUpdate
                }
                else if(keyField == KeyFieldConstants.titleKey){
                    object.title = propertyNeedUpdate
                }
                else if(keyField == KeyFieldConstants.tps_cuissonKey){
                    object.tps_cuisson = propertyNeedUpdate
                }
                else if(keyField == KeyFieldConstants.tps_preparationKey){
                    object.tps_preparation = propertyNeedUpdate
                }
                else if(keyField == KeyFieldConstants.nb_personneKey){
                    object.nb_personne = propertyNeedUpdate
                }
                
                //  realm.add(object, update: true)
        }
    }
    
    //Print all db recipe
    func getAllRecipes() -> Results<(Recipe)> {
        let realm = try! Realm()
        return realm.objects(Recipe)
    }
    
    //Get DB Recipes
    func getAllRecipeFromDB(completion: (news: Array<Recipe>) -> Void) {
        let realm = try! Realm()
        completion(news: Array<Recipe>(realm.objects(Recipe)))
    }
    
    func getRecipesCategoryFromDB(category:String, completion: (news: Array<Recipe>) -> Void) {
        let realm = try! Realm()
        completion(news: Array<Recipe>(realm.objects(Recipe).filter("categorie = %@",category)))
    }
}
