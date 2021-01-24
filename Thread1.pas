unit Thread1;

{$mode objfpc}{$H+}

interface

uses
//    RaspberryPi,
    QEMUVersatilePB,
    GlobalConfig,
    GlobalConst,
    GlobalTypes,
    Platform,
    Threads,
    SysUtils,
    Classes,
    Ultibo,       {The Ultibo unit provides some APIs for getting and setting timezones}
    Console,
    GraphicsConsole,
    freetypeh,
    Devices,
    I2C,
    DS1307,       {This unit allows configuration and use of the RTC}
    RTC,          {useful RTC functions}
    Keyboard,     {Keyboard uses USB so that will be included automatically}
    DWCOTG,       {We need to include the USB host driver for the Raspberry Pi}
    Timezone,
    DateUtils;

function Thread1Execute(Parameter:Pointer):PtrInt;

implementation

function Thread1Execute(Parameter:Pointer):PtrInt;


const


OneYear:int64 =365.2425*24*60*60*10000000;
OneMonth:int64 =30*24*60*60*10000000;
OneDay:int64 =24*60*60*10000000;
OneHour:int64 =60*60*10000000;
OneMin:int64 =60*10000000;
OneSec:int64 =10000000;



var
Console1:TWindowHandle;
Character:Char = #0;  {keyboard presses}
newDateTime: int64 =0; {for changing RTC time}
RTCyesno: bool =FALSE;

procedure WaitForSDDrive;
begin
  while not DirectoryExists ('C:\') do sleep (500);
end;

procedure Log (s : string);
begin
   ConsoleWindowWriteLn (Console1, s);
end;

begin
  Thread1Execute:=0;

   Console1:=ConsoleWindowCreate(ConsoleDeviceGetDefault,CONSOLE_POSITION_BOTTOM,False);

   ThreadSetName(GetCurrentThreadId,'Example Thread1');
 {see if the RTC is available}
 if RTCAvailable and (RTCGetTime > 131908059360000000) then
     begin
     RTCyesno :=TRUE;
     Log('RTC Available');
     Log(DateTimeToStr(Now));
     end
 else
     begin
       RTCyesno :=FALSE;
       Log('RTC Not Available');
       RtcSetTime(131908059360000000); //2019
       Log(DateTimeToStr(Now));
     end;

  while True do
  begin

   {Read a character from the global keyboard buffer. If multiple keyboards are connected all characters will end up in a single buffer and be received here}
   if ConsoleGetKey(Character,nil) then
   begin
   newDateTime: = 0;
   case Character of
        #0:  begin     {if shift is held for increasing values, read second character}
                  ConsoleGetKey(Character,nil);
                  end;
        'Y':  begin
                  Log('Y pressed, Increase year by 1');
                  newDateTime:= RTCGetTime+OneYear;
                  end;
        'N': begin
                  Log('N pressed, Increase month by 1');
                  newDateTime:= RTCGetTime+OneMonth;
                  end;
        'D': begin
                     Log('D pressed, Increase day by 1');
                     newDateTime:= RTCGetTime+OneDay;
                  end;
        '7': begin
                      Log('7 pressed, Increase hour by 1');
                      newDateTime:= RTCGetTime+OneHour;
                  end;
        '8': begin
                      Log('8 pressed, Increase minute by 1');
                      newDateTime:= RTCGetTime+OneMin;
                      end;
        '9': begin
                        Log('9 pressed, Increase second by 1');
                        newDateTime:= RTCGetTime+OneSec;
                        end;
        'y': begin
                Log('y pressed, Decrease year by 1');
                  newDateTime:= RTCGetTime-OneYear;
                  end;
      'n': begin
                Log('n pressed, Decrease month by 1');
                  newDateTime:= RTCGetTime-OneMonth;
                  end;
      'd':  begin
                Log('d pressed, Decrease day by 1');
                  newDateTime:= RTCGetTime-OneDay;
                  end;
      '4': begin
                Log('4 pressed, Decrease hour by 1');
                  newDateTime:= RTCGetTime-OneHour;
                  end;
      '5': begin
                Log('5 pressed, Decrease minute by 1');
                  newDateTime:= RTCGetTime-OneMin;
                  end;
      '6': begin
                Log('6 pressed, Decrease second by 1');
                  newDateTime:= RTCGetTime-OneSec;
                  end;
     end;    {end of  case statement}
     RTCSetTime(RTCGetTime+newDateTime);
   end;

   end;    {end of if button pressed statement}

    end;
   end.
