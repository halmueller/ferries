//
//  DebugViewController.swift
//  Ferries In Class
//
//  Created by Hal Mueller on 5/17/17.
//  Copyright © 2017 Hal Mueller. All rights reserved.
//

import UIKit
import ReplayKit

class DebugViewController: UIViewController, RPPreviewViewControllerDelegate {

    @IBOutlet weak var startRecordingButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var speakShushSegmentedControl: UISegmentedControl!
    
    var previewViewController: RPPreviewViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if FerriesCoreDataStack.shared.shouldAnnounce {
            speakShushSegmentedControl.selectedSegmentIndex = 0
        }
        else {
            speakShushSegmentedControl.selectedSegmentIndex = 1
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print(#function, #line)
    }
    
    @IBAction func seedDatastore(_ sender: Any) {
        FerriesCoreDataStack.shared.createSampleData()
    }
    
    @IBAction func toggleSpeaking(_ sender: UISegmentedControl) {
        FerriesCoreDataStack.shared.shouldAnnounce = !FerriesCoreDataStack.shared.shouldAnnounce
    }
    
    // MARK: - ReplayKit
    
    @IBAction func startRecording(_ sender: Any) {
        let recorder = RPScreenRecorder.shared()
        if recorder.isAvailable {
            recorder.isMicrophoneEnabled = true
            if #available(iOS 10.0, *) {
                recorder.startRecording(handler: { (error) in
                    if error == nil {
                        debugPrint("recording")
                        self.startRecordingButton.isHidden = true
                        self.stopRecordingButton.isHidden = false
                    }
                    else {
                        print(error?.localizedDescription ?? "")
                    }
                })
            } else {
                // Fallback on earlier versions
            }
        } else {
            // Display UI for recording being unavailable
        }
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        startRecordingButton.isHidden = false
        stopRecordingButton.isHidden = true
        RPScreenRecorder.shared().stopRecording { previewViewController, error in
            if let error = error {
                print("error", error)
            }
            if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad {
                previewViewController?.modalPresentationStyle = UIModalPresentationStyle.popover
                previewViewController?.popoverPresentationController?.sourceRect = CGRect.zero
                previewViewController?.popoverPresentationController?.sourceView = self.view
            }
            if let previewViewController = previewViewController {
                self.previewViewController = previewViewController
                previewViewController.previewControllerDelegate = self
                self.show(previewViewController, sender: self)
            }
        }
    }
    
    // MARK: - RPPreviewViewControllerDelegate
    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        previewController.dismiss(animated: true)
    }
    

}
