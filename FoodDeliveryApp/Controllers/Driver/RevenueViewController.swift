//
//  RevenueViewController.swift
//  FoodDeliveryApp
//
//  Created by Alvaro Gonzalez on 11/5/21.
//

import UIKit
import Charts

class RevenueViewController: UIViewController {
    
    @IBOutlet weak var viewChart: BarChartView!
        // week array
    var weekdays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    
    @IBOutlet var butt: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
      
        self.initializeChart()
        self.loadDataToChart()

        // Do any additional setup after loading the view.
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let tabBarController = segue.destination as! UITabBarController
        let destination = sender as? String
        //let send = sender as? UIButton
        //if(send == self.butt){
        if(destination == "toProfile"){
            tabBarController.selectedIndex = 3
        }
   }
    
    @IBAction func onButton(_ sender: Any) {
        
        let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "DriverTabBarController") as? UITabBarController

        //let destination = self.storyboar

        homeViewController?.selectedIndex = 3
        self.performSegue(withIdentifier: "test1", sender: "toProfile")

    }
    
    func initializeChart() {
        
        viewChart.noDataText = "No Data"
        viewChart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInBounce)
        viewChart.xAxis.labelPosition = .bottom
        //viewChart.descriptionText = ""
        //viewChart.xAxis.setLabelsToSkip(0)
        //viewChart.xAxis.setLabels("0")

        viewChart.legend.enabled = false
        viewChart.scaleYEnabled = false
        viewChart.scaleXEnabled = false
        viewChart.pinchZoomEnabled = false
        viewChart.doubleTapToZoomEnabled = false
        
        viewChart.leftAxis.axisMinimum = 0.0
        viewChart.leftAxis.axisMaximum = 100.00
        viewChart.highlighter = nil
        viewChart.rightAxis.enabled = false
        viewChart.xAxis.drawGridLinesEnabled = false
        
    }
    
    
    
    func loadDataToChart() {
    
        APIManager.shared.getDriverRevenue { (json) in
            
            if json != nil {
                
                print(json)
                
                let revenue = json["revenue"]
                
                var dataEntries: [BarChartDataEntry] = []
                
                for i in 0..<self.weekdays.count {
                    let day = self.weekdays[i]
                    //let dataEntry = BarChartDataEntry(value: revenue[day].double!, xIndex: i)
                    //dataEntries.append(dataEntry)
                }
                
                let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Revenue by day")
                chartDataSet.colors = ChartColorTemplates.material()
                
                //let chartData = BarChartData(xVals: self.weekdays, dataSet: chartDataSet)
                
                //self.viewChart.data = chartData
                
            }
        }
    }
    
    
    
    
    
    
    
    
    

   
}
