project AdaAugeas is
   for Library_Name     use "adaaugeas";
   for Library_Kind     use $Library_Type;
   for Source_Dirs      use ($Includedir & "/adaaugeas");
   for Library_Dir      use $Libdir;
   for Library_ALI_Dir  use $Alidir & "/adaaugeas";
   for Externally_Built use "true";
   package Linker is
      for Linker_Options use ("-lgnat", "-lgnarl");
   end Linker;
end AdaAugeas;

