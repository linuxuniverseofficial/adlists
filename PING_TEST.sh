#!/bin/bash

# URL da lista mestre
MASTER_LIST="https://raw.githubusercontent.com/linuxuniverseofficial/adlists/refs/heads/main/Lists.txt"

echo "--- Baixando lista de URLs de: $MASTER_LIST ---"

# Baixa o conteúdo e armazena em uma variável, removendo espaços em branco ou caracteres invisíveis (\r)
URLS=$(curl -s "$MASTER_LIST" | tr -d '\r')

if [ -z "$URLS" ]; then
    echo "Erro: Não foi possível obter as URLs ou a lista está vazia."
    exit 1
fi

echo "--- Iniciando PING sequencial (curl -I) ---"
echo ""

# Contador para organização
count=0

for url in $URLS
do
    # Pula linhas vazias se houver
    [[ -z "$url" ]] && continue
    
    ((count++))
    
    # Executa o curl -I (apenas cabeçalho)
    # --connect-timeout 5 serve para não travar o script se o site estiver morto
    status=$(curl -o /dev/null -s -w "%{http_code}" -I --connect-timeout 5 "$url")

    if [ "$status" -eq 200 ]; then
        echo "[$count] ✅ 200 OK      - $url"
    elif [ "$status" -eq 301 ] || [ "$status" -eq 302 ]; then
        echo "[$count] ↪️  $status REDIRECT - $url"
    else
        echo "[$count] ❌ $status ERROR    - $url"
    fi
done

echo ""
echo "--- Verificação de $count URLs concluída ---"
