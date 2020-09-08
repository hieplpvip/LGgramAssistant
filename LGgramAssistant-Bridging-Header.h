//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

#import "CBBlueLightClient.h"
#include <stdbool.h>

int IOBluetoothPreferenceGetControllerPowerState();
void IOBluetoothPreferenceSetControllerPowerState(int state);

bool getCapslockState();

bool _loadOSDFramework();
void _goToSleep();
