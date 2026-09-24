<div align="center">

# ⚙️ Infraestrutura AWS com Terraform & NGINX

**Aplicação HTTP em Docker, provisionada na EC2 com Terraform e estado remoto no S3.**

[![Terraform](https://img.shields.io/badge/Terraform-IaC-844FBA?style=for-the-badge&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![AWS](https://img.shields.io/badge/AWS-EC2%20%7C%20S3-232F3E?style=for-the-badge&logo=amazonwebservices&logoColor=white)](https://aws.amazon.com/)
[![Docker](https://img.shields.io/badge/Docker-Container-2496ED?style=for-the-badge&logo=docker&logoColor=white)](https://www.docker.com/)
[![NGINX](https://img.shields.io/badge/NGINX-stable--alpine-009639?style=for-the-badge&logo=nginx&logoColor=white)](https://nginx.org/)
[![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-CI-2088FF?style=for-the-badge&logo=githubactions&logoColor=white)](https://docs.github.com/en/actions)

</div>

---

## 📌 Visão geral

Este projeto cria uma rede pública na AWS, uma instância EC2 e as regras necessárias para servir uma página estática pelo NGINX. Na primeira inicialização, a instância instala o Docker, constrói a imagem da aplicação e sobe o contêiner.

O estado da infraestrutura principal fica em um bucket S3 criado separadamente pelo diretório `bootstrap/`. A configuração foi dividida em módulos de rede e aplicação para facilitar a leitura e a manutenção.

## 🏛️ Arquitetura

```text
Internet
   │ HTTP :80
   ▼
Internet Gateway (associado à VPC)
   │
   ▼
VPC
└── Subnet pública (rota padrão para o Internet Gateway)
    └── EC2 com IP público (Amazon Linux 2023)
        ├── Security Group: permite entrada HTTP :80
        └── Docker → NGINX :80
                     ├── /        página estática
                     └── /health  resposta "ok"

Terraform ── estado remoto + lock ── S3
```

O `user_data` executa o script de preparação na primeira inicialização da EC2: instala o Docker, constrói a imagem e inicia o contêiner. Depois disso, as requisições HTTP são atendidas pelo NGINX.

A EC2 tem um perfil IAM para acesso pelo AWS Systems Manager; a porta SSH não é aberta. O volume raiz é criptografado. O bucket de estado usa versionamento, criptografia e bloqueio de acesso público.

É uma arquitetura de **uma instância**, com IP público dinâmico e HTTP. Ela não oferece alta disponibilidade, domínio ou TLS.

## 📁 Estrutura do repositório

```text
.
├── .github/workflows/validate.yml   # Formatação, validação e teste HTTP
├── app/                             # Dockerfile, NGINX e página HTML
├── bootstrap/                       # Bucket S3 para o estado remoto
├── modules/
│   ├── network/                     # VPC, subnet e rotas
│   └── web/                         # EC2, Security Group e IAM
├── scripts/bootstrap.sh.tftpl       # Inicialização da EC2
├── backend.tf                       # Estado remoto no S3
├── main.tf                          # Composição dos módulos
├── outputs.tf                       # IP, URL e IDs
├── provider.tf                      # Região e tags
├── variables.tf                     # Parâmetros do ambiente
└── versions.tf                      # Versões aceitas
```

Os arquivos `.terraform.lock.hcl` da raiz e de `bootstrap/` fixam as versões dos providers selecionados em cada configuração.

## 🚀 Executar na AWS

**Pré-requisitos:** Terraform 1.10 ou superior (abaixo da versão 2.0), credenciais AWS configuradas localmente e permissão para criar os recursos. Escolha um nome de bucket S3 globalmente único.

### 1. Criar o bucket de estado

No diretório `bootstrap/`:

```sh
terraform init
terraform apply -var="state_bucket_name=nome-unico-do-seu-bucket"
terraform output
```

Anote o nome e a região retornados. O estado desse primeiro passo fica em `bootstrap/terraform.tfstate`, na sua máquina. **Guarde esse arquivo com segurança e não o envie ao Git:** ele é necessário para gerenciar ou remover o bucket depois.

### 2. Criar a aplicação

Volte à raiz do projeto e inicialize o backend. Em `-backend-config="region=..."`, informe a região onde o bucket foi criado. A variável `aws_region` da raiz define onde a rede e a EC2 serão criadas. Essas regiões são independentes; neste exemplo, ambas usam `us-east-2`.

```sh
terraform init -backend-config="bucket=nome-unico-do-seu-bucket" -backend-config="region=us-east-2"
terraform plan
terraform apply
terraform output app_url
```

Abra a URL exibida. A primeira inicialização da EC2 pode levar alguns minutos enquanto instala o Docker e constrói a imagem. O log desse processo fica em `/var/log/terraform-web-bootstrap.log` na instância.

Os valores padrão estão em `variables.tf`. Para alterá-los, use `-var` ou um arquivo `terraform.tfvars` local. Reutilize os mesmos valores em `plan`, `apply` e `destroy`.

### Sobre ambientes

Este exemplo configura um único ambiente. Alterar `environment` muda nomes e tags, mas mantém o mesmo estado remoto: a chave em `backend.tf` está definida como `terraform-aws-nginx/dev/terraform.tfstate`. Aplicar essa alteração pode modificar ou substituir os recursos já gerenciados. Para criar outro ambiente independente, configure um estado separado antes de executar o Terraform.

## 🧪 Testar localmente

Com Docker instalado:

```sh
docker build -t terraform-aws-nginx ./app
docker run --rm -p 8080:80 terraform-aws-nginx
```

Acesse `http://localhost:8080` para ver a página e `http://localhost:8080/health` para conferir a resposta `ok`.

## ✅ Validação automática

Em cada push ou pull request, o workflow verifica a formatação do Terraform, valida a configuração principal e a de `bootstrap/`, constrói a imagem Docker e testa `/health`. Essa validação **não faz deploy** nem comprova que os recursos foram criados na AWS.

## 🧹 Remover os recursos

Execute `terraform destroy` na raiz com os mesmos valores usados na criação. Depois, se não precisar mais do bucket, remova seus objetos e versões e execute `terraform destroy` em `bootstrap/` com o mesmo `state_bucket_name`. Preserve o estado local de `bootstrap/` até concluir essa etapa.

> **Custos:** EC2, volume EBS, IPv4 público e S3 podem gerar cobrança. Confira os valores na sua conta AWS e remova os recursos quando terminar.
