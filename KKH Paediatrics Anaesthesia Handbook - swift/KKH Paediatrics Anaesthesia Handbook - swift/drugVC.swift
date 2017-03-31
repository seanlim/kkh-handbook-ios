//
//  drugVC.swift
//  KKH Paediatrics Anaesthesia Handbook - swift
//
//  Created by Seannn! on 30/3/17.
//  Copyright © 2017 SST inc. All rights reserved.
//

import UIKit
import DropDown
import PDFReader

var selected_drug: Int? = nil
var patientWeight: Int? = nil

class drugVC: UIViewController {
    
    
    @IBOutlet weak var backb: UIButton!
    @IBOutlet weak var ddplaceholder: UIView!
    @IBOutlet weak var weightField: UITextField!
    @IBOutlet weak var selectionlabel: UILabel!
    
    let ddMenu = DropDown()
    var isdown = false
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styling()
        selected_drug = nil
        isdown = false
        
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dropdownMenu(_ sender: Any) {
        ddMenu.show()
    }
    
    @IBAction func proceed(_ sender: Any) {
        if selected_drug != nil{
        if weightField.text != ""{
            patientWeight = Int(weightField.text!)
            self.performSegue(withIdentifier: "send", sender: self)
        }
        else{            sendAlertController(title: "Error", message: "Invalid input, please check.", actionTitle: "Okay")
            }
        }
        else{
            sendAlertController(title: "Error", message: "Invalid input, please check.", actionTitle: "Okay")
        }
    }
    
    //MARK: - REUSE
    func styling () {
        self.view.backgroundColor = UIColor.init().primaryColor()
        _ = backb.roundify_circle
        ddplaceholder.backgroundColor = UIColor.init().secondaryColor()
        weightField.backgroundColor = UIColor.init().secondaryColor()
        
        //setup dd menu
        ddMenu.anchorView = ddplaceholder
        ddMenu.dataSource = ["Cardiac","Anaesthesia","Scoliosis","Common"]
        ddMenu.backgroundColor = UIColor.init().secondaryColor()
        ddMenu.selectionBackgroundColor = UIColor.init().primaryColor()
        ddMenu.textColor = UIColor.white
        ddMenu.selectionAction = { [unowned self] (index: Int, item: String) in
            self.selectionlabel.text = item
            selected_drug = index
        }
    }
    
    func sendAlertController (title : String, message : String, actionTitle : String){
        let a = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        a.addAction(UIAlertAction.init(title: actionTitle, style: .cancel, handler: nil))
        self.present(a, animated: true, completion: nil)
    }

    
    
}


////////////////////////////////////////////
                                        ////
                                        ////
//MARK: - DRUGS SENDING                 ////
////////////////////////////////////////////

class drugSendVC: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var backbutton: UIButton!
    
    var data: Data? = nil
    @IBOutlet weak var header: UILabel!
    
    
    let anaesthesia = DrugCalculationsManager.init(weight: patientWeight!)
    let cardiac     = CardiacDrugCalculationsManager.init(weight: patientWeight!)
    let scoliosis   = ScoliosisDrugCalculationsManager.init(weight: patientWeight!)
    var userIsviewingSheet = false
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styling()
        getData()
        userIsviewingSheet = false
    }
    
    func getData() {
        header.text = "CSV file for patient of weight \(patientWeight!) KG generated."
        switch selected_drug! {
        case 0:
           data =  cardiac.getData()
            break
        case 1:
            data = anaesthesia.getData()
            break
        case 2:
            data = scoliosis.getData()
            break
        default:
            break
        }
    }
    
    @IBAction func view(_ sender: Any) {
        openCSVwithData(data: data!)
    }
    
    
    @IBAction func back(_ sender: Any) {
        if userIsviewingSheet {
            closeCSVViewer()
        }
        else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func share(_ sender: Any) {
        switch selected_drug! {
        case 0:
            cardiac.sendEmail(self)
            break
        case 1:
            anaesthesia.sendEmail(self)
            break
        case 2:
            scoliosis.sendEmail(self)
            break
        default:
            break
        }
    }
    
    //MARK: - REUSE
    func styling () {
        self.view.backgroundColor = UIColor.init().primaryColor()
        _ = backbutton.roundify_circle
        backbutton.backgroundColor = UIColor.init().secondaryColor()
        backbutton.titleLabel?.textColor = UIColor.white
    }
    
    var webView = UIWebView()
    func openCSVwithData (data:Data) {
        print (data)
        let file = "file.csv"
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let path = dir.appendingPathComponent(file)
            //writing
            do {
                try data.write(to: path, options: .atomic)
            }
            catch {/* error handling here */}
            
            //reading
            do {
                //setup webview
                webView = UIWebView.init(frame: CGRect.init(x: 0, y:0, width: self.view.frame.size.width, height: self.view.frame.size.height))
                webView.loadRequest(URLRequest.init(url: path))
                webView.isMultipleTouchEnabled = true
                webView.scrollView.isMultipleTouchEnabled = true
                webView.scrollView.maximumZoomScale = 2
                webView.scrollView.minimumZoomScale = 0.5
                webView.scrollView.setZoomScale(2, animated: true)
                webView.delegate = self
                webView.scalesPageToFit = true
                self.view.addSubview(webView)
                userIsviewingSheet = true
                self.view.bringSubview(toFront: backbutton)
            }
            catch {/* error handling here */}
        }
    }
    
    func closeCSVViewer (){
        userIsviewingSheet = false
        self.webView.removeFromSuperview()
        
    }
    
    
    
    
}
