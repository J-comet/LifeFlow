//
//  HomeVC.swift
//  LifeFlow
//
//  Created by 장혜성 on 2023/11/28.
//

import UIKit

import RxSwift
import RxCocoa
import RxGesture
import Then

final class HomeVC: BaseViewController<HomeView, HomeViewModel> {
    
    private let navTitleLabel = NavTitleLabel().then {
        $0.text = "Life Flow"
    }
    
    private let rightBarButton = UIBarButtonItem(
        image: UIImage(systemName: "heart")?.defaultIconStyle,
        style: .plain,
        target: nil,
        action: nil
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        configureVC()
        
        viewModel.getPosts()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reloadPostObserver),
            name: .reloadPost,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(editPostObserver),
            name: .editPost,
            object: nil
        )
    }
    
    @objc
    func reloadPostObserver() {
        viewModel.resetData()
        viewModel.getPosts()
    }
    
    @objc
    func editPostObserver(notification: Notification) {
        guard let key = notification.userInfo?[NotificationKey.reloadDetailPost] as? PostEntity else { return }
        let editPosts = viewModel.posts.value.map {
            if $0.id == key.id {
                return key
            } else {
                return $0
            }
        }
        viewModel.posts.accept(editPosts)
    }
}


extension HomeVC {
    
    func bindViewModel() {
        
        //        mainView.tableView
        //            .rx
        //            .didEndDisplayingCell
        //            .bind(with: self) { owner, endDisplayingCellEvent in
        //                guard let cell = endDisplayingCellEvent.cell as? HomeTableCell else { return }
        //                cell.disposeBag = DisposeBag()
        //            }
        //            .disposed(by: viewModel.disposeBag)
        
        mainView.tableView
            .rx
            .didScroll
            .bind(with: self) { owner, _ in
                let offSetY = owner.mainView.tableView.contentOffset.y
                let contentHeight = owner.mainView.tableView.contentSize.height
                if offSetY > (contentHeight - owner.mainView.tableView.frame.size.height - 100) {
                    if owner.viewModel.isNext && !owner.viewModel.isLoading.value {
                        owner.viewModel.getPosts()
                    }
                }
            }
            .disposed(by: viewModel.disposeBag)
        
        
        viewModel.posts
            .asDriver(onErrorJustReturn: [])
            .drive(mainView.tableView.rx.items(cellIdentifier: HomeTableCell.identifier, cellType: HomeTableCell.self)) { (row, element, cell) in
                cell.selectionStyle = .none
                
                cell.moveDetail = {
                    let vc = PostDetailVC(
                        viewModel: PostDetailViewModel(
                            postDetail: BehaviorRelay(value: element),
                            postRepository: PostRespository(),
                            commentRepository: CommentRepository()
                        )
                    )
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: false)
                }
                
                // 좋아요뷰
                cell.heartView
                    .rx
                    .tapGesture()
                    .when(.recognized)
                    .asDriver { _ in .never() }
                    .drive(with: self, onNext: { owner, tap in
                        print(element.title + "좋아요 클릭")
                    })
                    .disposed(by: cell.disposeBag)
                
                // 더보기 버튼
                cell.moreContentButton
                    .rx
                    .tap
                    .bind(with: self) { owner, _ in
                        let posts = owner.viewModel.posts.value.map {
                            var post = $0
                            if post.id == element.id {
                                post.isExpand = !element.isExpand
                                post.currentImagePage = cell.currentPage.value
                            }
                            return post
                        }
                        owner.viewModel.posts.accept(posts)
                        
                    }
                    .disposed(by: cell.disposeBag)
                
                
                cell.configCell(row: element)
            }
            .disposed(by: viewModel.disposeBag)
        
        viewModel.posts
            .map { $0.isEmpty }
            .share()
            .bind(to: mainView.tableView.rx.isHidden)
            .disposed(by: viewModel.disposeBag)
        
        viewModel.posts
            .map { !$0.isEmpty }
            .asDriver(onErrorJustReturn: false)
            .drive(mainView.emptyLabel.rx.isHidden)
            .disposed(by: viewModel.disposeBag)
        
        Observable.zip(mainView.tableView.rx.itemSelected, mainView.tableView.rx.modelSelected(PostEntity.self))
            .subscribe(with: self) { owner, selectedItem in
                let vc = PostDetailVC(
                    viewModel: PostDetailViewModel(
                        postDetail: BehaviorRelay(value: selectedItem.1),
                        postRepository: PostRespository(),
                        commentRepository: CommentRepository()
                    )
                )
                vc.modalPresentationStyle = .fullScreen
                owner.present(vc, animated: false)
            }
            .disposed(by: viewModel.disposeBag)
        
        
        //        viewModel.posts
        //            .map { $0.isEmpty }
        //            .asDriver(onErrorJustReturn: false)
        //            .drive(with: self) { owner, isEmpty in
        //                owner.navigationController?.hidesBarsOnSwipe = !isEmpty
        //            }
        //            .disposed(by: viewModel.disposeBag)
        
        
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
                print(message)
                owner.showToast(msg: message)
            }
            .disposed(by: viewModel.disposeBag)
    }
    
    func configureVC() {
        navigationController?.navigationBar.backgroundColor = .white
        navigationItem.rightBarButtonItem = rightBarButton
        navigationItem.titleView = navTitleLabel
        navigationItem.backButtonDisplayMode = .minimal
    }
}
