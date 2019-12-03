//
//  modplug_extra_api.hpp
//  ModPlug
//
//  Created by Andrew Clunis on 2019-12-01.
//  Copyright © 2019 Andrew Clunis. All rights reserved.
//

#ifndef modplug_extra_api_hpp
#define modplug_extra_api_hpp

#include "modplug.h"

// modplug.h lacks some C wrappers for some C++ stuff we need access to from Swift.

#ifdef __cplusplus
extern "C" {
#endif

unsigned int ModPlug_GetCurrentPos(ModPlugFile* file);
unsigned int ModPlug_GetMaxPosition(ModPlugFile* file);

#ifdef __cplusplus
} /* extern "C" */
#endif

#endif /* modplug_extra_api_hpp */
