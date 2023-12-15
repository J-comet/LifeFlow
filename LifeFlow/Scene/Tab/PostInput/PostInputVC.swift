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

import Alamofire
import Kingfisher

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
                                if selectedImage.isAllowedFileSize {
                                    if let resizeImage = selectedImage.resizeWithWidth(width: 500)?.jpegData(compressionQuality: 1) {
                                        self.viewModel.selectedImages.append(PhpickerImage(image: UIImage(data: resizeImage)))
                                        self.viewModel.previewImages.accept(self.viewModel.selectedImages)
                                    }
                                } else {
                                    self.showToast(msg: "이미지는 최대 10MB까지 업로드 할 수 있어요")
                                }
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
        // 수정 데이터 전달 받았을 때
        viewModel.editData
            .bind(with: self) { owner, postEntity in
                owner.mainView.postInputDataSetting(postEntity: postEntity)
                if let arrImageUrl = postEntity?.image {
                    arrImageUrl.forEach { imageUrl in
                        if let resource = URL(string: APIManagement.baseURL + imageUrl) {
                            KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
                                   switch result {
                                   case .success(let value):
                                       print("value.image")
                                       owner.viewModel.selectedImages.append(PhpickerImage(image: value.image))
                                       owner.viewModel.previewImages.accept(owner.viewModel.selectedImages)
                                   case .failure(let error):
                                       print("Error: \(error)")
                                   }
                               }
                        }
                    }
                    
                }
            }
            .disposed(by: viewModel.disposeBag)
        
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
                
                owner.phpickerConfig.selectionLimit = owner.max - (owner.viewModel.previewImages.value.count - 1)
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
            .withLatestFrom(viewModel.editData)
            .bind(with: self) { owner, editData in
                if editData == nil {
                    // create
                    owner.viewModel.create()
                } else {
                    // edit
                    owner.viewModel.edit()
                }
            }
            .disposed(by: viewModel.disposeBag)
        
        viewModel.createSuccess
            .bind(with: self) { owner, value in
                guard let pvc = owner.presentingViewController else { return }
                owner.dismiss(animated: true) {
                    
                    // HomeVC 으로 돌아갔을 때 업데이트 시키기
                    NotificationCenter.default.post(
                        name: .reloadPost,
                        object: nil,
                        userInfo: nil
                    )
                    
                    let vc = PostDetailVC(
                        viewModel: PostDetailViewModel(
                            postDetail: .init(value: value),
                            postRepository: PostRespository(),
                            commentRepository: CommentRepository()
                        )
                    )
                    vc.modalPresentationStyle = .fullScreen
                    pvc.present(vc, animated: false)
                }
            }
            .disposed(by: viewModel.disposeBag)
        
        viewModel.editSuccess
            .bind(with: self) { owner, value in
                
                // Post 상세화면으로 데이터 전달
                NotificationCenter.default.post(
                    name: .reloadPostDetail,
                    object: nil,
                    userInfo: [NotificationKey.reloadDetailPost: value]
                )
                
                // HomeVC 로 왔을 때 수정 데이터 전달
                NotificationCenter.default.post(
                    name: .reloadPost,
                    object: nil,
                    userInfo: [NotificationKey.reloadDetailPost: value]
                )
                
                owner.dismiss(animated: false)
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
