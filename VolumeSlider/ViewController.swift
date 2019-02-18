//
//  ViewController.swift
//  VolumeSlider
//
//  Created by Surjeet on 30/09/17.
//  Copyright © 2017 Surjeet. All rights reserved.
//

import UIKit

class ViewController: UIViewController, VolumeSliderDelegate {

    @IBOutlet var volumeSlider: VolumeSlider!
    
    @IBOutlet var slider: UISlider!
    
    @IBOutlet var valueLabel: UILabel!
    @IBOutlet var instructionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.instructionLabel.text = "Touch Volume Slider and drag to update \n or \n Drag the UISlider."
        self.valueLabel.text = "Current Value: 0.0"
        
        self.slider.maximumValue = 100
        
        // If want to add VolumneSlider programatically
   //     self.addVolumeSlider()
        
        self.setUpVolumeSlider()
        
        // To set prefilled value
//        self.setupCurrentValue()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func addVolumeSlider() {
        let vol = VolumeSlider.init(frame: CGRect(x:0, y:300, width:350, height:300))
        vol.backgroundColor  = .red
        vol.delegate = self
        
        vol.maxValue = 100
        vol.barWidth = 15.0
        vol.barSpace = 5.0
        
        vol.defaultBarColor = UIColor.lightGray
        vol.barColor = UIColor.yellow
        self.view.addSubview(vol)
    }
    
    
    func setUpVolumeSlider() {
        
        self.volumeSlider.delegate = self
        
        self.volumeSlider.maxValue = 100
        self.volumeSlider.barWidth = 10.0
        self.volumeSlider.barSpace = 5.0
        
        self.volumeSlider.defaultBarColor = UIColor.lightGray
        self.volumeSlider.barColor = UIColor.red
        
    }
    
    func setupCurrentValue() {
        self.volumeSlider.currentValue = 50
    }
    
    func volumnSliderValueChanged(_ volSlider: VolumeSlider) {
        self.slider.value = volSlider.currentValue
        
        self.valueLabel.text = "Current Value: \(volSlider.currentValue)"
    }
    
    @IBAction func sliderValueChanged(_ sender: Any) {
        volumeSlider.currentValue = self.slider.value
    }

}

