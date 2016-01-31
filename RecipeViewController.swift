//
//  RecipeViewController.swift
//  MyCookBook
//
//  Created by SQLI51107 on 14/01/2016.
//  Copyright © 2016 MARQUET. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class RecipeViewController: UIViewController, UINavigationControllerDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate {
    
    var titleViewController:String = String()    
    var recipeDetail:Recipe = Recipe()
    var imagePicker: UIImagePickerController!

    @IBOutlet weak var imageRecipe: UIImageView!
    @IBOutlet weak var ingredientsDetail: UITextView!
    @IBOutlet weak var titleRecipeDetail: UILabel!
    @IBOutlet weak var preparationRecipeDetail: UITextView!
    
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var btnTakePhoto: UIButton!
    
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
        
        let modifiedIngredient = recipeDetail.ingredients.stringByReplacingOccurrencesOfString(", ", withString: "\n", options: NSStringCompareOptions.LiteralSearch, range: nil)
        ingredientsDetail.editable = false
        preparationRecipeDetail.editable = false
        ingredientsDetail.text = modifiedIngredient
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
            btnTakePhoto.hidden = false
        }
        else{
            editBtn.setImage(UIImage(named: "edit-unvalidated"), forState: UIControlState.Normal)
            ingredientsDetail.editable = false
            preparationRecipeDetail.editable = false
            btnTakePhoto.hidden = true
        }
    }
    
    @IBAction func takePhoto(sender: AnyObject) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .Camera
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        imageRecipe.image = info[UIImagePickerControllerOriginalImage] as? UIImage
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
