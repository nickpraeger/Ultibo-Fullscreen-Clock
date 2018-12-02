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
 if RTCAvailable and (RTCGetTime <>0) then
     begin
       RTCyesno :=TRUE;
       Log('RTC Available');
     end
 else
     begin
       RTCyesno :=FALSE;
       Log('RTC Not Available');
     end;

  while True do
  begin

   {Read a character from the global keyboard buffer. If multiple keyboards are connected all characters will end up in a single buffer and be received here}
   if ConsoleGetKey(Character,nil) then
   begin
   case Character of
        #0:  begin     {if shift is held for increasing values, read second character}
                  ConsoleGetKey(Character,nil);
                  end;
        'Y':  begin
                  Log('Y pressed, Increase year by 1');
                  SetCurrentTimezone('Greenwich Standard Time ');
                  newDateTime:= DateTimeToFileDate(IncYear(Now,1));  {increase year by 1 when Y is pressed}
                  ClockSetTime(newDateTime,RTCyesno);
                  SetCurrentTimezone('GMT Standard Time');
                  Log(DateTimeToStr(Now));
                  end;
        'N': begin
                  Log('N pressed, Increase month by 1');
                  SetCurrentTimezone('Greenwich Standard Time ');
                  newDateTime:= DateTimeToFileDate(IncMonth(Now,1));  {increase month by 1 when N is pressed}
                  ClockSetTime(newDateTime,RTCyesno);
                  SetCurrentTimezone('GMT Standard Time');
                  Log(DateTimeToStr(Now));
                  end;
        'D': begin
                     Log('D pressed, Increase day by 1');
                     SetCurrentTimezone('Greenwich Standard Time ');
                     newDateTime:= DateTimeToFileDate(IncDay(Now,1));  {increase day by 1 when D is pressed}
                     ClockSetTime(newDateTime,RTCyesno);
                     SetCurrentTimezone('GMT Standard Time');
                     Log(DateTimeToStr(Now));
                     end;
        'H': begin
                      Log('H pressed, Increase hour by 1');
                      SetCurrentTimezone('Greenwich Standard Time ');
                      newDateTime:= DateTimeToFileDate(IncHour(Now,1));  {increase hour by 1 when H is pressed}
                      ClockSetTime(newDateTime,RTCyesno);
                      SetCurrentTimezone('GMT Standard Time');
                      Log(DateTimeToStr(Now));
                      end;
        'M': begin
                      Log('M pressed, Increase minute by 1');
                      SetCurrentTimezone('Greenwich Standard Time ');
                      newDateTime:= DateTimeToFileDate(IncMinute(Now,1));  {increase minute by 1 when M is pressed}
                      ClockSetTime(newDateTime,RTCyesno);
                      SetCurrentTimezone('GMT Standard Time');
                      Log(DateTimeToStr(Now));
                      end;
        'S': begin
                      Log('S pressed, Increase second by 1');
                      SetCurrentTimezone('Greenwich Standard Time ');
                      newDateTime:= DateTimeToFileDate(IncSecond(Now,1));  {increase second by 1 when S is pressed}
                      ClockSetTime(newDateTime,RTCyesno);
                      SetCurrentTimezone('GMT Standard Time');
                      Log(DateTimeToStr(Now));
                      end;
        'y': begin
                Log('y pressed, Decrease year by 1');
                SetCurrentTimezone('Greenwich Standard Time ');
                newDateTime:= DateTimeToFileDate(IncYear(Now,-1));  {decrease year by 1 when y is pressed}
                ClockSetTime(newDateTime,RTCyesno);
                SetCurrentTimezone('GMT Standard Time');
                Log(DateTimeToStr(Now));
                end;
      'n': begin
                Log('n pressed, Decrease month by 1');
                SetCurrentTimezone('Greenwich Standard Time ');
                newDateTime:= DateTimeToFileDate(IncMonth(Now,-1));  {decrease month by 1 when n is pressed}
                ClockSetTime(newDateTime,RTCyesno);
                SetCurrentTimezone('GMT Standard Time');
                Log(DateTimeToStr(Now));
                end;
      'd':  begin
                Log('d pressed, Decrease day by 1');
                SetCurrentTimezone('Greenwich Standard Time ');
                newDateTime:= DateTimeToFileDate(IncDay(Now,-1));  {decrease day by 1 when d is pressed}
                ClockSetTime(newDateTime,RTCyesno);
                SetCurrentTimezone('GMT Standard Time');
                Log(DateTimeToStr(Now));
                end;
      'h': begin
                Log('h pressed, Decrease hour by 1');
                SetCurrentTimezone('Greenwich Standard Time ');
                newDateTime:= DateTimeToFileDate(IncHour(Now,-1));  {decrease hour by 1 when h is pressed}
                ClockSetTime(newDateTime,RTCyesno);
                SetCurrentTimezone('GMT Standard Time');
                Log(DateTimeToStr(Now));
                end;
      'm': begin
                Log('m pressed, Decrease minute by 1');
                SetCurrentTimezone('Greenwich Standard Time ');
                newDateTime:= DateTimeToFileDate(IncMinute(Now,-1));  {decrease minute by 1 when m is pressed}
                ClockSetTime(newDateTime,RTCyesno);
                SetCurrentTimezone('GMT Standard Time');
                Log(DateTimeToStr(Now));
                end;
      's': begin
                Log('s pressed, Decrease second by 1');
                SetCurrentTimezone('Greenwich Standard Time ');
                newDateTime:= DateTimeToFileDate(IncSecond(Now,-1));  {decrease second by 1 when s is pressed}
                ClockSetTime(newDateTime,RTCyesno);
                SetCurrentTimezone('GMT Standard Time');
                Log(DateTimeToStr(Now));
                end;
     end;    {end of  case statement}
   end;

   end;    {end of if button pressed statement}

    end;
   end.
