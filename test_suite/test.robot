*** Settings ***
Library  BuiltIn
Library  RequestsLibrary

*** Variables ***
${nome}    Renato
${idade}    ${34}
${active}    ${true}
@{lista}    1  2  blablabla
&{dicionario}    nome=Zé    idade=${50}    active=${false}

*** Keywords ***
Buscar nome
    [Arguments]    ${nome}=${EMPTY}
    FOR    ${index}    IN    @{lista}

        IF    '$index' == '$nome'
            Log    ${index}
        ELSE
            Log    Nome diferente
        END
    
    END

Buscar o nome "${nome}" no dicionario
    FOR    ${key}    ${value}    IN    &{dicionario}
        IF    '$key' == 'nome' and '$value' == '$nome'
            Log ${key}: ${value}
            
        END
        
    END

Inserir nome "${nome}"
    ${novo_nome}    Set Variable    ${nome}
    Set Test Variable    ${novo_nome}


Conferir o novo nome "${nome_x}"
    Should Be Equal    ${nome_x}    ${novo_nome}

*** Test Cases ***
TC0001: Meu primeiro teste
    [Tags]    tc0001
    Log    Hello World
    Log    ${nome}
    Log    ${idade}
    Log    ${active}
    Log    ${lista[2]}
    Log    ${dicionario}[idade]

TC0002: Meu primeiro teste
    [Tags]    tc0002
    ##Buscar nome
    Buscar o nome "Zé" no dicionario
    
TC0003: Meu primeiro teste
    [Tags]    tc0003
    Inserir nome "pedro"
    Conferir o novo nome "pedro"