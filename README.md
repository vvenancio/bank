# Aplicação para controle de contas

Requisitos:
- Ruby 2.4.2
- Rails 5.2.0
- MariaDB ou MySQL

---

Requisitos funcionais do projeto:
- Toda conta deve ter um owner, que pode ser uma pessoa jurídica ou uma pessoa física
- Deve haver CRUD para pessoa física e jurídica
- Só há a possibilidade de transferências entre contas associadas a mesma matriz
- Há a possibilidade de estorno de transações, menos para depósitos
- A conta matriz não pode receber transferência alguma, somente depósitos
- A conta matriz é a conta principal, podendo ter (n) contas filhas, que por sua vez também podem ter contas filhas,
  formando assim uma estrutura em árvore
- Toda conta pode estar ativa, bloqueada ou cancelada

---

## Instalação do app

- Abra uma nova seção do terminal e clone o projeto: `git clone git@github.com:vvenancio/bank.git`
- Vá para a pasta do projeto que acabou de ser clonada: `cd bank`
- Instale toda as dependências do projeto com `bundle install`; se não houver o `bundler` instalado, digite: `gem install        bundler`
- Monte a estrutura do banco com `rake db:create db:migrate`
- Suba o servidor do app com `rails s`
- Se preferir, poderás rodar os testes com `rspec`

---

### Rotas da API REST para acessar as funcionalidades do app

- Criar pessoa

```
url => POST api/v1/people
payload => {
  "person": {
    "name": "Mazaroppi", 
    "birthdate": "d/m/y",
    "cpf": "xxx.xxx.xxx-xx"
   }
 }
```

- Deletar pessoa:

```
url => DELETE api/v1/people/:id
```
- Atualizar pessoa:

```
url => PATCH api/v1/people/:id
payload => {
  "person": {
    "name": "Mazaroppi", 
    "birthdate": "d/m/y",
    "cpf": "xxx.xxx.xxx-xx"
   }
 }
```

- Visualizar pessoa:

```
url => api/v1/people/:id
```

- Criar empresa

```
url => POST api/v1/companies
payload => {
  "company": {
    "name": "Mazaroppi", 
    "trade": "name",
    "cnpj": "xx.xxx.xxx/xxxx-xx"
   }
 }
```

- Deletar empresa:

```
url => DELETE api/v1/companies/:id
```
- Atualizar empresa:

```
url => PATCH api/v1/companies/:id
payload => {
  "company": {
    "name": "Mazaroppi", 
    "trade": "name",
    "cnpj": "xx.xxx.xxx/xxxx-xx"
   }
 }
```

- Visualizar empresa:

```
url => api/v1/companies/:id
```

- Criar conta bancária

```
url => POST api/v1/bank_accounts
payload => {
  "bank_account": {
    "name": "Mazaroppi", 
    "parent_id": ,
    "owner": "xx.xxx.xxx/xxxx-xx" ou "xxx.xxx.xxx-xx"
   }
 }
```
_PS:_
  - Quando o parent_id for nulo, a conta será criada como matriz
  - Para o parâmetro owner, deve ser preenchido com CPF/CNPJ
  - Toda conta quando criada é ativada
  
- Deletar conta bancária:

```
url => DELETE api/v1/bank_accounts/:id
```

- Atualizar conta bancária:

```
url => PATCH api/v1/bank_accounts/:id
payload => {
  "bank_account": {
    "name": "Mazaroppi", 
    "parent_id": ,
    "owner": "xx.xxx.xxx/xxxx-xx" ou "xxx.xxx.xxx-xx",
    "status": "active", "blocked" ou "revoked"
   }
 }
```

- Visualizar conta bancária:

```
url => api/v1/bank_accounts/:id
```

- Depositar:

```
url => POST api/v1/bank_account/:id/deposit
payload => { "value": n }
```
- Transferir:

```
url => POST api/v1/bank_account/:from_account_id/transfer/:to_account_id
payload => { "value": n }
```

- Estornar:

```
url => POST api/v1/bank_account/reverse_debit?token=token
```

_PS_:
 - Toda transferência retorna um token, que deve ser utilizado na hora do estorno
 - Toda criação de recurso retorna o ID do recurso criado

