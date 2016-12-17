//
//  SetupHeaderViewController.swift
//  ExampleApp
//
//  Created by Marcel Dierkes on 31.07.16.
//  Copyright © 2016 Marcel Dierkes. All rights reserved.
//

import UIKit
import AssistantViewController

class SetupHeaderViewController: UIViewController, AssistantStepViewControllerProtocol {
    
    // MARK: - Properties
    @IBOutlet var progressView: UIProgressView?
    
    var progress: Double = 0.0 {
        didSet {
            self.progressView?.setProgress(Float(self.progress), animated: true)
        }
    }
    
    // MARK: - Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.progressView?.setProgress(Float(self.progress), animated: false)
    }
    
    // MARK: - Actions
    @IBAction func toggleDetails(_ sender: Any) {
        if self.assistantViewController?.preferredPrimaryViewControllerHeight != 200.0 {
            self.assistantViewController?.setPreferredPrimaryViewControllerHeight(200.0, animated: true)
        } else {
            self.assistantViewController?.setPreferredPrimaryViewControllerHeight(104.0, animated: true)
        }
    }
}
