//
//  ViewController.m
//  NSUrlRequestProject
//
//  Created by Alexey Levanov on 30.11.17.
//  Copyright © 2017 Alexey Levanov. All rights reserved.
//

#import "ViewController.h"
#import "NetworkService.h"
#import "SBSProgressView.h"
#import "LCTSearchBar.h"
#import "LCTCollectionView.h"
#import "LCTPhotoViewController.h"
#import "LCTNotificationServiceProtocol.h"


#define FIRST_STEP 0
#define SECOND_STEP 0
#define THIRD_STEP 0
#define FLICKR 1

static const CGFloat imageOffset = 100.f;

@interface ViewController () <NetworkServiceOutputProtocol, LCTCollectionViewProtocol, LCTSearchBarProtocol, LCTPhotoViewControllerProtocol>

@property (nonatomic, strong) UIImageView *imageView;
//@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) SBSProgressView *progressView;
@property (nonatomic, strong) UIButton *cancelDownloadButton;
@property (nonatomic, strong) UIButton *resumeDownloadButton;
@property (nonatomic, strong) LCTSearchBar *searchBar;
@property (nonatomic, strong) LCTCollectionView *collectionView;
@property (nonatomic, strong) NSString *searchString;

@property (nonatomic, strong) NetworkService *networkService;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
#if FIRST_STEP
    // Простейший способ - STEP 1
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:@"https://itunes.apple.com/search?term=apple&media=software"] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error)
        {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"%@", json);
        }
        else
        {
            NSLog(@"Error occured!");
        }
    }];
    
    [dataTask resume];
#endif
    
#if SECOND_STEP
    [self prepareUI];
    self.networkService = [NetworkService new];
    self.networkService.output = self;
    [self.networkService startImageLoading];
#endif
   
#if THIRD_STEP
    [self prepareUI];
    self.networkService = [NetworkService new];
    self.networkService.output = self;
    [self.networkService configureUrlSessionWithParams:nil];
    [self.networkService startImageLoading];
#endif
    
#if FLICKR
    [self prepareUIFlickr];
    self.networkService = [NetworkService new];
    self.networkService.output = self;
    self.searchString = @"Nature";
    [self.networkService findFlickrPhotoWithSearchString:@"Nature" forPage:1];
#endif
}

- (void)prepareUI
{
    self.imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    self.imageView.contentMode = UIViewContentModeCenter;
    [self.view addSubview:self.imageView];
    
    self.progressView = [[SBSProgressView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    self.progressView.frame = CGRectMake(imageOffset, self.view.center.y - imageOffset/2, CGRectGetWidth(self.view.frame) - imageOffset*2, imageOffset);
    [self.view addSubview:self.progressView];
    
    // NEXT STEP
    self.resumeDownloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.resumeDownloadButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.resumeDownloadButton setTitle:@"Запустить" forState:UIControlStateNormal];
    [self.resumeDownloadButton addTarget:self action:@selector(resumeDownloadAction) forControlEvents:UIControlEventTouchUpInside];
    self.resumeDownloadButton.frame =CGRectMake(imageOffset, CGRectGetHeight(self.view.frame) - imageOffset * 2, imageOffset, imageOffset);
    self.resumeDownloadButton.hidden = YES;
    [self.view addSubview:self.resumeDownloadButton];
    
    self.cancelDownloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancelDownloadButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.cancelDownloadButton setTitle:@"Остановить" forState:UIControlStateNormal];
    [self.cancelDownloadButton addTarget:self action:@selector(suspendDownLoadAction) forControlEvents:UIControlEventTouchUpInside];
    self.cancelDownloadButton.frame = CGRectMake(CGRectGetWidth(self.view.frame) - 2*imageOffset, CGRectGetHeight(self.view.frame) - imageOffset * 2, imageOffset, imageOffset);
    [self.view addSubview:self.cancelDownloadButton];
}


