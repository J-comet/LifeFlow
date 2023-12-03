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
                                self.viewModel.selectedImages.append(PhpickerImage(image: selectedImage))
                                self.viewModel.previewImages.accept(self.viewModel.selectedImages)
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
        viewModel.previewImages
            .asDriver(onErrorJustReturn: [])
            .drive(mainView.imgCollectionView.rx.items(cellIdentifier: PostInputImageCell.identifier, cellType: PostInputImageCell.self)) { (row, element, cell) in
                
                cell.removeImageView
                    .rx
                    .tapGesture()
                    .when(.recognized)
                    .asDriver { _ in .never() }
                    .drive(with: self, onNext: { owner, tap in
                        if let removeIdx = owner.viewModel.selectedImages.firstIndex(where: {$0.id == element.id }) {
                            owner.viewModel.selectedImages.remove(at: removeIdx)
                            owner.viewModel.previewImages.accept(owner.viewModel.selectedImages)
                        }
                    })
                    .disposed(by: cell.disposeBag)
                
                cell.configCell(row: element)
            }
            .disposed(by: viewModel.disposeBag)
        
        // didSelectItemAt
        Observable.zip(mainView.imgCollectionView.rx.itemSelected, mainView.imgCollectionView.rx.modelSelected(PhpickerImage.self))
            .subscribe(with: self) { owner, selectedItem in
                
                owner.phpickerConfig.selectionLimit = owner.max - (owner.viewModel.selectedImages.count - 1)
                let picker = PHPickerViewController(configuration: owner.phpickerConfig)
                picker.delegate = self
                
                if selectedItem.0.item == 0 {
                    if owner.viewModel.selectedImages.count - 1 == owner.max {
                        owner.showToast(msg: "이미지는 최대 \(owner.max)개 선택할 수 있어요")
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
                owner.dismiss(animated: true)
            }
            .disposed(by: viewModel.disposeBag)
        
        mainView.titleTextField
            .rx
            .text
            .orEmpty
            .asDriver()
            .drive(with: self) { owner, title in
                owner.viewModel.title.accept(title)
            }
            .disposed(by: viewModel.disposeBag)
        
        mainView.contentTextview
            .rx
            .text
            .orEmpty
            .asDriver()
            .drive(with: self) { owner, title in
                owner.viewModel.content.accept(title)
            }
            .disposed(by: viewModel.disposeBag)
        
        mainView.completeButton
            .rx
            .tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(viewModel.previewImages)
            .map { previewImages in
                let realImage = previewImages.filter { pickerImage in
                    pickerImage.image != nil
                }
                var uiImages: [UIImage] = []
                uiImages.append(contentsOf: realImage.map { pickerImage in
                    pickerImage.image!
                })
                return uiImages
            }
            .bind(with: self) { owner, images in
                // TODO: 이미지 선택시 용량 체크 필요 - 10MB
                owner.viewModel.create(images: images)
            }
            .disposed(by: viewModel.disposeBag)
        
        viewModel.createSuccess
            .bind(with: self) { owner, value in
                print("성공성공")
                //
            }
            .disposed(by: viewModel.disposeBag)
        
        viewModel.errorMessage
            .bind(with: self) { owner, message in
                owner.showToast(msg: message)
            }
            .disposed(by: viewModel.disposeBag)
        
        viewModel.isLoading
            .bind { isLoading in
                if isLoading {
                    LoadingIndicator.show()
                } else {
                    LoadingIndicator.hide()
                }
            }
            .disposed(by: viewModel.disposeBag)
    }
}
