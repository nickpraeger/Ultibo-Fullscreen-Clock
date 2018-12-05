unit BMPtoBuffer;

{$mode delphi}{$H+}

interface

uses
QEMUVersatilePB,
//RaspberryPi, {Include the RaspberryPi unit to give us network, filesystem etc}
  GlobalConst,
  GlobalTypes,
  Threads,
  Console,
  GraphicsConsole, {Include the GraphicsConsole unit so we can create a graphics window}
  BMPcomn,         {Include the BMPcomn unit from the fpc-image package to give the Bitmap headers}
  Classes,         {Include the Classes unit for the TFileStream class}
  SysUtils;

{A function for drawing a bitmap image onto an Ultibo graphics console window from a memory buffer}
function DrawBitmapFromBuffer(Handle:TWindowHandle;const Buf;Len,X,Y:LongWord):Boolean;

implementation
function DrawBitmapFromBuffer(Handle:TWindowHandle;const Buf;Len,X,Y:LongWord):Boolean;

var
 Size:LongWord;
 Count:LongWord;
 Offset:LongWord;
 Format:LongWord;
 Buffer:Pointer;
 TopDown:Boolean;
 LineSize:LongWord;
 ReadSize:LongWord;

 BitMapFileHeader:PBitMapFileHeader;
 BitMapInfoHeader:PBitMapInfoHeader;

  begin
   {}
   Result:=False;

   {This is a variation of the earlier example that showed how to load a bitmap from a file and draw it on the
    screen in Ultibo, this version takes a memory buffer and a length and loads the bitmap from that instead.

    It still creates a memory buffer and puts the pixels onto the screen using GraphicsWindowDrawImage() so
    you could make this more efficient by not copying the image to a buffer first}

   {Check the parameters}
   if Handle = INVALID_HANDLE_VALUE then Exit;

   {Check the length}
   if Len < (SizeOf(TBitMapFileHeader) + SizeOf(TBitMapInfoHeader)) then Exit;

   {Get the Bitmap file header}
   BitMapFileHeader:=PBitMapFileHeader(@Buf);

   {Check the magic number in the header}
   if BitMapFileHeader.bfType = BMmagic then
    begin
     {Get the Bitmap info header}
     BitMapInfoHeader:=PBitMapInfoHeader(@Buf + SizeOf(TBitMapFileHeader));

     {Most Bitmaps are stored upside down, but they can be right way up}
     TopDown:=(BitMapInfoHeader.Height < 0);
     BitMapInfoHeader.Height:=Abs(BitMapInfoHeader.Height);

     {Check how many bits per pixel in this Bitmap, we only support 16, 24 and 32 in this function}
     if BitMapInfoHeader.BitCount = 16 then
      begin
       {Check the compression format used, this function only supports raw RGB bitmaps so far}
       if BitMapInfoHeader.Compression = BI_RGB then
        begin
         {Get the color format}
         Format:=COLOR_FORMAT_RGB15;
         {Now get the bytes per line}
         LineSize:=BitMapInfoHeader.Width * 2;
         {And also determine the actual number of bytes until the next line}
         ReadSize:=(((BitMapInfoHeader.Width * 8 * 2) + 31) div 32) shl 2;
        end
       else
        begin
         Exit;
        end;
      end
     else if BitMapInfoHeader.BitCount = 24 then
      begin
       {Check the compression}
       if BitMapInfoHeader.Compression = BI_RGB then
        begin
         {Color format, bytes per line and actual bytes as again}
         Format:=COLOR_FORMAT_RGB24;
         LineSize:=BitMapInfoHeader.Width * 3;
         ReadSize:=(((BitMapInfoHeader.Width * 8 * 3) + 31) div 32) shl 2;
        end
       else
        begin
         Exit;
        end;
      end
     else if BitMapInfoHeader.BitCount = 32 then
      begin
       {Check the compression}
       if BitMapInfoHeader.Compression = BI_RGB then
        begin
         {Color format, bytes per line and actual bytes as again}
         Format:=COLOR_FORMAT_URGB32;
         LineSize:=BitMapInfoHeader.Width * 4;
         ReadSize:=(((BitMapInfoHeader.Width * 8 * 4) + 31) div 32) shl 2;
        end
       else
        begin
         Exit;
        end;
      end
     else
      begin
       Exit;
      end;

     {Get the size of the Bitmap image not including the headers, just the actual pixels}
     Size:=LineSize * BitMapInfoHeader.Height;

     {Allocate a buffer to hold all the pixels}
     Buffer:=GetMem(Size);
     try
      Offset:=0;

      {Check for a which way up}
      if TopDown then
       begin
        {Right way up is a rare case}
        for Count:=0 to BitMapInfoHeader.Height - 1 do
         begin
          {Read a full line of pixels from the buffer}
          System.Move((@Buf + BitMapFileHeader.bfOffset + (Count * ReadSize))^, (Buffer + Offset)^,LineSize);

          {Update the offset of our buffer}
          Inc(Offset,LineSize);
         end;
       end
      else
       begin
        {Upside down is the normal case}
        for Count:=BitMapInfoHeader.Height - 1 downto 0 do
         begin
          {Read a full line of pixels from the buffer}
          System.Move((@Buf + BitMapFileHeader.bfOffset + (Count * ReadSize))^, (Buffer + Offset)^,LineSize);

          {Update the offset of our buffer}
          Inc(Offset,LineSize);
         end;
       end;

      {Draw the entire image onto our graphics console window in one request}
      if GraphicsWindowDrawImage(Handle,X,Y,Buffer,BitMapInfoHeader.Width,BitMapInfoHeader.Height,Format) <> ERROR_SUCCESS then Exit;

      Result:=True;
     finally
      FreeMem(Buffer);
     end;
    end;
  end;
end.


