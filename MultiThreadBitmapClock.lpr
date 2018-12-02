program MultiThreadBitmapClock;

{$mode objfpc}{$H+}

{ QEMU VersatilePB Application                                                 }
{  Add your program code below, add additional units to the "uses" section if  }
{  required and create new units by selecting File, New Unit from the menu.    }
{                                                                              }
{  To compile your program select Run, Compile (or Run, Build) from the menu.  }

uses
//  RaspberryPi,
  QEMUVersatilePB,
  GlobalConfig,
  GlobalConst,
  GlobalTypes,
  Platform,
  Threads,
  SysUtils,
  Classes,
  Ultibo,
  Console,
  Thread1,
  Thread2
  { Add additional units here };

var
 Thread1Handle:TThreadHandle;
 Thread2Object:TThread2Object;

begin

  Thread1Handle:=BeginThread(@Thread1Execute,nil,Thread1Handle,THREAD_STACK_DEFAULT_SIZE);
{ if Thread1Handle = INVALID_HANDLE_VALUE then
  begin
   {If the thread handle is not valid then BeginThread failed}
   ConsoleWindowWriteLn(WindowHandle,'Failed to create Thread1');
  end
 else
  begin
   {Otherwise the thread was created and will start running soon, we have a handle
    to reference it if we want. The Thread1Execute function is in the Thread1 unit,
    have a look there to see what it will be doing.}
   ConsoleWindowWriteLn(WindowHandle,'Thread1 was created successfully, the handle is ' + IntToHex(Thread1Handle,8));

   {Let's wait a bit to see what happens}
   Sleep(5000);
  end;
 ConsoleWindowWriteLn(WindowHandle,'');
 }
  {Now let's create a thread using the TThread class to see how that differs.
  We need to create a class derived from TThread in order to define what work our
  new thread should do. The class for our thread is in the Thread2 unit.}
// ConsoleWindowWriteLn(WindowHandle,'Creating Thread2 using TThread2Object');
 Thread2Object:=TThread2Object.Create(False,THREAD_STACK_DEFAULT_SIZE);
{
 {We assume our thread was created successfully, we can check from the object what
  the thread handle is and use it in other functions.}
 ConsoleWindowWriteLn(WindowHandle,'Thread2 was created successfully, the handle is ' + IntToHex(Thread2Object.ThreadID,8));
 ConsoleWindowWriteLn(WindowHandle,'');

 {Say goodbye from this thread}
 ConsoleWindowWriteLn(WindowHandle,'Goodbye from ' + ThreadGetName(GetCurrentThreadId) + ', my ID is ' + IntToHex(GetCurrentThreadId,8));

 {We haven't talked about locks and synchronization in this example. Ultibo supports
  a full range of locking and synchronization primitives which are very important as
  soon as you start to use multiple threads. See the wiki and other resources for
  more information on these and other topics to do with multi thread programming.}
 }
 {Halt thread, the others will keep running}
 ThreadHalt(0);
end.
