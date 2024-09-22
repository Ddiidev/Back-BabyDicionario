## Documentação da API

### Autenticação (`/auth`)

#### Refresh Token

```http
GET /auth/refresh-token
```

**Cabeçalhos:**

| Cabeçalho        | Tipo        | Descrição                                       |
| ---------------- | ----------- | ----------------------------------------------- |
| `Authorization`  | `Bearer`    | **Obrigatório**. Token de acesso atual.         |
| `refresh-token`  | `UUID-string` | **Obrigatório**. O refresh token atual.         |

**Resposta 200:**

```json
{
  "message": "",
  "status": "info",
  "content": {
    "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refresh_token": "8fca882d-dedd-11ee-adc8-bd24e3c67090"
  }
}
```

---

### Usuário (`/user`)

#### Criar Usuário e Enviar Código de Confirmação

```http
POST /user/create/send-code-confirmation
```

**Corpo da Requisição:**

```json
{
  "first_name": "Dictionary BB",
  "responsible": 0,
  "age": 20,
  "email": "dictBB@gmail.com",
  "password": "123456"
}
```

**Resposta 200:**

```json
{
  "message": "Email enviado com sucesso",
  "status": "info"
}
```

#### Recuperar Senha - Enviar Email

```http
POST /user/recover-password
```

**Corpo da Requisição:**

```json
{
  "email": "dictBB@gmail.com"
}
```

**Resposta 200:**

```json
{
  "message": "Email enviado com sucesso",
  "status": "info",
  "content": {
    "access_token": "8fca882d-dedd-11ee-adc8-bd24e3c67090"
  }
}
```

#### Login do Usuário

```http
POST /user/login
```

**Corpo da Requisição:**

```json
{
  "email": "dictBB@gmail.com",
  "password": "123456"
}
```

**Resposta 200:**

```json
{
  "message": "Login concluído",
  "status": "info",
  "content": {
    "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refresh_token": "8fca882d-dedd-11ee-adc8-bd24e3c67090"
  }
}
```

**Resposta 404:**

```json
{
  "message": "Email ou senha inválidos.",
  "status": "error"
}
```

**Resposta 401:**

```json
{
  "message": "Usuário bloqueado.",
  "status": "error"
}
```

#### Detalhes do Usuário

```http
GET /user/details
```

**Cabeçalhos:**

| Cabeçalho        | Tipo       | Descrição                                      |
| ---------------- | ---------- | ---------------------------------------------- |
| `Authorization`  | `Bearer`   | **Obrigatório**. Token de acesso do usuário.   |

**Resposta 200:**

```json
{
  "message": "",
  "status": "info",
  "content": {
    "first_name": "Dict BB",
    "last_name": "",
    "responsible": "father",
    "birth_date": "1994-06-25T00:00:00Z",
    "email": "dictBB@gmail.com"
  }
}
```

**Resposta 404:**

```json
{
  "message": "Token inválido.",
  "status": "error"
}
```

**Resposta 400:**

```json
{
  "message": "Erro ao obter detalhes do usuário.",
  "status": "error"
}
```

#### Bloquear Usuário

```http
GET /user/block/:access_token
```

**Parâmetros de URL:**

| Parâmetro      | Tipo          | Descrição                                                                                            |
| -------------- | ------------- | ------------------------------------------------------------------------------------------------------ |
| `access_token` | `JWT-string`  | **Obrigatório**. Token de acesso para bloqueio do usuário (enviado por e-mail). Não é o mesmo que o token de login. |

**Resposta 200:**

```html
<!-- HTML de sucesso ou erro conforme implementação -->
```

---

### Perfil (`/profile`)

#### Verificar Contenção do Perfil

```http
GET /profile/contain/:uuid
```

**Parâmetros de URL:**

| Parâmetro | Tipo         | Descrição                        |
| --------- | ------------ | -------------------------------- |
| `uuid`    | `string`     | **Obrigatório**. UUID do perfil. |

**Resposta 200:**

```json
{
  "message": "OK",
  "status": "info"
}
```

**Resposta 404:**

```json
{
  "message": "Perfil não encontrado.",
  "status": "error"
}
```

#### Obter Perfil Padrão do Usuário

