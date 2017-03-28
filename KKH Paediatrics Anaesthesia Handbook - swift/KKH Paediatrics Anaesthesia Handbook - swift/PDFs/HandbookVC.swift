//
//  HandbookVC.swift
//  KKH Paediatrics Anaesthesia Handbook - swift
//
//  Created by Seannn! on 27/3/17.
//  Copyright © 2017 SST inc. All rights reserved.
//

import UIKit

class HandbookVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate {
    
    var manager = PDFManager.init()
    
    @IBOutlet weak var collectionView: UICollectionView!
    var dispArray = [String]()
    @IBOutlet weak var topbar: UIView!
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var search_backdrop: UIView!
    var search_inital_frame :CGRect = CGRect()
    var SearchBarExpanded :Bool = Bool()
    @IBOutlet var searchField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init().primaryColor()
        SearchBarExpanded = false
        dispArray = manager.chapters_NAME
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //styling
        search_backdrop.layer.cornerRadius = search_backdrop.frame.size.width/2
        topbar.backgroundColor = UIColor.init().primaryColor()
        search_inital_frame = search_backdrop.frame
    }
    
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        print("did tap =")
        if SearchBarExpanded {
            collapseSearchBar()
            updatecollectionViewDisplaywithArray(replacement: manager.chapters_NAME)
        }
        else{
            expandSearchBar()
        }
    }
    
//MARK: - searching 
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        updatecollectionViewDisplaywithArray(replacement: search(query: textField.text!))
        return true
    }
    
    func search (query: String) -> [String]{
        var array = [String]()
        manager.filePaths.forEach { (file) in
            if file.lowercased().contains(query.lowercased()){
                array.append(file)
            }
        }
        return array
    }

//MARK: - collectionview delegate/datasource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dispArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HandbookCollectionViewCell
        cell.layer.cornerRadius = 10.0
        cell.backgroundColor = UIColor.init().secondaryColor()
        cell.indexLabel.textColor = UIColor.init().primaryColor()
        cell.indexLabel.text = String(indexPath.row + 1)
        cell.titleLabel.text = dispArray[indexPath.row]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
   
//MARK: - reusables
    func updatecollectionViewDisplaywithArray (replacement : [String]){
        dispArray = replacement
        collectionView.reloadData()
    }
    
    func expandSearchBar (){
        searchButton.setTitle("X", for: .normal)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: {
            self.search_backdrop.frame = CGRect.init(x: 10, y: Int(self.search_backdrop.frame.origin.y), width: Int(self.view.frame.size.width - 20), height: Int(self.search_backdrop.frame.size.height))
        }, completion: { (s) in
            self.searchField.frame.size = CGSize.init(width: self.search_backdrop.frame.size.width - self.searchButton.frame.size.width - 40, height: self.search_backdrop.frame.size.height)
            self.searchField.center = self.search_backdrop.center
            self.view.addSubview(self.searchField)
            self.searchField.becomeFirstResponder()
        })
        SearchBarExpanded = true
    }
    
    func collapseSearchBar (){
        self.view.endEditing(true)
        searchField.text = ""
        searchField.removeFromSuperview()
        searchButton.setTitle("", for: .normal)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: {
            self.search_backdrop.frame = self.search_inital_frame
        }, completion: nil)
        SearchBarExpanded = false
    }


}
