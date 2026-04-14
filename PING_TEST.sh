#!/bin/bash

MASTER_LIST="https://raw.githubusercontent.com/linuxuniverseofficial/adlists/refs/heads/main/Lists.txt"

echo "--- Obtendo e filtrando URLs de: $MASTER_LIST ---"

# 1. Baixa a lista
# 2. tr -d '\r' remove lixo de formatação Windows
# 3. grep -E '^https?://' garante que a linha COMECE com http:// ou https://
URLS=$(curl -s "$MASTER_LIST" | tr -d '\r' | grep -E '^https?://')

if [ -z "$URLS" ]; then
    echo "Erro: Nenhuma URL válida encontrada."
    exit 1
fi

echo "--- Iniciando verificação sequencial ---"
echo ""

count=0
for url in $URLS
do
    ((count++))
    
    # Realiza o curl -I (apenas cabeçalho) com timeout de 5 segundos
    status=$(curl -o /dev/null -s -w "%{http_code}" -I --connect-timeout 5 "$url")

    if [ "$status" -eq 200 ]; then
        echo "[$count] ✅ 200 OK - $url"
    else
        echo "[$count] ❌ $status Erro ou Inativo - $url"
    fi
done

echo ""
echo "--- Verificação de $count URLs concluída ---"
