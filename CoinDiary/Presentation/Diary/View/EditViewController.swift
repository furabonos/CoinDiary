//
//  EditViewController.swift
//  CoinDiary
//
//  Created by 엄태형 on 2022/10/11.
//

import UIKit
import Combine
import Kingfisher
import SnapKit


class EditViewController: BaseViewController {
    
    lazy var titleLabel: UILabel = {
        var l = UILabel()
        l.textAlignment = .center
        l.font = .boldSystemFont(ofSize: 16)
        return l
    }()
    
    lazy var imageView: UIImageView = {
        var iv = UIImageView()
        return iv
    }()
    
    lazy var memoView: UITextView = {
        var tv = UITextView()
        tv.layer.borderColor = UIColor.gray.cgColor
        tv.layer.borderWidth = 0.5
        tv.layer.cornerRadius = 10
        tv.isUserInteractionEnabled = false
        return tv
    }()
    
    lazy var photoBtn: UIButton = {
        var b = UIButton()
        b.setImage(UIImage(systemName: "photo"), for: .normal)
        b.imageView?.contentMode = .scaleAspectFit
        b.isUserInteractionEnabled = false
        b.addTarget(self, action: #selector(getPhoto(_:)), for: .touchUpInside)
        return b
    }()
    
    lazy var addBtn: UIButton = {
        var b = UIButton()
        b.setTitle("확인", for: .normal)
        b.setTitleColor(.systemBlue, for: .normal)
        b.addTarget(self, action: #selector(clickAdd(_:)), for: .touchUpInside)
        return b
    }()
    
    lazy var cancelBtn: UIButton = {
        var b = UIButton()
        b.setTitle("수정", for: .normal)
        b.setTitleColor(.systemBlue, for: .normal)
        b.addTarget(self, action: #selector(clickCancel(_:)), for: .touchUpInside)
        return b
    }()
    
    lazy var removeBtn: UIButton = {
        var b = UIButton()
        b.setTitle("삭제", for: .normal)
        b.setTitleColor(.systemBlue, for: .normal)
        b.addTarget(self, action: #selector(clickRemove(_:)), for: .touchUpInside)
        return b
    }()
    
    lazy var startField: UITextField = {
        var tf = UITextField()
        tf.delegate = self
        tf.addLeftPadding()
        tf.layer.borderColor = UIColor.gray.cgColor
        tf.layer.borderWidth = 0.5
        tf.layer.cornerRadius = 10
        tf.keyboardType = .decimalPad
        tf.isUserInteractionEnabled = false
        return tf
    }()
    
    lazy var arrowView: UIImageView = {
        var iv = UIImageView()
        return iv
    }()
    
    lazy var endField: UITextField = {
        var tf = UITextField()
        tf.delegate = self
        tf.addLeftPadding()
        tf.layer.borderColor = UIColor.gray.cgColor
        tf.layer.borderWidth = 0.5
        tf.layer.cornerRadius = 10
        tf.keyboardType = .decimalPad
        tf.isUserInteractionEnabled = false
        return tf
    }()
    
    lazy var indicatorView: UIActivityIndicatorView = {
        var iv = UIActivityIndicatorView()
        return iv
    }()
    
    public var viewModel: EditViewModel!
    var subscriptions = Set<AnyCancellable>()
    var images: UIImage!
    
    static func create(with viewModel: EditViewModel) -> EditViewController {
        let view = EditViewController()
        view.viewModel = viewModel
        return view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        // 수정or확인하는뷰
        // 날짜는 수정불가능
        // 사진이있냐없냐에 따라 ui가조금바뀔듯
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func setupUI() {
        [titleLabel, imageView, memoView, startField, arrowView, endField, photoBtn, addBtn, cancelBtn, removeBtn, indicatorView].forEach { self.view.addSubview($0) }
    }
    
    override func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.centerX.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(200)
        }
        
        memoView.snp.makeConstraints {
            if viewModel.diary.imageURL != nil {
                $0.top.equalTo(imageView.snp.bottom).offset(20)
            }else {
                $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            }
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(100)
        }
        
        startField.snp.makeConstraints {
            $0.top.equalTo(memoView.snp.bottom).offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.leading.equalToSuperview().offset(20)
            $0.height.equalTo(30)
        }
        
        arrowView.snp.makeConstraints {
            $0.top.equalTo(startField.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(30)
        }
        arrowView.image = UIImage(systemName: "arrow.down")
        
        endField.snp.makeConstraints {
            $0.top.equalTo(arrowView.snp.bottom).offset(10)
            $0.trailing.equalToSuperview().offset(-20)
            $0.leading.equalToSuperview().offset(20)
            $0.height.equalTo(30)
        }
        
        photoBtn.snp.makeConstraints {
            $0.top.equalTo(endField.snp.bottom).offset(50)
            $0.leading.equalToSuperview().offset(20)
            $0.width.equalTo(50)
        }
        
        addBtn.snp.makeConstraints {
            $0.centerY.equalTo(photoBtn.snp.centerY)
            $0.trailing.equalToSuperview().offset(-20)
            $0.width.equalTo(60)
            $0.height.equalTo(30)
        }
        
        removeBtn.snp.makeConstraints {
            $0.centerY.equalTo(photoBtn.snp.centerY)
            $0.trailing.equalTo(addBtn.snp.leading).offset(-10)
            $0.width.equalTo(60)
            $0.height.equalTo(30)
        }
        
        cancelBtn.snp.makeConstraints {
            $0.centerY.equalTo(photoBtn.snp.centerY)
            $0.trailing.equalTo(removeBtn.snp.leading).offset(-10)
            $0.width.equalTo(60)
            $0.height.equalTo(30)
        }
        
        indicatorView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(50)
        }
    }
    
    override func bind() {
        viewModel.$diary
            .receive(on: RunLoop.main)
            .sink { diary in
                self.titleLabel.text = diary.today
                self.memoView.text = diary.memo
                self.startField.text = diary.start
                self.endField.text = diary.end
                guard let imageURL = diary.imageURL else { return }
                self.imageView.kf.setImage(with: URL(string: imageURL))
            }.store(in: &subscriptions)
        
        viewModel.viewModePublisher
            .receive(on: RunLoop.main)
            .sink { [unowned self] value in
                if value == .View {
                    self.cancelBtn.setTitle("수정", for: .normal)
                    self.addBtn.setTitle("확인", for: .normal)
                    [memoView, startField, endField, photoBtn].forEach { $0.isUserInteractionEnabled = true }
                }else if value == .Edit {
                    self.cancelBtn.setTitle("취소", for: .normal)
                    self.addBtn.setTitle("수정", for: .normal)
                    [memoView, startField, endField, photoBtn].forEach { $0.isUserInteractionEnabled = true }
                }else {
                    //None
                    self.dismiss(animated: true)
                }
        }.store(in: &subscriptions)
        
        viewModel.saveDataPublisher.receive(on: RunLoop.main)
            .sink { [unowned self] value in
                if value {
                    saveDataSuccess(message: "저장되었습니다.")
                }else {
                    saveDataFailure(message: "저장에 실패하였습니다.\n잠시후 다시 시도해주세요.", indicator: self.indicatorView)
                }
            }.store(in: &subscriptions)
        
        viewModel.removeDataPublisher.receive(on: RunLoop.main)
            .sink { [unowned self] value in
                if value {
                    removeDataSuccess(message: "삭제되었습니다.")
                }else {
                    removeDataFailure(message: "삭제에 실패하였습니다.\n잠시후 다시 시도해주세요.", indicator: self.indicatorView)
                }
            }.store(in: &subscriptions)
    }
    
    @objc func clickAdd(_ sender: UIButton) {
        if viewModel.viewMode == .Edit {
            var today = titleLabel.text!
            var start = startField.text ?? ""
            var end = endField.text ?? ""
            var memo = memoView.text ?? ""
            var images = imageView.image
            
            if start == "" {
                showAlert(message: "시작금액을 입력해주세요.")
            }else if end == "" {
                showAlert(message: "종료금액을 입력해주세요.")
            }else {
                indicatorView.startAnimating()
                viewModel.saveData(date: today, start: start, end: end, memo: memo, image: images)
            }
        }else {
            viewModel.clickAdd()
        }
    }
    
    @objc func clickRemove(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "", message: "기록을 삭제하시겠습니까?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: { action in
            self.indicatorView.startAnimating()
            self.viewModel.removeData(date: self.titleLabel.text!)
        })
        let cancelAction = UIAlertAction(title: "취소", style: .default)
        [okAction, cancelAction].forEach { alert.addAction($0) }

        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func clickCancel(_ sender: UIButton) {
        viewModel.clickCancel()
    }
    
    @objc func getPhoto(_ sender: UIButton) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }

}

extension EditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            self.images = image
            self.imageView.image = image
            self.memoView.snp.remakeConstraints {
                $0.top.equalTo(imageView.snp.bottom).offset(20)
                $0.leading.equalToSuperview().offset(20)
                $0.trailing.equalToSuperview().offset(-20)
                $0.height.equalTo(100)
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension EditViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard var text = textField.text else {
            return true
        }
        
        text = text.replacingOccurrences(of: getStringUserDefaults(key: "unit"), with: "")
        text = text.replacingOccurrences(of: ",", with: "")
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        if (string.isEmpty) {
            // delete
            if text.count > 1 {
                guard let price = Double.init("\(text.prefix(text.count - 1))") else {
                    return true
                }
                guard let result = numberFormatter.string(for: price) else {
                    return true
                }
                
                textField.text = "\(result)"
            }
            else {
                textField.text = ""
            }
        }
        else {
            // add
            guard let price = Double.init("\(text)\(string)") else {
                return true
            }
            guard let result = numberFormatter.string(for: price) else {
                return true
            }
            textField.text = "\(result)\(getStringUserDefaults(key: "unit"))"
        }
        
        return false
        
    }
    
}
