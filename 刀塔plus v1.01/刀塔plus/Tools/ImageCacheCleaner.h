//
//  ClearSDWebImageCache.h
//  刀塔plus
//
//  Created by 峰哥哥-.- on 15/6/26.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import <Foundation/Foundation.h>
/**清除SDWebImageCache图片缓存的类*/
@interface ImageCacheCleaner : NSObject

@property(nonatomic,strong)NSString *imageCachePath;

/**单例类*/
+(instancetype)currentCleaner;

/**清除缓存*/
-(void)clearImageCache;

/**计算缓存大小*/
-(NSString *)caculateCacheSize;

@end
