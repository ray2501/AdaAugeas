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

with Interfaces.C;         use Interfaces.C;
with Interfaces.C.Strings; use Interfaces.C.Strings;

package body AdaAugeas is

   pragma Linker_Options ("-laugeas");

   use Interfaces;

   --
   --  Close this Augeas instance and free any storage associated with it.
   --
   procedure Aug_Close (aug : Augeas_Type);
   pragma Import (C, Aug_Close, "aug_close");

   procedure Close (Aug : in out Augeas_Type) is
   begin
      if Aug /= Null_Augeas then
         Aug_Close (Aug);
      end if;
      Aug := Null_Augeas;
   end Close;

   --
   --  Copy the node SRC to DST.
   --  0 on success and -1 on failure.
   --
   function Aug_Cp
     (Aug : Augeas_Type; src : chars_ptr; dst : chars_ptr)
      return Interfaces.C.int;
   pragma Import (C, Aug_Cp, "aug_cp");

   function Copy (Aug : Augeas_Type; Src : String; Dst : String) return Integer
   is
      MySrc  : chars_ptr := New_String (Src);
      MyDst  : chars_ptr := New_String (Dst);
      Result : Interfaces.C.int;
   begin
      if Aug = Null_Augeas then
         Free (MySrc);
         Free (MyDst);
         return -1;
      end if;

      Result := Aug_Cp (Aug, MySrc, MyDst);
      Free (MySrc);
      Free (MyDst);
      return Integer (Result);
   end Copy;

   --
   --  Lookup the value associated with PATH.
   --
   function Aug_Get
     (aug : Augeas_Type; path : chars_ptr; value : access chars_ptr)
      return int;
   pragma Import (C, Aug_Get, "aug_get");

   function Get (Aug : Augeas_Type; Path : String) return String is
      MyPath    : chars_ptr := New_String (Path);
      Value_Ptr : aliased chars_ptr;
      Result    : Interfaces.C.int;
   begin
      if Aug = Null_Augeas then
         Free (MyPath);
         return "";
      end if;

      Result := Aug_Get (Aug, MyPath, Value_Ptr'Access);

      Free (MyPath);
      if Result <= 0 then
         return "";
      end if;

      --  VALUE can be NULL.
      if Value_Ptr = Null_Ptr then
         return "";
      else
         return Value (Value_Ptr, Strlen (Value_Ptr));
      end if;
   end Get;

   --
   --  Initialize the library.
   --
   function Aug_Init
     (root : chars_ptr; loadpath : chars_ptr; flag : aug_flags)
      return Augeas_Type;
   pragma Import (C, Aug_Init, "aug_init");

   function Init
     (Aug  : out Augeas_Type; Root : String; Loadpath : String;
      Flag :     aug_flags) return Integer
   is
      MyRoot     : chars_ptr := New_String (Root);
      MyLoadpath : chars_ptr := New_String (Loadpath);
   begin
      Aug := Aug_Init (MyRoot, MyLoadpath, Flag);

      Free (MyRoot);
      Free (MyLoadpath);
      if Aug = Null_Augeas then
         return -1;
      end if;

      return 0;
   end Init;

   --
   --  Match the number of matches of the path expression PATH in AUG.
   --
   function Aug_Match
     (Aug : Augeas_Type; path : chars_ptr; matches : access Chars_Ptr_Ptr)
      return Interfaces.C.int;
   pragma Import (C, Aug_Match, "aug_match");

   procedure Free_Chars_Ptr (Ptr : Chars_Ptr_Ptr) with
      Import        => True,
      Convention    => C,
      External_Name => "free";

   function Match
     (Aug : Augeas_Type; Path : String) return String_Vectors.Vector
   is
      MyPath    : chars_ptr := New_String (Path);
      Array_Ptr : aliased Chars_Ptr_Ptr;
      Match_Ptr : aliased Chars_Ptr_Ptr;
      Result    : Interfaces.C.int;
      VString   : String_Vectors.Vector;
   begin
      if Aug = Null_Augeas then
         Free (MyPath);
         return VString;
      end if;

      --
      --  If MATCHES is non-NULL, an array with the returned
      --  number of elements will be allocated and filled with
      --  the paths of the matches.  The caller must free both
      --  the array and the entries in it.
      --
      Result := Aug_Match (Aug, MyPath, Match_Ptr'Access);
      Free (MyPath);
      if Result > 0 then
         Array_Ptr := Match_Ptr;
         for J in 0 .. Result - 1 loop
            if Match_Ptr.all /= Interfaces.C.Strings.Null_Ptr then
               VString.Append (Interfaces.C.Strings.Value (Match_Ptr.all));
               Free (Match_Ptr.all);
            end if;
            Match_Pointer.Increment (Match_Ptr);
         end loop;

         Free_Chars_Ptr (Array_Ptr);
      end if;

      return VString;
   end Match;

   --
   --  Move the node SRC to DST.
   --  0 on success and -1 on failure.
   --
   function Aug_Mv
     (Aug : Augeas_Type; src : chars_ptr; dst : chars_ptr)
      return Interfaces.C.int;
   pragma Import (C, Aug_Mv, "aug_mv");

   function Move (Aug : Augeas_Type; Src : String; Dst : String) return Integer
   is
      MySrc  : chars_ptr := New_String (Src);
      MyDst  : chars_ptr := New_String (Dst);
      Result : Interfaces.C.int;
   begin
      if Aug = Null_Augeas then
         Free (MySrc);
         Free (MyDst);
         return -1;
      end if;

      Result := Aug_Mv (Aug, MySrc, MyDst);
      Free (MySrc);
      Free (MyDst);
      return Integer (Result);
   end Move;

   --
   --  Remove path and all its children.
   --  Returns the number of entries removed.
   --
   function Aug_Rm
     (Aug : Augeas_Type; path : chars_ptr) return Interfaces.C.int;
   pragma Import (C, Aug_Rm, "aug_rm");

   function Remove (Aug : Augeas_Type; Path : String) return Integer is
      MyPath : chars_ptr := New_String (Path);
      Result : Interfaces.C.int;
   begin
      if Aug = Null_Augeas then
         Free (MyPath);
         return -1;
      end if;

      Result := Aug_Rm (Aug, MyPath);
      Free (MyPath);
      return Integer (Result);
   end Remove;

   --
   --  Write all pending changes to disk.
   --  -1 if an error is encountered, 0 on success.
   --
   function Aug_Save (Aug : Augeas_Type) return Interfaces.C.int;
   pragma Import (C, Aug_Save, "aug_save");

   function Save (Aug : Augeas_Type) return Integer is
      Result : Interfaces.C.int;
   begin
      if Aug = Null_Augeas then
         return -1;
      end if;

      Result := Aug_Save (Aug);
      return Integer (Result);
   end Save;

   --
   --  Set the value associated with PATH to VALUE.
   --  Neec check: The string *VALUE must not be freed by the caller,
   --  and is valid as long as its node remains unchanged.
   --
   function Aug_Set
     (Aug : Augeas_Type; path : chars_ptr; value : chars_ptr)
      return Interfaces.C.int;
   pragma Import (C, Aug_Set, "aug_set");

   function Set
     (Aug : Augeas_Type; Path : String; Value : String) return Integer
   is
      MyPath  : chars_ptr := New_String (Path);
      MyValue : chars_ptr := New_String (Value);
      Result  : Interfaces.C.int;
   begin
      if Aug = Null_Augeas then
         Free (MyPath);
         Free (MyValue);
         return -1;
      end if;

      Result := Aug_Set (Aug, MyPath, MyValue);
      Free (MyPath);
      Free (MyValue);
      return Integer (Result);
   end Set;

   --
   --  Set the value associated with PATH to VALUE.
   --  Neec check: The string *VALUE must not be freed by the caller,
   --  and is valid as long as its node remains unchanged.
   --
   function Aug_Setm
     (Aug : Augeas_Type; base : chars_ptr; sub : chars_ptr; value : chars_ptr)
      return Interfaces.C.int;
   pragma Import (C, Aug_Setm, "aug_setm");

   function Setm
     (Aug : Augeas_Type; Base : String; Sub : String; Value : String)
      return Integer
   is
      MyBase  : chars_ptr := New_String (Base);
      MySub   : chars_ptr := New_String (Sub);
      MyValue : chars_ptr := New_String (Value);
      Result  : Interfaces.C.int;
   begin
      if Aug = Null_Augeas then
         Free (MyBase);
         Free (MySub);
         Free (MyValue);
         return -1;
      end if;

      Result := Aug_Setm (Aug, MyBase, MySub, MyValue);
      Free (MyBase);
      Free (MySub);
      Free (MyValue);
      return Integer (Result);
   end Setm;

begin
   begin
      null;
   end;

end AdaAugeas;
