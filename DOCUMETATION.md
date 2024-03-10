## Documentação da API

#### Auth

```http
  GET /refresh-token
```

`Authorization: Bearer asdqwdgqwemklkjkqlwjeqwkelj`

| Header   | Tipo       | Descrição                           |
| :---------- | :--------- | :---------------------------------- |
| `refresh-token` | `UUID-string` | **Obrigatório**. O refresh token atual |


#### User

```http
  POST /user/create/send-code
```

```
body:

{
  "primeiro_nome": "Dictionary BB",
  "responsavel": 0,
  "idade": 20,
  "email": "dictBB@gmail.com",
  "senha": "123456"
}
```

##  

```http
  POST /user/recover-password
```

```
body:

{
  "email": "dictBB@gmail.com"
}
```

##  

```http
  POST /user/login
```

```
body:

{
  "email": "dictBB@gmail.com",
  "password": "123456"
}
```

```
response 200:

{
    "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.e30.LwimMJA3puF3ioGeS-tfczR3370GXBZMIL-bdpu4hOU"
	"refresh_token": "8fca882d-dedd-11ee-adc8-bd24e3c67090"
}
```

##  

```http
  GET /user/details
```

`Authorization: Bearer asdqwdgqwemklkjkqlwjeqwkelj`

```
response 200:

{
  "message": "Usuário encontrado",
  "status": "info",
  "content": {
    "first_name": "Dict BB",
    "last_name": "",
    "responsible": "pai",
    "date_birth": "1994-06-25 00:00:00",
    "email": "dictBB@gmail.com"
  }
}
```

##  

```http
  GET /user/block/:access_token
```

| Parameter   | Type       | Description                           |
| :---------- | :--------- | :---------------------------------- |
| `access_token` | `JWT-string` | **Obrigatório**. (Enviado para o email) O access_token de bloqueio de usuário. Não é possível utilizar o access_token de login. |


#### Profile

```http
  POST /profile/:short_uuid_profile/:name
```

| Parameter   | Type       | Description                           |
| :---------- | :--------- | :---------------------------------- |
| `short_uuid_profile` | `UULID-string` | **Obrigatório**. Id curto do perfil. |
| `name` | `string` | **Obrigatório**. Nome de compartilhamento do perfil. |

```
response 200:

{
    "message": "",
    "status": "info",
    "content": {
        "uuid": "4f5038b5...",
        "apelido": "Pitxhico",
        "primeiro_nome": "Dante Lima",
        "segundo_nome": "dos Santos",
        "data_nascimento": 2021,
        "idade": 2,
        "peso": 11.7,
        "sexo": "masculino",
        "altura": 0.8,
        "cor": "Branco",
        "pai": {
            "uuid": "b396a07...",
            "apelido": "",
            "primeiro_nome": "André Luiz",
            "segundo_nome": "Silva Santos",
            "data_nascimento": 1997,
            "idade": 26,
            "peso": 91,
            "sexo": "masculino",
            "altura": 1.67,
            "cor": "Branco",
            "pai": {},
            "mae": {},
            "irmaos": [],
            "_type": "Profile"
        },
        "mae": {
            "uuid": "b396a06...",
            "apelido": "",
            "primeiro_nome": "Milca Regina",
            "segundo_nome": "Floriano de Lima",
            "idade": 28,
            "peso": 62,
            "sexo": "feminino",
            "altura": 1.55,
            "cor": "Preta",
            "pai": {},
            "mae": {},
            "irmaos": [],
            "_type": "Profile"
        },
        "irmaos": []
    }
}
```

#### Words

```http
  POST /words
```

```
body:

{
  "profile_uuid": "80ce1751-...",
  "words": [
    {
      "palavra": "cávitá",
      "traducao": "chave",
      "pronuncia": "cávitá",
      "audio": "https://example.com/131252312.mp3"
    },
    {
      "palavra": "cata",
      "traducao": "gato",
      "pronuncia": "cata",
      "audio": "https://example.com/1231234213.mp3"
    }
  ]
}
```

```
response 200:

{
  "message": "Palavras adicionadas com sucesso!",
  "status": "info"
}
```

```http
  GET /words
```

```
response 200:

[
  {
    "id": 1,
    "palavra": "cávitá",
    "traducao": "chave",
    "pronuncia": "cávitá",
    "audio": "https://example.com/131252312.mp3"
  },
  {
    "id": 2,
    "palavra": "cata",
    "traducao": "gato",
    "pronuncia": "cata",
    "audio": "https://example.com/1231234213.mp3"
  }
]
```

#### Confirmation

```http
  POST /confirmation
```

```
body

{
  "email": "dictBB@gmail.com",
  "code": "836593"
}
```


```
response 200:

{
    "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.e30.LwimMJA3puF3ioGeS-tfczR3370GXBZMIL-bdpu4hOU"
	"refresh_token": "8fca882d-dedd-11ee-adc8-bd24e3c67090"
}
```

```http
  POST /confirmation/recover-password
```

`Authorization: Bearer asdqwdgqwemklkjkqlwjeqwkelj`

```
body

{
  "email": "dictBB@gmail.com",
  "new_password": "senha_muito_secreta_me_isquece",
  "code_confirmation": "123456",
  "current_date": "2024-03-06T16:27:11.469Z"
}
```

```
response 200:

{
    "message": "Senha redefinida com sucesso!",
	"status": "info"
}
```