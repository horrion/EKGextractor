//
//  MainInterfaceController.swift
//  EKGextractor WatchKit Extension
//
//  Created by Robert Horrion on 3/31/21.
//  Copyright © 2021 Robert Horrion. All rights reserved.
//

import WatchKit
import Foundation
import HealthKit


class MainInterfaceController: WKInterfaceController {

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func extractAction() {
        
        // Get the EKG samples from HealthKit
        getEKGSample()
        
    }
    
    func getEKGSample() {
        
        // Create the electrocardiogram sample type.
        let ecgType = HKObjectType.electrocardiogramType()
        
        // Query for electrocardiogram samples
        let ecgQuery = HKSampleQuery(sampleType: ecgType,
                                     predicate: nil,
                                     limit: HKObjectQueryNoLimit,
                                     sortDescriptors: nil) { (query, samples, error) in
            if let error = error {
                // Handle the error here.
                fatalError("*** An error occurred \(error.localizedDescription) ***")
            }
            
            guard let ecgSamples = samples as? [HKElectrocardiogram] else {
                fatalError("*** Unable to convert \(String(describing: samples)) to [HKElectrocardiogram] ***")
            }
            
            for sample in ecgSamples {
                // Handle the samples here.
                
                print("Analyzing sample: ")
                print(sample)
                getVoltageMeasurementForSample(ecgSample: sample)
            }
        }

        // Execute the query.
        healthStore.execute(ecgQuery)
    }
    
    
    func getVoltageMeasurementForSample(ecgSample: HKElectrocardiogram) {
        
        // Create a query for the voltage measurements
        let voltageQuery = HKElectrocardiogramQuery(ecgSample) { (query, result) in
            switch(result) {
            
            case .measurement(let measurement):
                if let voltageQuantity = measurement.quantity(for: .appleWatchSimilarToLeadI) {
                    // Do something with the voltage quantity here.
                    
                    print("Analyzing voltage measurement: ")
                    print(voltageQuantity)
                    
                    // TODO: Write this data to a csv file
                    
                }
            
            case .done:
                // No more voltage measurements. Finish processing the existing measurements.
                print("Last measurement was processed")

            case .error(let error):
                // Handle the error here.
                print("Error occurred during voltage measurement processing")
                
            }
        }

        // Execute the query.
        healthStore.execute(voltageQuery)
        
    }
    
    // TODO: Implement csv engine
    
    
    

}
