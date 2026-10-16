# Biblioteca lhm

Aplicativo em Flutter para organizar uma biblioteca pessoal: cadastrar livros, editar, marcar como lido e ver os livros lidos.

Projeto prático (Parte 1) da disciplina Programação para dispositivos móveis.

- Integrante: Lucas Hideki Miyazaki
- Instituição: Fatec Ribeirão Preto
- Professor: Rodrigo Plotz

## O que o app tem

- Login, cadastro de usuário, esqueceu a senha, sobre e perfil
- Listar livros (ListView)
- Cadastrar livro
- Editar livro
- Detalhes do livro (marcar como lido e excluir)
- Livros lidos (GridView)

Os dados dos livros e dos usuários são de exemplo e ficam só na memória, então se perdem quando o app fecha.

## O que precisa instalar

```
flutter pub add device_preview_plus
flutter pub add get_it
flutter pub add http
```

## E-mail e senha para teste

Conta para testar: teste@email.com / 123456

## E-mail do "Esqueceu a senha"

O app envia uma senha temporária por e-mail usando o EmailJS (emailjs.com). 

O que foi feito para a recuperação de senha funcionar:
1. Criar uma conta no EmailJS e conectar um e-mail em Email Services (pegar o Service ID).
2. Criar um template em Email Templates com To Email `{{to_email}}` e no texto `{{to_name}}` e `{{nova_senha}}` (pegar o Template ID).
3. Copiar a Public Key em Account > General.
4. Colocar os três valores no começo do arquivo `lib/controller/recuperar_senha_controller.dart`.

Para testar, cadastre uma conta com um e-mail seu e use o "Esqueceu a senha?".

## Pastas

- `lib/controller` regras e estado das telas
- `lib/model` usuário, livro e sessão
- `lib/view` telas
- `lib/core` rotas e dependências
