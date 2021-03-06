project AdaAugeas is

   Version := external ("VERSION", $Version);

   type Library_Kind is ("dynamic", "static");
   Library_Type : Library_Kind := external("LIBRARY_TYPE", $Library_Type);
   Library_Dir := external ("LIBDIR", $Libdir);

   for Source_Dirs use ("src");
   for Object_Dir use "obj";
   for Library_Name use "adaaugeas";
   for Library_Dir use Library_Dir;
   for Library_ALI_Dir  use Library_Dir;
   for Library_Kind use Library_Type;

   Ldlibs := ("-laugeas");

   Adaflags := External_As_List ("ADAFLAGS", " ");
   Ldflags := External_As_List ("LDFLAGS", " ");

   case Library_Type
   is
      when "dynamic" =>
         for Leading_Library_Options use Ldflags;
         for Library_Options use Ldlibs;
         for Library_Version use "libadaaugeas.so." & Version;
      when others => null;
   end case;

   package Compiler is
      for Default_Switches ("Ada") use
        ("-gnatygAdISuxo",
         "-gnatVa",
         "-gnatf",
         "-fstack-check",
         "-gnato",
         "-g",
         "-gnatwal")
        & Adaflags;
   end Compiler;

   package Binder is
      for Default_Switches ("Ada") use ("-E");
   end Binder;

end AdaAugeas;
