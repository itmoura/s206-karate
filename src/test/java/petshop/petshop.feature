@PetShop
Feature: Executar testes funcionais nas APIs de PetShop (Swagger).

    Background: Executa antes de cada teste
        * def url_base = "https://petstore.swagger.io/v2/"
        * def status_sold = "sold"
        * def status_pending = "pending"
        * def status_available = "available"
        * def createPet_json = read('petjson.json')
        * def createUser_json = read('user.json')

    Scenario: Verificar o retorno com sucesso da API /pet/findByStatus/ com status "pending" (request).
        Given url url_base
        And path 'pet/findByStatus?status='+status_pending
        When method get
        Then status 200

    Scenario: Verificar o retorno correto da API /pet/123/ com dados inválidos de requisição (request).
        Given url url_base
        And path 'pet/123'
        When method get
        Then status 404

    Scenario: Criar novo cadastro de um pet e verifica o item criado.
        Given url url_base
        And path '/pet'
        And request createPet_json
        When method post
        Then status 200
        And match $.name == 'Jake'
        And def petId = response.id
        And print petId
        And url url_base
        And path '/pet/'+petId
        When method get
        Then status 200
        And match response.name == 'Jake'

    Scenario: Deletar pet com erro
        Given url url_base
        And path 'pet/123'
        When method DELETE
        Then status 404

    Scenario: Verificar o retorno com sucesso da API /store/inventory/ (request).
        Given url url_base
        And path '/store/inventory/'
        When method get
        Then status 200

    Scenario: Criar novo cadastro de usuário e verifica o mesmo criado.
        Given url url_base
        And path 'user'
        And request createUser_json
        When method post
        Then status 200
        And url url_base
        And path 'user/itmoura123456'
        When method get
        Then status 200
        And print response

    Scenario: Efetuar login com o cadastro criado
        Given url url_base
        And path 'user/login?username=itmoura123456password=batatinha123'
        When method get
        Then status 200
        And print response.message