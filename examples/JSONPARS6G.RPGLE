
        //------------------------------------------------------------- *

        Ctl-Opt BndDir('NOXDB') dftactgrp(*NO) ACTGRP('QILE' );

        //This sample shows the use of the buildin JSON parser in IceBreak

        //------------------------------------------------------------- *

        /include 'headers/JSONPARSER.rpgle'
        Dcl-S p1           Pointer;
        Dcl-S p2           Pointer;
        Dcl-S pJson        Pointer;
        Dcl-S pNode        Pointer;
        Dcl-S pO           Pointer;
        Dcl-S pR           Pointer;
        Dcl-S pRcv         Pointer;
        Dcl-S pArr         Pointer;
        Dcl-S msg          Varchar(50);
        Dcl-S tag          Varchar(50);
        Dcl-S value        Varchar(50);
        Dcl-S n            Packed(15:2);

        //------------------------------------------------------------- *

        *inlr = *on;

        p1  = Json_ParseString ('  -
            {  a: 1,               -
               b: 2                -
            }                      -
        ');
        p2  = Json_ParseString ('  -
            {  c: 3,               -
               d: 4                -
            }                      -
        ');

        Json_mergeObjects (p1 : p2) ;
        Json_WriteStmf  (p1   : '/samples/json/json-merge1.json' : 1208 : *ON );
        Json_Close(p1   );
        Json_Close(p2   );


        // Yet more advanced
        pJson = Json_ParseString (
           '{  u:"This is a unicode \u00b5 string"  ,   '+
           '   "s":"abc"                            ,   '+
           '   a:[1,2,3],                   ' +
           '   o:{           ' +
           '     n:123   , ' +
           '     a:[10 , 20 , 30 ],                ' +
           '     b:[10 , 20 , 30 ],                ' +
           '     c:[[1,2],[3,4]],                ' +
           '     m:"yyyy", ' +
           '     o2:{           ' +
           '      x:345   , ' +
           '      y:345     ' +
           '     }         '+
           '   }         '+
           '}'
             : '');
        if Json_Error(pJson) ;
           msg = Json_Message(pJson);
           Json_dump(pJson);
           Json_Close(pJson);
           return;
        endif;
        pRcv  = Json_ParseString (
           '{  r: {                                     '+
           '     o: {                                     '+
           '       n:"Do not overwrite me"    ' +
           '     }' +
           '   }' +
           '}'
             : '');
        if Json_Error(pRcv ) ;
           msg = Json_Message(pRcv );
           Json_dump(pRcv );
           Json_Close(pRcv );
           return;
        endif;

        pO    = Json_locate(pJson: '/o');
        pR    = Json_locate(pRcv : '/r');
        Json_merge (pR : pO : Json_DONTREPLACE);
        Json_dump(pRcv );
        Json_WriteStmf  (pR   : '/samples/json/jsonout.json' : 1208 : *OFF);
        Json_Close(pJson);
        Json_Close(pRcv );
