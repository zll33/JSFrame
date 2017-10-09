//
//  XPreviewImage.m
//  p2p
//
//  Created by zhangxiuquan on 15/5/27.
//  Copyright (c) 2015年 zhangxiuquan. All rights reserved.
//

#import "XPreviewImage.h"
#import "MWPhotoBrowser.h"
#import "SDImageCache.h"
#import "MWCommon.h"
#import "XHeader.h"
@interface XPreviewImage()
@property NSMutableArray *photos;
@property NSMutableArray *msg;
@end
@implementation XPreviewImage

-(void)onItemClickImage
{

}


#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return  self.photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.photos.count)
        return [self.photos objectAtIndex:index];
    return nil;
}

- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index
{
    return [NSString stringWithFormat:@"%d/%d",(int)index,(int)self.photos.count];
}
- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser describeForPhotoAtIndex:(NSUInteger)index
{
    if (index < self.msg.count)
        return [ self.msg objectAtIndex:index];
    return nil;
}
@end



void showNewController(XBaseViewController* baseController, XJsonArray* urls,XJsonArray* msg,int selectIndex)
{

    XPreviewImage *previewImage = [XPreviewImage new];
    previewImage.photos = [XJsonArray new];
    previewImage.msg = msg;
    MWPhoto *photo;
    for (int i=0; i<urls.count; i++) {
        NSString* ulr = [urls objectAtIndex:i];
        [previewImage.photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:ulr]]];
    }
    
    // Create browser
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:previewImage];
    browser.displayActionButton = NO;
    browser.displayNavArrows = NO;
    browser.displaySelectionButtons = NO;
    browser.alwaysShowControls = YES;
    browser.zoomPhotosToFill = YES;
    if ([msg count]>0) {
        browser.displayDescribe = YES;
    }
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    browser.wantsFullScreenLayout = YES;
#endif
    browser.enableGrid = NO;
    browser.startOnGrid = NO;
    browser.enableSwipeToDismiss = NO;
    [browser setCurrentPhotoIndex:selectIndex];
    
    
    
    
    [baseController.navigationController pushViewController:browser animated:YES];
    
    // Test reloading of data after delay
    double delayInSeconds = 3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
    });

}
