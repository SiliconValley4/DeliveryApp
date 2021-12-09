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
    
//    var chart: BarChartView!
    
    var weekdays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//
      
        // #1 Initialize chart
        self.initializeChart()
        
        // #2 Load data to chart
        self.loadDataToChart()

        // Do any additional setup after loading the view.
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let tabBarController = segue.destination as! UITabBarController
        let destination = sender as? String
        if(destination == "toProfile"){
            tabBarController.selectedIndex = 3
        }
   }
    
    
    
    func initializeChart() {
        
        viewChart.noDataText = "No Data"
        viewChart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInCubic)
        viewChart.xAxis.labelPosition = .bottom
        viewChart.chartDescription?.text = ""
//        viewChart.descriptionText = ""
//        viewChart.xAxis.setLabelsToSkip(0)
        
        viewChart.legend.enabled = false
        viewChart.scaleYEnabled = false
        viewChart.scaleXEnabled = false
        viewChart.pinchZoomEnabled = false
        viewChart.doubleTapToZoomEnabled = false
        
        viewChart.leftAxis.axisMinimum = 0.0
//        viewChart.leftAxis.axisMaximum = 100.00
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
                print("___DATA ENTRY_________")
                print(dataEntries)
                
                for i in 0..<self.weekdays.count {
                    let day = self.weekdays[i]
                    print("___DAY _______________")
                    print(day)
//
                    let dataEntry = BarChartDataEntry(x: Double(i) , y: revenue[day].double!)
//                    let dataEntry = BarChartDataEntry(value: revenue[day].double! , xIndex: i)
                    print("DataEntry _______________")
                    print(dataEntry)
                    
                    dataEntries.append(dataEntry)
//                    print("DataEntries _______________")
//                    print(dataEntries)
//                    dataEntries.append(BarChartDataEntry.init())
                }
                
                let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Revenue by day")
                chartDataSet.colors = ChartColorTemplates.material()
                
//                let chartData = BarChartData(xVals: self.weekdays, dataSet: chartDataSet)
                let chartData = BarChartData(dataSet: chartDataSet)
               
                
                
                self.viewChart.data = chartData
                
            }
        }
    }
    

    

    

//end
}
