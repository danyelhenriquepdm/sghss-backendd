# Estágio 1: Build - Compilação do TypeScript
FROM node:20-alpine AS builder 

# Define o diretório de trabalho dentro do container
WORKDIR /app

# Copia e instala as dependências
COPY package*.json ./
# O 'npm install' sem flags instala DEVs, mas para clareza, 
# vamos garantir que o cache do Docker use essa instrução para instalar TUDO.
RUN npm install

# Copia o código-source inteiro para a compilação
COPY . .

# Compila o código TypeScript (gera a pasta 'dist')
# ESTE COMANDO AGORA FUNCIONARÁ, pois 'tsc' foi instalado no passo anterior.
RUN npm run build


# Estágio 2: Produção - Imagem final
FROM node:20-alpine

# Define o diretório de trabalho
WORKDIR /app

# Copia SÓ os arquivos de produção necessários da fase de build
COPY --from=builder /app/package*.json ./
# Copiamos o node_modules COMPLETO para ter certeza das dependências
COPY --from=builder /app/node_modules ./node_modules
# Copia o código compilado
COPY --from=builder /app/dist ./dist

# Define a porta que o container irá expor (3000)
EXPOSE 3000

# Comando para iniciar o servidor Node.js
CMD [ "npm", "start" ]