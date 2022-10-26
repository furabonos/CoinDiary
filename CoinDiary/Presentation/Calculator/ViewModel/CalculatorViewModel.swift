//
//  CalculatorViewModel.swift
//  CoinDiary
//
//  Created by 엄태형 on 2022/10/20.
//

import Foundation
import Combine

protocol CalculatorViewModelInput {
    func combineClick(beforeAVG: String, beforeBUY: String, afterAVG: String, afterBUY: String)
    func percentClick(before: String, percent: String, tag: Int)
}

protocol CalculatorViewModelOutput {
    var combineMSG: String { get }
    var percentMSG: String { get }
}

public final class CalculatorViewModel: CalculatorViewModelInput, CalculatorViewModelOutput, ObservableObject {
    
    @Published public var combineMSG = ""
    @Published public var percentMSG = ""
    
    private var bag: Set<AnyCancellable> = Set<AnyCancellable>()
    
    func combineClick(beforeAVG: String, beforeBUY: String, afterAVG: String, afterBUY: String) {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 2
        
        if beforeAVG == "" || beforeBUY == "" || afterAVG == "" || afterBUY == "" {
            self.combineMSG = "Alert"
        }else {
            var beforeQuanity = Double(beforeBUY.replacingOccurrences(of: ",", with: ""))! / Double(beforeAVG.replacingOccurrences(of: ",", with: ""))! // 기존 구매수량
            var afterQuanity = Double(afterBUY.replacingOccurrences(of: ",", with: ""))! / Double(afterAVG.replacingOccurrences(of: ",", with: ""))! // 새로운 구매수량

            var total = (Double(afterBUY.replacingOccurrences(of: ",", with: ""))! + Double(beforeBUY.replacingOccurrences(of: ",", with: ""))!) / (beforeQuanity + afterQuanity)
            var totalQuanity = beforeQuanity + afterQuanity
            
            self.combineMSG = "최종 평단가는 \(numberFormatter.string(for: total)!)이며 수량은 \(numberFormatter.string(for: totalQuanity)!)개 이다."
        }
    }
    
    func percentClick(before: String, percent: String, tag: Int) {
        if before == "" || percent == "" {
            self.percentMSG = "Alert"
        }else {
            var plus = 1 + (Double(percent)! / 100)
            var minus = 1 - (Double(percent)! / 100)
            
            if tag == 0 {
                self.percentMSG = "\(Double(before)! * plus)"
            }else {
                self.percentMSG = "\(Double(before)! * minus)"
            }
        }
    }
    
}
