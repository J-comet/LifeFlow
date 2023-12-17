//
//  PostDetailVC.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/12/07.
//

import UIKit

import RxGesture
import RxSwift
import RxCocoa
import RxDataSources

final class PostDetailVC: BaseViewController<PostDetailView, PostDetailViewModel> {
    
    lazy var dataSource = RxCollectionViewSectionedReloadDataSource<PostDetailSectionModel>(
        configureCell: { (dataSource, collectionView, indexPath, item) in
            
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PostCommentCell.identifier,
                for: indexPath
            ) as? PostCommentCell else { return UICollectionViewCell() }
            
            cell.configCell(row: item)
            cell.layoutIfNeeded()
            
            return cell
            
        }, configureSupplementaryView: { [weak self] dataSource, collectionView, kind, indexPath in
            
            guard let self = self,
                  let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: UICollectionView.elementKindSectionHeader,
                    withReuseIdentifier: PostHeaderView.identifier,
                    for: indexPath
                  ) as? PostHeaderView else { return UICollectionReusableView() }
            
            header.configCell(row: dataSource.sectionModels[indexPath.section].header)
            header.layoutIfNeeded()
            
            //            header.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height),withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
            
            return header
        })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        configureVC()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reloadPostDetailObserver),
            name: .reloadPostDetail,
            object: nil
        )
    }
    
    @objc
    func reloadPostDetailObserver(notification: Notification) {
        print("전달받은 데이터로 교체하기")
        guard let key = notification.userInfo?[NotificationKey.reloadDetailPost] as? PostEntity else { return }
        viewModel.postDetail.accept(key)
    }
}

extension PostDetailVC {
    
    func bindViewModel() {
        mainView.backButton
            .rx
            .tap
            .bind(with: self) { owner, _ in
                owner.dismiss(animated: false)
            }
            .disposed(by: viewModel.disposeBag)
        
        viewModel.collectionViewDataSource
            .bind(to: mainView.collectionView.rx.items(dataSource: dataSource))
            .disposed(by: viewModel.disposeBag)
        
        viewModel.deletedPostID
            .bind(with: self) { owner, id in
                owner.showAlert(title: "", msg: "삭제되었어요", ok: "확인") { _ in
                    NotificationCenter.default.post(
                        name: .reloadPost,
                        object: nil,
                        userInfo: nil
                    )
                    owner.dismiss(animated: false)
                }
            }
            .disposed(by: viewModel.disposeBag)
        
        mainView.commentTextField
            .rx
            .text
            .orEmpty
            .bind(to: viewModel.commentText)
            .disposed(by: viewModel.disposeBag)
        
        mainView.commentButton
            .rx
            .tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.viewModel.createComment()
            }
            .disposed(by: viewModel.disposeBag)
        
        viewModel.createCommentSuccess
            .bind(with: self) { owner, postEntity in
                
                // HomeVC 로 왔을 때 수정 데이터 전달
                NotificationCenter.default.post(
                    name: .editPost,
                    object: nil,
                    userInfo: [NotificationKey.reloadDetailPost: postEntity]
                )
                
                owner.mainView.commentTextField.text = nil
                owner.viewModel.postDetail.accept(postEntity)
                
                print("------ 이미지 ------")
                print(postEntity.image)
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
        
        viewModel.errorMessage
            .bind(with: self) { owner, message in
                owner.showToast(msg: message)
            }
            .disposed(by: viewModel.disposeBag)
    }
    
    func configureVC() {
        mainView.editHandler = { [weak self] in
            guard let self else { return }
            let vc = PostInputVC(
                viewModel: PostInputViewModel(
                    editData: self.viewModel.postDetail.value,
                    postRepository: PostRespository()
                )
            )
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
        
        mainView.removeHandler = { [weak self] in
            self?.viewModel.delete()
        }
        
        viewModel.postDetail.map {
            $0.creator.id != UserDefaults.userId
        }
        .share()
        .bind(to: mainView.moreButton.rx.isHidden)
        .disposed(by: viewModel.disposeBag)
        
        viewModel.postDetail
            .share()
            .bind(with: self) { owner, postEntity in
                print("이미지 22")
                print(postEntity.image)
                
                owner.viewModel.collectionViewDataSource.accept(
                    [
                        PostDetailSectionModel(header: postEntity, items: postEntity.comments)
                    ]
                )
            }
            .disposed(by: viewModel.disposeBag)
    }
}
