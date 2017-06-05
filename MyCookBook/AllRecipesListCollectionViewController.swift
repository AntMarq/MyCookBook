//
//  AllRecipesListCollectionViewController.swift
//  MyCookBook
//
//  Created by SQLI51107 on 18/01/2016.
//  Copyright © 2016 MARQUET. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

private let reuseIdentifier = "Cell"
private let segueID = "RecipesListToRecipeDetail"

class AllRecipesListCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var recipeCollectionView: UICollectionView!
    var titleViewController:String = String()
    var categorieFilter:String = String()
    var listRecipes:Array<Recipe> = Array<Recipe>()
    var recipeDetail:Recipe = Recipe()
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
        //IQKeyboardManager.sharedManager().canAdjustTextView = true
        
        AlamofireManager.SharedInstance.getToken { (success) -> Void in
            if(success){
                AlamofireManager.SharedInstance.downloadOrderedRecipes(self.categorieFilter, completion: { (recipes) -> Void in
                    RealmManager.SharedInstance.writeRecipesInDB(recipes, needUpdate: false, completion: { (bool) -> Void in
                        self.getRecipesfromDB(self.categorieFilter, completion: { (recipeArray) -> Void in
                            self.recipeCollectionView.reloadData()
                        })
                    })
                })
            }
            else{
                self.getRecipesfromDB(self.categorieFilter, completion: { (recipeArray) -> Void in
                    self.recipeCollectionView.reloadData()
                })
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.recipeCollectionView?.register(UINib (nibName: "RecipeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        navigationItem.title = titleViewController
        
    }
    
    func getRecipesfromDB(_ category:String, completion: @escaping (_ recipeArray: Array<Recipe>) -> Void){
        if(self.categorieFilter != "0"){
            RealmManager.SharedInstance.getRecipesCategoryFromDB(self.categorieFilter, completion:{ (recipe) -> Void in
                self.listRecipes = recipe
                completion(self.listRecipes)
            })
        }
        else{
            RealmManager.SharedInstance.getAllRecipeFromDB { (recipe) -> Void in
                self.listRecipes = recipe
                completion(self.listRecipes)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backViewController(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return listRecipes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:RecipeCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! RecipeCollectionViewCell
        cell.titleRecipe.text = listRecipes[indexPath.row].title
        cell.buttonDelete.tag = indexPath.row
        cell.buttonDelete.addTarget(self, action: #selector(deleteRecipe(_:)), for: .touchUpInside)

        cell.configure(listRecipes[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            performSegue(withIdentifier: segueID, sender: cell)
        }
    }
    
    func deleteRecipe(_ sender: AnyObject) {
        AlamofireManager.SharedInstance.deleteRecipeById(listRecipes[sender.tag].id) { (success) in
            RealmManager.SharedInstance.deleteRecipe(self.listRecipes[sender.tag], completion: { (success) in
                if(success){
                    self.getRecipesfromDB(self.categorieFilter, completion: { (recipeArray) -> Void in
                        self.recipeCollectionView.reloadData()
                    })
                }
            })
           
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = self.recipeCollectionView?.indexPath(for: sender as! UICollectionViewCell) {
            if segue.identifier == segueID
            {
                if let destinationVC = segue.destination as? RecipeViewController{
                    let objectData:Recipe = listRecipes[indexPath.row]
                    destinationVC.recipeDetail = objectData
                    destinationVC.newRecipe = false
                }
            }
        }
    }
}
