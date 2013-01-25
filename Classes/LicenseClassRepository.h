//
//  LicenseClassRepository.h
//  safecell
//
//  Created by Mobisoft Infotech on 8/23/10.
//  Copyright 2010 University of Houston. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractRepository.h"
#import "SCLicenseClass.h"


@interface LicenseClassRepository : AbstractRepository {

}

-(void) saveLicenseClass: (SCLicenseClass *) licenseClass;
-(void) updateLicenseClass: (SCLicenseClass *) licenseClass;
-(void) saveOrUpdateLicenseClass: (SCLicenseClass *) licenseClass;

-(BOOL) licenseClassExists: (int) licenseClassId;

-(NSString *) nameForLicenseClassKey: (NSString *) licenseClassKey;
-(NSArray *) allLicenseClasses;

@end