- (void)prepareUIFlickr
{
    self.searchBar = [[LCTSearchBar alloc] initWithFrame:CGRectMake(0, 20, CGRectGetWidth(self.view.frame), 50)];
    self.searchBar.output = self;
//    [self.view addSubview:self.searchBar];
    self.navigationItem.titleView = self.searchBar;
    
    self.collectionView = [LCTCollectionView createCollectionView:CGRectMake(0, 1, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 1)];
    self.collectionView.output = self;
    [self.view addSubview:self.collectionView];
}


// STEP 3
- (NSURLSession *)configuredNSURLSession
{
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    // Настравиваем Session Configuration
    [sessionConfiguration setAllowsCellularAccess:YES];
    [sessionConfiguration setHTTPAdditionalHeaders:@{ @"Accept" : @"application/json" }];
    
    // Создаем сессию
    return [NSURLSession sessionWithConfiguration:sessionConfiguration];
}

- (void)resumeDownloadAction
{
    if ([self.networkService resumeNetworkLoading])
    {
        self.resumeDownloadButton.hidden = YES;
        self.cancelDownloadButton.hidden = NO;
    }
}

- (void)suspendDownLoadAction
{
    [self.networkService suspendNetworkLoading];
    self.resumeDownloadButton.hidden = NO;
    self.cancelDownloadButton.hidden = YES;
}


#pragma mark - NetworkServiceOutput

- (void)loadingIsDoneWithDataRecieved:(NSData *)dataRecieved
{
    [self.progressView setHidden:YES];
    self.cancelDownloadButton.hidden = YES;
    self.resumeDownloadButton.hidden = YES;
    [self.imageView setImage:[UIImage imageWithData:dataRecieved]];
}

- (void)loadingContinuesWithProgress:(double)progress
{
    self.progressView.progress = progress;
}


- (void)FlickrLoadingIsDone:(NSData *)dataRecieved
{
    UIImage *image = [UIImage imageWithData:dataRecieved];
    if (image)
    {
        [self.collectionView.arrayImage addObject:[UIImage imageWithData:dataRecieved]];
        [self.collectionView reloadData];
    }
}


- (void)flickrSearch:(NSString *)searchString
{
    [self.collectionView.arrayImage removeAllObjects];
    [self.collectionView reloadData];
    self.searchString = searchString;
    self.collectionView.page = 1;
    [self.networkService findFlickrPhotoWithSearchString:searchString forPage:1];
}

- (void)editingPhoto:(UIImage *)photo forIndex:(NSIndexPath *)indexPath
{
    LCTPhotoViewController *photoViewController = [LCTPhotoViewController new];
    photoViewController.photo = photo;
    photoViewController.indexPath = indexPath;
    photoViewController.output = self;
    [self.navigationController pushViewController:photoViewController animated:YES];
}


- (void)addEditingPhoto:(UIImage *)photo forIndex:(NSIndexPath *)indexPath
{
    [self.collectionView.arrayImage replaceObjectAtIndex:indexPath.row withObject:photo];
    [self.collectionView reloadData];
}


- (void)downloadNewPage:(NSInteger)page
{
    [self.networkService findFlickrPhotoWithSearchString:self.searchString forPage:page];
}


- (void)searchPhotoForNotification:(NSString *)searchString
{
    [self.collectionView.arrayImage removeAllObjects];
    [self.collectionView reloadData];
    self.searchString = searchString;
    self.collectionView.page = 1;
    self.searchBar.text = searchString;
    [self.networkService findFlickrPhotoWithSearchString:searchString forPage:1];
}


- (void)showAlert:(NSString *)textAlert
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Ошибка"
                                                                             message:textAlert
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    //We add buttons to the alert controller by creating UIAlertActions:
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                       style:UIAlertActionStyleCancel
                                                     handler:nil]; //You can use a block here to handle a press on this button
    [alertController addAction:actionOk];
    [self presentViewController:alertController animated:YES completion:nil];
}



@end
