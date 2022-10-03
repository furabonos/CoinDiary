//
//  DiaryCell.swift
//  CoinDiary
//
//  Created by 엄태형 on 2022/09/28.
//

import UIKit

class DiaryCell: BaseCollectionViewCell {
    
    var StackView: UIStackView = {
        var sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.alignment = .fill
        sv.spacing = 10
//        sv.backgroundColor = Colors.iosGrey
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    override func setupUI() {
        [StackView].forEach { self.addSubview($0) }
    }
    
    override func setupConstraints() {
        StackView.snp.makeConstraints {
            $0.top.leading.bottom.trailing.equalToSuperview()
        }
    }
    
    func fillStackView(_ info: DiaryEntity) {
        var starts = Double(info.start.replacingOccurrences(of: "KRW", with: "").replacingOccurrences(of: ",", with: ""))
        var ends = Double(info.end.replacingOccurrences(of: "KRW", with: "").replacingOccurrences(of: ",", with: ""))
        
        var titleArr = [info.today, info.start, info.end, yieldCalculation(start: starts!, end: ends!), info.memo]
        for i in 0..<titleArr.count {
            var valueLabel: UILabel = {
                var l = UILabel()
                if i == 4 {
                    if let memos = info.memo {
                        l.text = memos
                    }else {
                        l.text = ""
                    }
                }else {
                    l.text = titleArr[i]
                }
        
                l.textAlignment = .center
                l.font = l.font.withSize(13)
                if i == 3 {
                    if yieldCalculation(start: starts!, end: ends!).contains("-") {
                        l.textColor = .red
                    }else {
                        l.textColor = .blue
                    }
                }
                return l
            }()
            StackView.addArrangedSubview(valueLabel)
        }
    }
    
}
