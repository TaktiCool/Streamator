enableSaving [false, false];
enableEnvironment [false, true];
enableSentences false;
call CLib_fnc_loadModules;

JK_UAVOperator connectTerminalToUAV JK_UAV;
JK_UAV lockCameraTo [JK_UAVOperator, [0]];
