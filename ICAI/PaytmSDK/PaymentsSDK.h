//
//  PaymentsSDK.h
//  PaymentsSDK
//
//  Copyright (c) 2012-2015 Paytm Mobile Solutions Ltd. All rights reserved.

#ifndef __PAYMENTS_SDK_H__
#define __PAYMENTS_SDK_H__

#import <Foundation/Foundation.h>

#import "PGTransactionViewController.h"
#import "PGMerchantConfiguration.h"
#import "PGServerEnvironment.h"
#import "PGOrder.h"

#define PGSDK_VERSION   @"2.5"

//Version 2.4 - Compiled using Xcode 7.1 with Bit Code enabled

#ifdef DEBUG
#define DEBUGLOG    NSLog
#else
#define DEBUGLOG(x,...) //
#endif

#define CFSafeRelease(x) if (x != nil) CFRelease(x);

#endif
