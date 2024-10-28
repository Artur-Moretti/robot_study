*** Settings ***
Library   RequestsLibrary
Library   Collections
Library    OperatingSystem

Force Tags   api_produtos    post_produtos


*** Variables ***
${base_url}    https://serverest.dev

*** Keywords ***

POST api/login
    [Arguments]    ${email}    ${password}

    &{headers}    Create Dictionary
    ...    accept=application/json
    ...    Content-Type=application/json
    
    &{body}    Create Dictionary
    ...    email=${email}
    ...    password=${password}
    
    ${response}    POST
    ...    url=${base_url}/login
    ...    headers=${headers}
    ...    json=${body}
    ...    expected_status=any

    Set Test Variable    ${response}

POST api/Produtos
    [Arguments]    ${token}    ${nome}    ${preco}    ${descricao}    ${quantidade}

    &{headers}    Create Dictionary
    ...    accept=application/json
    ...    Content-Type=application/json
    ...    Authorization=${token}
    
    &{body}    Create Dictionary
    ...    nome=${nome}
    ...    preco=${preco}
    ...    descricao=${descricao}
    ...    quantidade=${quantidade}
    
    ${response}=    POST
    ...    url=${base_url}/produtos
    ...    headers=${headers}
    ...    json=${body}
    ...    expected_status=any

    Set Test Variable    ${response}


*** Test Cases ***

TC0005: Status code should be 201 with valid data
    [Tags]    tc0005
    POST api/login    artur.duncan@iteris.com.br    teste
     ${post_response}    Set Variable    ${response.json()}
     POST api/Produtos    ${post_response['authorization']}    Prod01    99    Prod descrip    17
     Status Should Be    201


TC0006: Status code should be 401 with invalid token
    [Tags]    tc0006
    POST api/login    artur.duncan@iteris.com.br    teste
     ${post_response}    Set Variable    ${response.json()}
     POST api/Produtos    ${post_response['authorization']}123    Prod01    99    Prod descrip    17
     Status Should Be    401

TC0007: Status code should be 401 with expired token
    [Tags]    tc0006
    POST api/login    artur.duncan@iteris.com.br    teste
     ${post_response}    Set Variable    ${response.json()}
     POST api/Produtos    ${EMPTY}    Prod01    99    Prod descrip    17
     Status Should Be    401

TC0008: Status code should be 400 with field "nome": interger
    [Tags]    tc0008
    POST api/login    artur.duncan@iteris.com.br    teste
     ${post_response}    Set Variable    ${response.json()}
     POST api/Produtos    ${post_response['authorization']}    ${1234}    99    Prod descrip    17
     Status Should Be    400

TC0009: Status code should be 400 with field "nome": boolean
    [Tags]    tc0009
    POST api/login    artur.duncan@iteris.com.br    teste
     ${post_response}    Set Variable    ${response.json()}
     POST api/Produtos    ${post_response['authorization']}    ${true}    99    Prod descrip    17
     Status Should Be    400

TC00010: Status code should be 400 with field "nome": null
    [Tags]    tc00010
    POST api/login    artur.duncan@iteris.com.br    teste
     ${post_response}    Set Variable    ${response.json()}
     POST api/Produtos    ${post_response['authorization']}    ${None}    99    Prod descrip    17
     Status Should Be    400

TC00011: Status code should be 400 with field "nome": empity
    [Tags]    tc00011
    POST api/login    artur.duncan@iteris.com.br    teste
     ${post_response}    Set Variable    ${response.json()}
     POST api/Produtos    ${post_response['authorization']}    ${EMPTY}    99    Prod descrip    17
     Status Should Be    400
