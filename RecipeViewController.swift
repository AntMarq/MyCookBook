//
//  RecipeViewController.swift
//  MyCookBook
//
//  Created by SQLI51107 on 14/01/2016.
//  Copyright © 2016 MARQUET. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class RecipeViewController: UIViewController, UITextFieldDelegate {
    
    var titleViewController:String = String()    
    var recipeDetail:Recipe = Recipe()
    @IBOutlet weak var imageRecipe: UIImageView!
    @IBOutlet weak var ingredientsDetail: UITextView!
    @IBOutlet weak var titleRecipeDetail: UILabel!
    @IBOutlet weak var preparationRecipeDetail: UITextView!
    
    @IBOutlet weak var editBtn: UIButton!
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = recipeDetail.title
        imageRecipe.image = UIImage(named: recipeDetail.image)
        titleRecipeDetail.text = recipeDetail.title
        ingredientsDetail.editable = false
        preparationRecipeDetail.editable = false
        ingredientsDetail.text = recipeDetail.ingredients
        preparationRecipeDetail.text = recipeDetail.preparation
     
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backController(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func pressEdit(sender: AnyObject) {
        if(!ingredientsDetail.editable){
            editBtn.setImage(UIImage(named: "edit-validated"), forState: UIControlState.Normal)
            ingredientsDetail.editable = true
            preparationRecipeDetail.editable = true
        }
        else{
            editBtn.setImage(UIImage(named: "edit-unvalidated"), forState: UIControlState.Normal)
            ingredientsDetail.editable = false
            preparationRecipeDetail.editable = false
        }
    }
    
   /* @IBAction func showRecipesList(sender: AnyObject) {
        
        self.performSegueWithIdentifier("showRecipesList", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showRecipesList" {
            let popoverViewController = segue.destinationViewController as! RecipeViewController
            popoverViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
            popoverViewController.popoverPresentationController!.delegate = self
        }
    }
*/
}
