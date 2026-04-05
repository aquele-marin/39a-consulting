# 39a-consulting

## Configurar variaveis de ambiente

Basta renomear o arquivo .env.example para apenas .env

## Rodar docker

```bash
docker compose up
```

## Abrir n8n e cadastrar owner account 

## Na pagina de workflow importar ambos os workflows

Workflow para importar dados: etl-workflow.json
Workflow para rodar consulta e analise: main-workflow.json

## Configurar conexoes com postgres e openai

Clicar nos nodes de OpenAI e Postgres do Workflow principal e configurar credenciais

#### Postgres

host: postgres
database: mydatabase
user: admin
password: 123456

#### OpenAI

{{Chave da API enviada por email}}

#### Recarregue nodes

Abra os nodes e verifique se as credenciais estao selecionadas, evitando bugs na execucao

## Carregar dados do .zip

No workflow de extração do zip, clique em "Execute workflow"
Basta executar o comando abaixo para executar o workflow com o zip dos dados

**Substitua a URL pela que foi gerada ao importar o workflow**

```bash
curl -X POST http://localhost:5678/webhook-test/SUA_URL -F "data=@assets/dados.zip;type=application/zip;filename=dados.zip"
```

## Fazer a requisicao

Dessa vez, no workflow de coleta e analise, clicamos em "Execute workflow" para ativar o teste na feature.
Agora podemos apenas fazer a requisicao de GET para gerar o relatorio e coletar dados

```bash
curl -X GET http://localhost:5678/webhook-test/SUA_URL
```