----------------------------------------------------------------------------
--  Permission to use, copy, modify, and distribute this software for any
--  purpose with or without fee is hereby granted, provided that the above
--  copyright notice and this permission notice appear in all copies.
--
--  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
--  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
--  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
--  ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
--  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
--  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
--  OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
----------------------------------------------------------------------------

with System;
with Interfaces;
with Interfaces.C;
with Interfaces.C.Pointers;
with Interfaces.C.Strings;
with Ada.Containers.Indefinite_Vectors;

package AdaAugeas is

   pragma Elaborate_Body;

   package String_Vectors is new Ada.Containers.Indefinite_Vectors
     (Natural, String);
   use String_Vectors;

   subtype aug_flags is Interfaces.C.unsigned;
   AUG_NONE                 : constant aug_flags := 0;
   AUG_SAVE_BACKUP          : constant aug_flags := 1;
   AUG_SAVE_NEWFILE         : constant aug_flags := 2;
   AUG_TYPE_CHECK           : constant aug_flags := 4;
   AUG_NO_STDINC            : constant aug_flags := 8;
   AUG_SAVE_NOOP            : constant aug_flags := 16;
   AUG_NO_LOAD              : constant aug_flags := 32;
   AUG_NO_MODL_AUTOLOAD     : constant aug_flags := 64;
   AUG_ENABLE_SPAN          : constant aug_flags := 128;
   AUG_NO_ERR_CLOSE         : constant aug_flags := 256;
   AUG_TRACE_MODULE_LOADING : constant aug_flags := 512;

   type Augeas_Type is private;

   Null_Augeas : constant Augeas_Type;

   procedure Close (Aug : in out Augeas_Type);

   function Copy (Aug : Augeas_Type; Src : String; Dst : String)
       return Integer;

   function Get (Aug : Augeas_Type; Path : String) return String;

   function Init
     (Aug  : out Augeas_Type; Root : String; Loadpath : String;
      Flag :     aug_flags) return Integer;

   function Match (Aug : Augeas_Type; Path : String)
       return String_Vectors.Vector;

   function Move (Aug : Augeas_Type; Src : String; Dst : String)
       return Integer;

   function Remove (Aug : Augeas_Type; Path : String) return Integer;

   function Save (Aug : Augeas_Type) return Integer;

   function Set
     (Aug : Augeas_Type; Path : String; Value : String) return Integer;

   function Setm
     (Aug : Augeas_Type; Base : String; Sub : String; Value : String)
      return Integer;

private

   type Augeas_Type is new System.Address;

   Null_Augeas : constant Augeas_Type := Augeas_Type (System.Null_Address);

   subtype CNatural is Interfaces.C.int range 0 .. Interfaces.C.int'Last;

   type Vector is array (CNatural range <>) of
      aliased Interfaces.C.Strings.chars_ptr;

   package Match_Pointer is new Interfaces.C.Pointers (Index => CNatural,
      Element => Interfaces.C.Strings.chars_ptr, Element_Array => Vector,
      Default_Terminator => Interfaces.C.Strings.Null_Ptr);

   --  This is C char **
   subtype Chars_Ptr_Ptr is Match_Pointer.Pointer;

end AdaAugeas;
