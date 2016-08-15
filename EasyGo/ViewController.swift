//
//  ViewController.swift
//  EasyGo
//
//  Created by 魏超 on 16/7/30.
//  Copyright © 2016年 魏超. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let errPlaceholder = "答案错误，再来一次"
    let okPlaceholder = "输入答案"
    let againPlaceholder = "再来一次"
    let coreSession:URLSession! = URLSession.shared
    let url = URL(string: "http://192.168.1.108:8080/GradleProject/getNextItem")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        desc.backgroundColor = UIColor.white()
        label.textAlignment = .center
        answer.text = nil
        answer.placeholder = self.okPlaceholder
                // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var label: UILabel!

    @IBOutlet weak var answer: UITextField!
    
    @IBOutlet weak var submit: UIButton!
    
    @IBOutlet weak var desc: UILabel!
    @IBAction func submit(_ sender: AnyObject) {
        let value = label.text;
        if(answer.text == value)
        {
             let next = UIAlertController(title: "恭喜", message: "点击下一题", preferredStyle: .alert)
            let OK = UIAlertAction(title: "下一题", style: .default, handler:{
                action in
                
                let item = self.nextItem()
                self.label.text = item.key
                self.label.lineBreakMode = .byWordWrapping
                self.label.numberOfLines = 0

                
                
                self.desc.text = item.desc
                self.answer.text = nil
            })
            next.addAction(OK)
            self.present(next, animated: true, completion: nil)
            answer.placeholder = self.okPlaceholder
            
        }
        else
        {
            
            answer.placeholder = self.errPlaceholder
            answer.text = nil
        }
    }
    
    @IBAction func resetPlaceholder(_ sender: AnyObject) {
        
        let cur = answer.placeholder
        if(cur == self.errPlaceholder)
        {
            answer.placeholder = self.againPlaceholder
        }
    }
    func nextItem() -> Item {
        
        
        let item = Item();
        item.desc = "123"
        item.key = "cc"
        item.score = 1
        
        
        
        
        
            let task = coreSession.dataTask(with: url!, completionHandler: { (data, response, error) in
                self.coreSession.finishTasksAndInvalidate()
                var json:AnyObject
                do
                {
                    json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                    let desc = json.object(forKey: "title")
                    let key = json.object(forKey: "value")
                    let score = json.object(forKey: "score")
                    item.desc = String(desc!)
                    item.key = String(key!)
                    item.score = Int(score as! NSNumber)
                }
                catch let error as NSError
                {
                    print(error.code)
                    print(error.description)
                }

                
                
            })
            
            task.resume()
            
        
        
        
        return item
    }
}

class Item
{
    var desc:String = ""
    var key:String = ""
    var score = 1
    
}




