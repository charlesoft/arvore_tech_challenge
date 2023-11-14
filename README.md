# ArvoreTechChallenge

Para iniciar a aplicação:

  * Instale dependencias com `mix deps.get`
  * Crie o banco e rode as migraçoes como comando `mix ecto.setup`
  * Para iniciar a aplicação use `mix phx.server` ou `iex -S mix phx.server` para user o terminal IEx.

## Uso

Esse serviço utitliza uma API GraphQL para acessar e administrar os dados de Redes, Escolas e Turmas. Abaixo estão exemplos de como utitlizar os endpoints implementados para a manipulação desses dados.

#### Criar conta de usuário

Para usar esta API, é preciso criar primeiro uma conta de usuário:

Exemplo:
```
POST http://localhost:4000/users
```
Mutation:
```graphql
mutation CreateUser($email: String!, $password: String!) {
 createUser(email: $email, password: $password) {
  id
  email
 }
}
```
query variables:
```json
{
  "email": "example@email",
  "password": "123456"
}
```
Response:
```json
{
  "data": {
  "createUser": {
   "email": "matheus09@gmail.com",
   "id": "4"
  }
 }
}
```

#### Sign In

Criado um usuário, agora é preciso fazer um sign in no qual irár retornar um `accessToken`. Esse token será a chave de autenticação que deve user usada para acessar os dados da API das entidades escolares.

Exemplo:
```
POST http://localhost:4000/users
```
Mutation:
```graphql
mutation SignIn($email: String!, $password: String!) {
 signIn(email: $email, password: $password) {
  accessToken
  }
 }
```
query variables:
```json
{
  "email": "example@email",
  "password": "123456"
}
```
Response:
```json
{
 "data": {
   "signIn": {
   "accessToken": "token_example"
   }
  }
}
```

### Acessando a API de entitidades escolares

Agora com `accessToken` como chave de autenticação, é possível acessar os dados da API das entidades. Segue abaixo os exemplos.

Obs: O accessToken sera usado no formato `Bearer [accessToken]` nos headers ao realizar as requisições.

#### Acessar lista de entities

Exemplo:
```
POST http://localhost:4000/api/v2/partners/entities
```
Query:
```graphql
query{
  entities{
    id
    name
    parent_id: parentId
    entity_type: entity_type
    inep
    subtree_ids: entities
  }
}
```
Response:
```json
{
  "data": {
    "entities": [
    {
     "entity_type": "network",
     "id": "11",
     "inep": null,
     "name": "Network Example",
     "parent_id": null,
     "subtree_ids": [
      "12"
    ]
  },
  {
   "entity_type": "school",
   "id": "10",
   "inep": "123213",
   "name": "School Example 1",
   "parent_id": null,
   "subtree_ids": [
     "13"
    ]
   }
  ]
 }
}
```

#### Buscar uma entidade

Exemplo:
```
POST http://localhost:4000/api/v2/partners/entities
```
Query:
```graphql
query Entitty($id: ID!){
  entities(id: $id){
    id
    name
    parent_id: parentId
    entity_type: entity_type
    inep
    subtree_ids: entities
  }
}
```
query variables:
```json
{"id": 11}
```
Response:
```json
{
"data": {
 "entity":
  {
   "entity_type": "network",
   "id": "11",
   "inep": null,
   "name": "Network Example",
   "parent_id": null,
   "subtree_ids": [
     "12"
    ]
   }
  }
}
```

#### Criar Entidade

Exemplo:
```
POST http://localhost:4000/api/v2/partners/entities
```
Mutation:
```graphql
mutation CreateEntity($name: String!, $entity_type: String!, $inep: String, $parent_id: String){
  createEntity(name: $name, entity_type: $entity_type, inep: $inep, parent_id: $parent_id){
    id
    name
    parent_id: parentId
    entity_type: entityType
    inep
    subtree_ids: entities
  }
}
```
query variables:
```json
{
  "name": "New School",
  "parent_id": 1,
  "entity_type": "school",
  "inep": "233434",
}
```
Response:
```json
{
  "data": {
    "createEntity":
     {
       "entity_type": "school",
       "id": "14",
       "inep": "233434",
       "name": "New School",
       "parent_id": "1",
       "subtree_ids": []
    }
  }
}
```

#### Atualizar entidade

Exemplo:
```
POST http://localhost:4000/api/v2/partners/entities
```
Mutation:
```graphql
mutation UpdateEntity($id: ID!, $name: String!){
  updateEntity(id: $id, name: $name){
    id
    name
  }
}
```
query variables:
```json
{
  "name": "Old School",
  "id": 14
}
````
Response:
```json
{
  "data": {
    "updateEntity":
    {
      "id": "14",
      "name": "Old School"
    }
  }
}
```

#### Deletar uma entidade

Exemplo:
```
POST http://localhost:4000/api/v2/partners/entities
```
Mutation:
```graphql
 mutation DeleteEntity($id: ID!){
      deleteEntity(id: $id){
        message
      }
    }
```
query variables:
```json
{"id": 41}
Response:
```json
{
  "message": "Entity and its children deleted with success."
}
```

## Detalhers/Decisões de implementação

- Criei o model Entity para representar a entidade `Entity`, no qual seria a única entidade a representar os diferentes tipos dela mesma que podemos criar, como foi determinado na descrição do exercício.
  - Uma entity pode pertencer (`belongs_to`) our ter muitas (`has_many`) entidades relacionadas.
  - Adicionei o `entity_type` do tipo `Ecto.Enum` para o Entity schema e uma lista dos únicos valores que podem ser atribuidos a esse campo. Com isso garantimos que apenas `school, class ou network` seja os unicos dados válidos para esse campo.
  - O `parent_id` é apenas obrigatório para uma Entity do tipo `class`, mas as outras entidades podem ou não estar relacionadas a outra entidade. Dado isso, adicionei uma `constraint` na table de entities para garantir que o parent_id é obrigatório apenas para entity `class` e no model Entity adicionei validações para garantir que o parent_id da entidade seja um parent_id válido, ou seja, uma entity do tipo `class` deve estar relacionada/pertencer a uma entity do tipo `school`. Já uma entity do tipo `school` não pode estar relacionada/pertencer ao uma entity do tipo `class`.
  - Adicionei uma validação no model e uma constraint na table de entities para garantir que o `inep`, caso tenha algum, seja apenas preenchido para entity do tipo `school`.
- Utilizei o GraphQL para a criação da API. Com isso todas as requisições são do tipo POST, e por ser graphql o usuário/parceiro que utilizia o serviço terá essa flexibilidade de consultar apenas os dados de que precisa da API. Por exemplo, ao fazer uma consulta por uma entidade, em vez de fazer uma query para retornar todos os dados, é possível apenas retornar o `name`.
- Para o mecanismo de autenticação decidi criar um endpoint para o registro de usuarios e com isso o mesmo receberá um `accessToken` chave de autenticação para usar nas requests por entidades. Esse é um recurso bem simples e um dos mais utilizados, e garante uma boa segurança para quem usa o serviço acessar seus dados.
  - O Absinthe do elixir possui uma estrutura bem simples e robusta de configurar a autenticação por meios de middlewares nas queries/mutations.


## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
