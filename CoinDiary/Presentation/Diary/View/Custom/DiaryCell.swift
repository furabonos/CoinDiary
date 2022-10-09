//
//  DiaryCell.swift
//  CoinDiary
//
//  Created by 엄태형 on 2022/09/28.
//

import UIKit

class DiaryCell: BaseCollectionViewCell {
    
    lazy var dateLabel: UILabel = {
        var l = UILabel()
        l.adjustsFontSizeToFitWidth = true
        l.textAlignment = .center
        l.font = l.font.withSize(13)
        return l
    }()
    
    lazy var startLabel: UILabel = {
        var l = UILabel()
        l.adjustsFontSizeToFitWidth = true
        l.textAlignment = .center
        l.font = l.font.withSize(13)
        return l
    }()
    
    lazy var endLabel: UILabel = {
        var l = UILabel()
        l.adjustsFontSizeToFitWidth = true
        l.textAlignment = .center
        l.font = l.font.withSize(13)
        return l
    }()
    
    lazy var yieldLabel: UILabel = {
        var l = UILabel()
        l.adjustsFontSizeToFitWidth = true
        l.textAlignment = .center
        l.font = l.font.withSize(13)
        return l
    }()
    
    lazy var memoLabel: UILabel = {
        var l = UILabel()
        l.textAlignment = .center
        l.font = l.font.withSize(13)
        return l
    }()
    
    override func setupUI() {
        [dateLabel, startLabel, endLabel, yieldLabel, memoLabel].forEach { self.addSubview($0) }
    }
    
    override func setupConstraints() {
        dateLabel.snp.makeConstraints {
            $0.top.bottom.leading.equalToSuperview()
            $0.width.equalToSuperview().dividedBy(5)
        }
        
        startLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalTo(dateLabel.snp.trailing)
            $0.width.equalToSuperview().dividedBy(5)
        }
        
        endLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalTo(startLabel.snp.trailing)
            $0.width.equalToSuperview().dividedBy(5)
        }
        
        yieldLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalTo(endLabel.snp.trailing)
            $0.width.equalToSuperview().dividedBy(5)
        }
        
        memoLabel.snp.makeConstraints {
            $0.top.bottom.trailing.equalToSuperview()
            $0.width.equalToSuperview().dividedBy(5)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    func fillStackView(_ info: DiaryEntity) {
        var starts = Double(info.start.replacingOccurrences(of: "KRW", with: "").replacingOccurrences(of: ",", with: "").replacingOccurrences(of: "USDT", with: ""))
        var ends = Double(info.end.replacingOccurrences(of: "KRW", with: "").replacingOccurrences(of: ",", with: "").replacingOccurrences(of: "USDT", with: ""))
        
        if yieldCalculation(start: starts!, end: ends!).contains("-") {
            yieldLabel.textColor = .red
        }else {
            yieldLabel.textColor = .blue
        }
        
        dateLabel.text = info.today
        startLabel.text = info.start
        endLabel.text = info.end
        yieldLabel.text = yieldCalculation(start: starts!, end: ends!)
        if let memos = info.memo {
            memoLabel.text = memos
        }else {
            memoLabel.text = ""
        }
    }
    
}