```http
GET /profile/default-from-user/:user_uuid
```

**Parâmetros de URL:**

| Parâmetro   | Tipo         | Descrição                            |
| ----------- | ------------ | ------------------------------------ |
| `user_uuid` | `string`     | **Obrigatório**. UUID do usuário.    |

**Resposta 200:**

```json
{
  "message": "",
  "status": "info",
  "content": {
    "father": {},
    "mother": {},
    "babys": {
      "uuid": "4f5038b5...",
      "nickname": "Pitxhico",
      "first_name": "Dante Lima",
      "last_name": "dos Santos",
      "birth_date": "2021-01-01T00:00:00Z",
      "age": 2,
      "weight": 11.7,
      "sex": "male",
      "height": 0.8,
      "color": "White"
    }
  }
}
```

**Resposta 404:**

```json
{
  "message": "Perfil não encontrado.",
  "status": "error"
}
```

#### Obter Todos os Perfis da Família

```http
GET /profile/all-family
```

**Cabeçalhos:**

| Cabeçalho        | Tipo       | Descrição                                     |
| ---------------- | ---------- | --------------------------------------------- |
| `Authorization`  | `Bearer`   | **Obrigatório**. Token de acesso do usuário.  |

**Resposta 200:**

```json
{
  "message": "",
  "status": "info",
  "content": [
    {
      "uuid": "4f5038b5...",
      "nickname": "Pitxhico",
      "first_name": "Dante Lima",
      "last_name": "dos Santos",
      "birth_date": "2021-01-01T00:00:00Z",
      "age": 2,
      "weight": 11.7,
      "sex": "male",
      "height": 0.8,
      "color": "White",
      "father": {},
      "mother": {},
      "babys": []
    }
    // Outros perfis da família
  ]
}
```

**Resposta 404:**

```json
{
  "message": "Perfil não encontrado.",
  "status": "error"
}
```

#### Obter Detalhes para a Home

```http
GET /profile/details-home
```

**Cabeçalhos:**

| Cabeçalho        | Tipo       | Descrição                                     |
| ---------------- | ---------- | --------------------------------------------- |
| `Authorization`  | `Bearer`   | **Obrigatório**. Token de acesso do usuário.  |

**Resposta 200:**

```json
{
  "message": "",
  "status": "info",
  "content": {
    "father": {},
    "mother": {},
    "babys": {}
  }
}
```

**Resposta 404:**

```json
{
  "message": "Usuário não encontrado.",
  "status": "error"
}
```

#### Atualizar Perfil

```http
PUT /profile
```

**Cabeçalhos:**

| Cabeçalho        | Tipo       | Descrição                                     |
| ---------------- | ---------- | --------------------------------------------- |
| `Authorization`  | `Bearer`   | **Obrigatório**. Token de acesso do usuário.  |

**Corpo da Requisição:**

```json
{
  "uuid": "4f5038b5...",
  "nickname": "Pitxhico",
  "first_name": "Dante Lima",
  "last_name": "dos Santos",
  "birth_date": "2021-01-01T00:00:00Z",
  "age": 2,
  "weight": 11.7,
  "sex": "male",
  "height": 0.8,
  "color": "White"
}
```

**Resposta 200:**

```json
{
  "message": "Perfil atualizado com sucesso",
  "status": "info"
}
```

**Resposta 422:**

```json
{
  "message": "O JSON fornecido não está de acordo com o contrato esperado.",
  "status": "error"
}
```

**Resposta 404:**

```json
{
  "message": "Usuário não encontrado.",
  "status": "error"
}
```

#### Criar Perfil

```http
POST /profile
```

**Cabeçalhos:**

| Cabeçalho        | Tipo       | Descrição                                     |
| ---------------- | ---------- | --------------------------------------------- |
| `Authorization`  | `Bearer`   | **Obrigatório**. Token de acesso do usuário.  |

**Corpo da Requisição:**

```json
{
  "father": {},
  "mother": {},
  "babys": {
    "uuid": "4f5038b5...",
    "nickname": "Pitxhico",
    "first_name": "Dante Lima",
    "last_name": "dos Santos",
    "birth_date": "2021-01-01T00:00:00Z",
    "age": 2,
    "weight": 11.7,
    "sex": "male",
    "height": 0.8,
    "color": "White"
  }
}
```

