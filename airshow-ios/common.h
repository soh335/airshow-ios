//
//  common.h
//  airshow-ios
//
//  Created by soh335 on 2013/08/22.
//  Copyright (c) 2013年 soh335. All rights reserved.
//

#ifndef airshow_ios_common_h
#define airshow_ios_common_h

#ifdef DEBUG
#define ASWDebugLog(...) NSLog(__VA_ARGS__)
#else
#define ASWDebugLog(...) ;
#endif

#endif
