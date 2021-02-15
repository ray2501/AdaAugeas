with Ahven.Framework;
package My_Tests is
   type Test is new Ahven.Framework.Test_Case with null record;

   procedure Initialize (T : in out Test);

   procedure INIT_TEST;
   procedure CLOSE_TEST;
   procedure SET_TEST;
   procedure GET_TEST;
   procedure GET_SET;
   procedure SETM_TEST;
   procedure RM_TEST;
   procedure MV_TEST;
   procedure CP_TEST;
   procedure MATCH_TEST;
   procedure SAVE_TEST;
end My_Tests;