**Resposta 200:**

```json
{
  "message": "Perfil inserido com sucesso",
  "status": "info",
  "content": {
    "father": {},
    "mother": {},
    "babys": {
      "uuid": "4f5038b5...",
      "nickname": "Pitxhico",
      "first_name": "Dante Lima",
      "last_name": "dos Santos",
      "birth_date": "2021-01-01T00:00:00Z",
      "age": 2,
      "weight": 11.7,
      "sex": "male",
      "height": 0.8,
      "color": "White"
    }
  }
}
```

**Resposta 422:**

```json
{
  "message": "O JSON fornecido não está de acordo com o contrato esperado.",
  "status": "error"
}
```

**Resposta 404:**

```json
{
  "message": "Usuário não encontrado.",
  "status": "error"
}
```

---

### Palavras (`/words`)

#### Adicionar Palavras

```http
POST /words
```

**Cabeçalhos:**

| Cabeçalho       | Tipo       | Descrição                                       |
| --------------- | ---------- | ----------------------------------------------- |
| `profile_uuid`  | `string`   | **Obrigatório**. UUID do perfil associado.      |

**Corpo da Requisição:**

```json
{
  "profile_uuid": "80ce1751-...",
  "words": [
    {
      "word": "cávitá",
      "translation": "chave",
      "pronunciation": "cávitá",
      "audio": "https://example.com/131252312.mp3"
    },
    {
      "word": "cata",
      "translation": "gato",
      "pronunciation": "cata",
      "audio": "https://example.com/1231234213.mp3"
    }
  ]
}
```

**Resposta 200:**

```json
{
  "message": "Palavras adicionadas com sucesso!",
  "status": "info"
}
```

**Resposta 400:**

```json
{
  "message": "O JSON fornecido não está de acordo com o contrato esperado.",
  "status": "error"
}
```

**Resposta 422:**

```json
{
  "message": "Erro ao adicionar palavras.",
  "status": "error",
  "content": { /* Detalhes dos erros */ }
}
```

#### Obter Todas as Palavras

```http
GET /words
```

**Cabeçalhos:**

| Cabeçalho       | Tipo       | Descrição                                       |
| --------------- | ---------- | ----------------------------------------------- |
| `profile_uuid`  | `string`   | **Opcional**. UUID do perfil para filtrar palavras. |

**Resposta 200:**

```json
[
  {
    "id": 1,
    "word": "cávitá",
    "translation": "chave",
    "pronunciation": "cávitá",
    "audio": "https://example.com/131252312.mp3"
  },
  {
    "id": 2,
    "word": "cata",
    "translation": "gato",
    "pronunciation": "cata",
    "audio": "https://example.com/1231234213.mp3"
  }
]
```

---

### Confirmação (`/confirmation`)

#### Confirmar Usuário por Email e Código

```http
POST /confirmation
```

**Corpo da Requisição:**

```json
{
  "email": "dictBB@gmail.com",
  "code": "836593"
}
```

**Resposta 200:**

```json
{
  "message": "",
  "status": "info",
  "content": {
    "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refresh_token": "8fca882d-dedd-11ee-adc8-bd24e3c67090"
  }
}
```

**Resposta 400:**

```json
{
  "message": "Código de confirmação inválido.",
  "status": "error"
}
```

#### Confirmar Recuperação de Senha

```http
POST /confirmation/recover-password
```

**Cabeçalhos:**

| Cabeçalho        | Tipo       | Descrição                                     |
| ---------------- | ---------- | --------------------------------------------- |
| `Authorization`  | `Bearer`   | **Obrigatório**. Token de acesso do usuário.  |

**Corpo da Requisição:**

```json
{
  "email": "dictBB@gmail.com",
  "new_password": "senha_muito_secreta_me_isquece",
  "code_confirmation": "123456",
  "current_date": "2024-03-06T16:27:11.469Z"
}
```

**Resposta 200:**

```json
{
  "message": "Senha redefinida com sucesso!",
  "status": "info"
}
```

**Resposta 422:**

```json
{
  "message": "Código de confirmação inválido.",
  "status": "error"
}
```