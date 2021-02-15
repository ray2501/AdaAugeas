with Ahven;                             use Ahven;
with AdaAugeas;                         use AdaAugeas;
with Ada.Containers.Indefinite_Vectors; use Ada.Containers;

package body My_Tests is
    procedure Initialize (T : in out Test) is
    begin
        Set_Name (T, "My tests");

        Framework.Add_Test_Routine (T, INIT_TEST'Access, "INIT_TEST");

        Framework.Add_Test_Routine (T, CLOSE_TEST'Access, "CLOSE_TEST");

        Framework.Add_Test_Routine (T, SET_TEST'Access, "SET_TEST");

        Framework.Add_Test_Routine (T, GET_TEST'Access, "GET_TEST");

        Framework.Add_Test_Routine (T, GET_SET'Access, "GET_SET");

        Framework.Add_Test_Routine (T, SETM_TEST'Access, "SETM_TEST");

        Framework.Add_Test_Routine (T, RM_TEST'Access, "RM_TEST");

        Framework.Add_Test_Routine (T, MV_TEST'Access, "MV_TEST");

        Framework.Add_Test_Routine (T, CP_TEST'Access, "CP_TEST");

        Framework.Add_Test_Routine (T, MATCH_TEST'Access, "MATCH_TEST");

        Framework.Add_Test_Routine (T, SAVE_TEST'Access, "SAVE_TEST");
    end Initialize;

    procedure INIT_TEST is
        Aug : Augeas_Type;
        Res : Integer;
    begin
        Res := Init (Aug, "/", "", AUG_NO_LOAD);
        Assert (Condition => Res = 0, Message => "Init and Close Test");

        Close (Aug);
    end INIT_TEST;

    procedure CLOSE_TEST is
        Aug : Augeas_Type;
        Res : Integer;
    begin
        Res := Init (Aug, "/", "", AUG_NONE);
        Assert (Condition => Res = 0, Message => "Init and Close Test");

        Close (Aug);
        Close (Aug);
    end CLOSE_TEST;

    procedure SET_TEST is
        Aug : Augeas_Type := Null_Augeas;
        Res : Integer;
    begin
        Res := Set (Aug, "/test/value", "0");

        Assert (Condition => Res = -1, Message => "Set Test");
    end SET_TEST;

    procedure GET_TEST is
        Aug : Augeas_Type := Null_Augeas;
    begin
        declare
            Ret : String := Get (Aug, "/test/value");
        begin
            Assert (Condition => Ret = "", Message => "Get Test");
        end;
    end GET_TEST;

    procedure GET_SET is
        Aug : Augeas_Type;
        Res : Integer;
    begin
        Res := Init (Aug, "/", "", AUG_NO_LOAD);
        Assert (Condition => Res = 0, Message => "Init and Close Test");

        Res := Set (Aug, "/test/value", "0");

        declare
            Ret : String := Get (Aug, "/test/value");
        begin
            Assert (Condition => Ret = "0", Message => "Get and Set Test");
        end;

        Close (Aug);
    end GET_SET;

    procedure SETM_TEST is
        Aug : Augeas_Type;
        Res : Integer;
    begin
        Res := Init (Aug, "/", "", AUG_NO_LOAD);
        Assert (Condition => Res = 0, Message => "Init and Close Test");

        Res := Set (Aug, "/test/value", "0");
        Res := Setm (Aug, "/test/value", ".", "1");

        declare
            Ret : String := Get (Aug, "/test/value");
        begin
            Assert (Condition => Ret = "1", Message => "Setm Test");
        end;

        Close (Aug);
    end SETM_TEST;

    procedure RM_TEST is
        Aug : Augeas_Type;
        Res : Integer;
    begin
        Res := Init (Aug, "/", "", AUG_NO_LOAD);
        Assert (Condition => Res = 0, Message => "Init and Close Test");

        Res := Set (Aug, "/test/value", "0");

        Res := Remove (Aug, "/test/value");
        Assert (Condition => Res = 1, Message => "Remove Test");

        Close (Aug);
    end RM_TEST;

    procedure MV_TEST is
        Aug : Augeas_Type;
        Res : Integer;
    begin
        Res := Init (Aug, "/", "", AUG_NO_LOAD);
        Assert (Condition => Res = 0, Message => "Init and Close Test");

        Res := Set (Aug, "/test/value/0", "1");
        Res := Move (Aug, "/test/value/0", "/test/value/1");

        Assert (Condition => Res = 0, Message => "Move Test");

        declare
            Ret : String := Get (Aug, "/test/value/1");
        begin
            Assert (Condition => Ret = "1", Message => "Get Test");
        end;

        Close (Aug);
    end MV_TEST;

    procedure CP_TEST is
        Aug : Augeas_Type;
        Res : Integer;
    begin
        Res := Init (Aug, "/", "", AUG_NO_LOAD);
        Assert (Condition => Res = 0, Message => "Init and Close Test");

        Res := Set (Aug, "/test/value/0", "1");
        Res := Copy (Aug, "/test/value/0", "/test/value/1");

        Assert (Condition => Res = 0, Message => "Copy Test");

        declare
            Ret : String := Get (Aug, "/test/value/1");
        begin
            Assert (Condition => Ret = "1", Message => "Get Test");
        end;

        Close (Aug);
    end CP_TEST;

    procedure MATCH_TEST is
        Aug : Augeas_Type;
        Res : Integer;
        Vec : String_Vectors.Vector;
    begin
        Res := Init (Aug, "/", "", AUG_NONE);
        Assert (Condition => Res = 0, Message => "Init and Close Test");

        Vec := Match (Aug, "/files/etc/hosts/*");
        Assert (Condition => Vec.Length > 0, Message => "Match Test");

        Close (Aug);
    end MATCH_TEST;

    procedure SAVE_TEST is
        Aug : Augeas_Type;
        Res : Integer;
    begin
        Res := Init (Aug, "/", "", AUG_SAVE_BACKUP);
        Assert (Condition => Res = 0, Message => "Init and Close Test");

        Res := Save (Aug);
        Assert (Condition => Res = 0, Message => "Save Test");

        Close (Aug);
    end SAVE_TEST;

end My_Tests;
