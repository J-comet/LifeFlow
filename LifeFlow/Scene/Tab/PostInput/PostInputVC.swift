//
//  PostInputVC.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/29.
//

import UIKit
import PhotosUI

import Then
import RxSwift
import RxCocoa
import RxGesture

final class PostInputVC: BaseViewController<PostInputView, PostInputViewModel> {
    
    private var selectedImages: [PhpickerImage] = [PhpickerImage(image: nil)]
    private var previewImages: BehaviorRelay<[PhpickerImage]> = BehaviorRelay(value: [PhpickerImage(image: nil)])
    
    private var max = 5
    
    private var phpickerConfig = {
        var config = PHPickerConfiguration()
        config.selectionLimit = 5
        config.filter = .any(of: [.livePhotos, .images])
        config.selection = .ordered
        return config
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        configureVC()
    }
}


extension PostInputVC: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        if results.isEmpty {
            print("취소")
        } else {
            results.forEach { result in
                let provider = result.itemProvider
                if provider.canLoadObject(ofClass: UIImage.self) {
                    provider.loadObject(ofClass: UIImage.self) { (image, error) in
                        DispatchQueue.main.async {
                            if let selectedImage = image as? UIImage {
                                self.selectedImages.append(PhpickerImage(image: selectedImage))
                                self.previewImages.accept(self.selectedImages)
                            }
                        }
                    }
                }
            }
        }
    }
}

extension PostInputVC {
    
    func bindViewModel() {
        previewImages
            .asDriver(onErrorJustReturn: [])
            .drive(mainView.imgCollectionView.rx.items(cellIdentifier: PostInputImageCell.identifier, cellType: PostInputImageCell.self)) { (row, element, cell) in
                
                cell.removeImageView
                    .rx
                    .tapGesture()
                    .when(.recognized)
                    .asDriver { _ in .never() }
                    .drive(with: self, onNext: { owner, tap in
                        if let removeIdx = owner.selectedImages.firstIndex(where: {$0.id == element.id }) {
                            owner.selectedImages.remove(at: removeIdx)
                            owner.previewImages.accept(owner.selectedImages)
                        }
                    })
                    .disposed(by: cell.disposeBag)
                
                cell.configCell(row: element)
            }
            .disposed(by: viewModel.disposeBag)
        
        // didSelectItemAt
        Observable.zip(mainView.imgCollectionView.rx.itemSelected, mainView.imgCollectionView.rx.modelSelected(PhpickerImage.self))
            .subscribe(with: self) { owner, selectedItem in
                
                owner.phpickerConfig.selectionLimit = owner.max - (owner.selectedImages.count - 1)
                let picker = PHPickerViewController(configuration: owner.phpickerConfig)
                picker.delegate = self
                
                if selectedItem.0.item == 0 {
                    if owner.selectedImages.count - 1 == owner.max {
                        owner.showToast(msg: "최대 \(owner.max)개 선택할 수 있어요")
                    } else {
                        owner.present(picker, animated: true, completion: nil)
                    }
                } else {
                    
                }
            }
            .disposed(by: viewModel.disposeBag)
        
    }
    
    func configureVC() {
        mainView.closeButton
            .rx
            .tap
            .bind(with: self) { owner, _ in
                self.dismiss(animated: true)
            }
            .disposed(by: viewModel.disposeBag)
    }
}
