//
//  AllRecipesListCollectionViewController.swift
//  MyCookBook
//
//  Created by SQLI51107 on 18/01/2016.
//  Copyright © 2016 MARQUET. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class AllRecipesListCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var recipeCollectionView: UICollectionView!
    var titleViewController:String = String()
    var listRecipes:Array<Recipe> = Array<Recipe>()
    var recipeDetail:Recipe = Recipe()
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.recipeCollectionView?.registerNib(UINib (nibName: "RecipeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        navigationItem.title = titleViewController
        
        recipeDetail.title = "Risotto au poulet"
        recipeDetail.image = "miniature_recette_risotto"
        recipeDetail.tps_cuisson = "30 minutes"
        recipeDetail.tps_preparation = "30 minutes"
        recipeDetail.preparation = "1.Préparez les champignons. Passez-els rapidemment sous un filet d'eau, essuyez-les et détaillez-les en gros morceaux. Faites fondre une noix de beurre et faites-y revenir la gousse d'ail émincée pendant 2 minutes. Ajoutez les champignons et laissez-les cuire environ 3 minutes en ajoutant le persil lavé et ciselé à la fin. Ajoutez 3 cuillères à soupe de vin blanc et laissez cuire 2 minutes jusqu'à ce qu'il réduise. Ajoutez la crème fraîche et mélangez. Salez, poivrez et réservez. \n\n 2.Faites bouillir un litre d'eau dans lequel vous diluerez les cubes de bouillon. Dans une sauteuse, faites chauffer l'huile d'olive pour y faire blondir l'oignon émincé pendant 3 minutes. Ajoutez le riz et laissez-le cuire en remuant pendant 2 minutes jusqu'à ce qu'il soit un peu transparent. Ajoutez 10 cl de vin blanc (1/2 verre) \n\n 3.Ajoutez 10 cl de vin blanc (1/2 verre) et une fois qu'il est aborbé par le riz, ajoutez une louche de bouillon, puis mélangez. Une fois que le bouillon est bien absorbé, ajoutez une nouvelle louche, et ainsi de suite jusqu'à épuisement du bouillon (environ 20 bonnes minutes). \n\n 4.Ajoutez la moitié du parmesan et les champignons, attendez 2 minutes puis mélangez vivement."
        recipeDetail.nb_personne = "4"
        recipeDetail.ingredients = " 250 g de riz arborio spécial risotto (on en trouve dans tous les supermarchés) \n 300 g de champignons de votre choix (girolles, cèpes, champignons de Paris) \n 2 cubes de bouillon de légumes \n 1 oignon ou 2 échalotes \n 10 cl de vin blanc + 3 cuillères à soupe \n 15 cl de crème fraîche \n 100 g de parmesan fraîchement râpé \n une gousse d ailune noix de beurre \n une cuillère à soupe d huile d olive \n 3 branches de persil \n sel et poivre"
        
        listRecipes.append(recipeDetail)
        listRecipes.append(recipeDetail)
        listRecipes.append(recipeDetail)
        listRecipes.append(recipeDetail)
        listRecipes.append(recipeDetail)
        listRecipes.append(recipeDetail)
        listRecipes.append(recipeDetail)
        listRecipes.append(recipeDetail)
        listRecipes.append(recipeDetail)
        listRecipes.append(recipeDetail)
        listRecipes.append(recipeDetail)
        listRecipes.append(recipeDetail)
        listRecipes.append(recipeDetail)
        listRecipes.append(recipeDetail)
        listRecipes.append(recipeDetail)
        listRecipes.append(recipeDetail)
        listRecipes.append(recipeDetail)
        listRecipes.append(recipeDetail)
        listRecipes.append(recipeDetail)
        listRecipes.append(recipeDetail)
        listRecipes.append(recipeDetail)
        listRecipes.append(recipeDetail)
        listRecipes.append(recipeDetail)
        listRecipes.append(recipeDetail)
        listRecipes.append(recipeDetail)
        listRecipes.append(recipeDetail)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func backViewController(sender: UIBarButtonItem) {
        navigationController?.popViewControllerAnimated(true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return listRecipes.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell:RecipeCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! RecipeCollectionViewCell
        cell.titleRecipe.text = listRecipes[indexPath.row].title
        cell.imageRecipe.image = UIImage(named: listRecipes[indexPath.row].image)
        
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let cell = collectionView.cellForItemAtIndexPath(indexPath) {
            performSegueWithIdentifier("RecipesListToRecipeDetail", sender: cell)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let indexPath = self.recipeCollectionView?.indexPathForCell(sender as! UICollectionViewCell) {
            if segue.identifier == "RecipesListToRecipeDetail"
            {
                if let destinationVC = segue.destinationViewController as? RecipeViewController{
                    let objectData:Recipe = listRecipes[indexPath.row]
                    destinationVC.recipeDetail = objectData
                }
            }
        }
    }
}
