AdaAugeas
=====

[Augeas](https://augeas.net/) is a configuration editing
tool. It parses configuration files in their native formats
and transforms them into a tree.

This package is Ada bindings for Augeas library.


UNIX BUILD
=====

I only test on openSUSE LEAP 15.2.

Users need install Augeas library development files.

    sudo zypper in augeas-devel

Users need use `make` to build:

    make

And install:

    make install

If users want to check test with Ahven:

    make test

Default PREFIX is `/usr/local`, and LIBDIR is `lib`.
If users want to change, below is the example:

    make PREFIX=/usr LIBDIR=lib64

and install:

    make PREFIX=/usr LIBDIR=lib64 install


Example
=====

The node /augeas/version contains the version number of the Augeas library.
Below is a simple example to query Augeas library version number:

    with Ada.Text_IO;
    with Ada.Integer_Text_IO;
    with AdaAugeas;
    use Ada.Text_IO;
    use Ada.Integer_Text_IO;
    use AdaAugeas;

    procedure Version is
        Aug : Augeas_Type;
        Res : Integer;
    begin
        Res := Init (Aug, "/", "", AUG_NONE);
        if Res < 0 then
            Put_Line ("Init failed");
        else    
            declare
                Result : String := Get(Aug, "/augeas/version");
            begin    
                Put_Line("Augeas version: " & Result);
            end;

            Close (Aug);
        end if;    
    end Version;

Then write a version.gpr file:

    with "adaaugeas";

    project Version is
        for Languages use ("Ada");
        for Exec_Dir use ".";
        for Source_Files use ("version.adb");
        for Main use ("version.adb");
        package Builder is
            for Executable ("version") use "version";
        end Builder;
        package Compiler is
        for Default_Switches ("Ada")
            use ("-O2");
        end Compiler;
    end Version;

Then build this project:

    gnatmake -Pversion

