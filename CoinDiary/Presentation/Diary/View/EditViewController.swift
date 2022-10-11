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
    
//    lazy var titleLabel: UILabel = {
//
//    }()
    
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
    
    public var viewModel: EditViewModel!
    var subscriptions = Set<AnyCancellable>()
//    var viewMode = ViewMode.View
    
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
        [imageView, memoView, startField, arrowView, endField, photoBtn, addBtn, cancelBtn].forEach { self.view.addSubview($0) }
    }
    
    override func setupConstraints() {
        imageView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(200)
        }
        
        memoView.snp.makeConstraints {
            if viewModel.diary.imageURL != nil {
                $0.top.equalTo(imageView.snp.bottom).offset(20)
            }else {
                $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
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
        arrowView.image = UIImage(systemName: "arrow.down")?.withRenderingMode(.alwaysOriginal)
        
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
            $0.width.equalTo(80)
            $0.height.equalTo(30)
        }
        
        cancelBtn.snp.makeConstraints {
            $0.centerY.equalTo(photoBtn.snp.centerY)
            $0.trailing.equalTo(addBtn.snp.leading).offset(-10)
            $0.width.equalTo(80)
            $0.height.equalTo(30)
        }
    }
    
    override func bind() {
        viewModel.$diary
            .receive(on: RunLoop.main)
            .sink { diary in
                self.navigationItem.title = diary.today
                self.memoView.text = diary.memo
                self.startField.text = diary.start
                self.endField.text = diary.end
                guard let imageURL = diary.imageURL else { return }
                self.imageView.kf.setImage(with: URL(string: imageURL))
                
            }.store(in: &subscriptions)
        
        viewModel.viewModePublisher
            .receive(on: RunLoop.main)
            .sink { [unowned self] value in
//                if value == .View {
//                    self.navigationController?.popViewController(animated: true)
//                }else {
//                    self.cancelBtn.setTitle("취소", for: .normal)
//                    self.addBtn.setTitle("수정", for: .normal)
//                    [memoView, startField, endField, photoBtn].forEach { $0.isUserInteractionEnabled = true }
//                }
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
                    self.navigationController?.popViewController(animated: true)
                }
        }.store(in: &subscriptions)
    }
    
    @objc func clickAdd(_ sender: UIButton) {
        viewModel.clickAdd()
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
//            self.images = image
//            imageView.image = image
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
