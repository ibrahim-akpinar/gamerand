//
//  ViewController.swift
//  gamerand
//
//  Created by ibrahim akpinar on 7.01.2020.
//  Copyright © 2020 ibrahim akpinar. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {

   
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    var webView: WKWebView!
    
    override func loadView() {
         let webConfiguration = WKWebViewConfiguration()
         webView = WKWebView(frame: .zero, configuration: webConfiguration)
         webView.navigationDelegate = self
        
         view = webView

        getRandomGame()
     }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func becomeFirstResponder() -> Bool {
        return true
    }

    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?){
        if motion == .motionShake {
            getRandomGame()
        }
    }
    
    func getRandomGame(){
        //https://api.famobi.com/feed?a=A-6SR4E&n=100
        var gameLink = URL(string: "")
        
        if let url = URL(string: "https://api.famobi.com/feed?a=A-6SR4E&n=100") {
           URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
            
                       do {
                           // make sure this JSON is in the format we expect
                           if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                               // try to read out a string array
                               if let games = json["games"] as? [Any]  {
                                let index =  Int(arc4random_uniform(UInt32(games.count)));
                                let game = games[index] as? [String : Any]
                                
                                DispatchQueue.main.async {
                                   self.webView.load(URLRequest(url: URL(string: game?["link"] as! String)!))
                                }
                               }
                           }
                       } catch let error as NSError {
                           print("Failed to load: \(error.localizedDescription)")
                      
                       
                    } catch let error {
                       print(error)
                    }
                 }
            }.resume()
        }
    }
}
