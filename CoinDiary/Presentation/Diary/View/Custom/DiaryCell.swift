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
    
    func fillStackView() {
        var aa = ["220928", "400", "500", "memos"]
        for i in 0..<5 {
            var valueLabel: UILabel = {
                var l = UILabel()
                if i == 3 {
                    l.text = yieldCalculation(start: Double(aa[1])!, end: Double(aa[2])!)
                }else {
                    l.text = aa[i]
                }
                l.textAlignment = .center
                l.font = l.font.withSize(13)
                return l
            }()
        }
    }
    
}
