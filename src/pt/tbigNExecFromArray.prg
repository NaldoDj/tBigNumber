#include "tBigNumber.ch"

/*
    class:tBigNExecFromArray
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:30/07/2015
    Descricao:Instancia um novo objeto do tipo tBigNExecFromArray
    Sintaxe:tBigNExecFromArray():New() -> self
*/
Class tBigNExecFromArray
    
    method function New() CONSTRUCTOR /*(/!\)*/

    method function ExecFromArray(aExec)
    
EndClass

user function tBigNExFArray()
return(tBigNExecFromArray():New())

method function new() class tBigNExecFromArray
return(self)

method function ExecFromArray(aExec,bError) class tBigNExecFromArray
return(ExecFromArray(aExec,bError))
static function ExecFromArray(aExec,bError)
    local nD
    local nJ
    local aPrm
    local cTyp
    local xRet
    local xFun
    local xPrm
    PARAMTYPE 1 VAR aExec AS ARRAY
    begin sequence
        if Empty(aExec)
            xRet:=aExec
            break
        endif
        PARAMTYPE 2 VAR bError AS BLOCK OPTIONAL DEFAULT ErrorBlock()
        tryexception using bError
            if (Len(aExec)==1)
                xFun:=aExec[1]
                cTyp:=valType(xFun)
                do case
                case (cTyp=="A")
                    xRet:=Array(0)
                    aAdd(xRet,ExecFromArray(xFun,bError))
                case (cTyp=="B")
                    xRet:=Eval(xFun)
                case (cTyp=="C")
                    xRet:=&(xFun)
                otherwise
                    xRet:=xFun
                end case
            else
                xFun:=aExec[1]
                cTyp:=valType(xFun)
                do case
                case (cTyp=="A")
                    xRet:=Array(0)
                    nJ:=Len(aExec)
                    for nD:=1 to nJ
                        aAdd(xRet,ExecFromArray(aExec[nD],bError))
                    next nD
                case (cTyp=="B")
                    cTyp:=valType(aExec[2])
                    if (cTyp=="A")
                        xRet:=Array(0)
                        nJ:=Len(aExec[2])
                        for nD:=2 to nJ
                            aPrm:=aExec[2][nD]
                            aAdd(xRet,Eval(xFun,aPrm))
                        next nD
                    else
                        aPrm:=Array(0) 
                        nJ:=Len(aExec)
                        for nD:=2 to nJ
                            aAdd(aPrm,aExec[nD])
                        next nD
                        xFun:=Eval(xFun,aPrm)
                    endif
                case (cTyp=="C")
                    cTyp:=valType(aExec[2])
                    if (cTyp=="A")
                        xRet:=Array(0)
                        nJ:=Len(aExec[2])
                        for nD:=1 to nJ
                            aPrm:=aExec[2][nD]
                            aAdd(xRet,&(ToExecFromArr(xFun,aPrm)))
                        Next nD                        
                    else
                        aPrm:=Array(0) 
                        nJ:=Len(aExec)
                        for nD:=2 to nJ
                            aAdd(aPrm,aExec[nD])
                        next nD
                        xFun:=&(ToExecFromArr(xFun,aPrm))
                     endif   
                otherwise
                    xRet:=aExec
                end case
            endif
        end exception
    end sequence
return(xRet)

static function ToExecFromArr(cFun,aParameters)
         
    local nAt       
    local nParam
    local nParameters

    DEFAULT cFun:=""

    if .not.(Empty(cFun))
        DEFAULT aParameters:=Array(0)
        _SetOwnerPrvt("__aParameters__",aParameters)
        cFun:=StrTran(cFun," ","")
        nParameters:=Len(__aParameters__)
        if ((nAt:=At("(",cFun))>0)
            cFun:=SubStr(cFun,1,nAt)
        else
            cFun+="("
        endif    
        if (nParameters>0)
            for nParam:=1 to nParameters
                cFun+="@__aParameters__["+NToS(nParam)+"],"
            next nParam
            cFun:=SubStr(cFun,1,Len(cFun)-1)+")"
        else
            cFun+=")"
        endif
    endif

Return(cFun)

#include "paramtypex.ch"
#include "tryexception.ch"
