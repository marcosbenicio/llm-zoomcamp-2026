#!/bin/bash
# Cheatsheet do stack de estudos.
# Uso: ./docker_setup.sh

set -a
source .env 2>/dev/null
set +a

cat <<EOF

================================================================
  Status dos containers
================================================================
EOF

docker compose ps --format "  {{.Name}}: {{.Status}}" 2>/dev/null \
  || echo "  (compose nao esta rodando ou nao foi achado)"

cat <<EOF

================================================================
  URLs / Conexoes
================================================================

  Jupyter:    http://localhost:9811/?token=${JUPYTER_TOKEN}
  Elastic:    http://localhost:9200
  Kestra UI:  http://localhost:8080
              login: admin@kestra.io / Admin1234!
  Grafana:    http://localhost:3000
              login: admin / admin
  Streamlit:  http://localhost:8501  (chat app,  via make chat)
              http://localhost:8502  (dashboard, via make dashboard)

================================================================
  Variaveis de ambiente do notebook
================================================================

  # Jupyter
  JUPYTER_TOKEN=${JUPYTER_TOKEN}

  # Elasticsearch
  ELASTIC_HOST=http://elasticsearch:9200

  # Postgres (pgvector)
  POSTGRES_HOST=pgvector
  POSTGRES_PORT=5432
  POSTGRES_USER=user
  POSTGRES_PASSWORD=pswd
  POSTGRES_DB=faq

  # API keys (raw, mascarados). Versoes base64 (SECRET_*) tambem estao
  # no .env — usadas pelo Kestra internamente.
  OPENAI_API_KEY=${OPENAI_API_KEY:0:10}...
  GEMINI_API_KEY=${GEMINI_API_KEY:0:10}...
  TAVILY_API_KEY=${TAVILY_API_KEY:0:10}...

  Uso em Python:
    import os
    os.getenv("POSTGRES_HOST")

================================================================
  Setup inicial do pgvector (rodar UMA VEZ)
================================================================

  Ativar a extensao vector no banco faq:
    docker compose exec pgvector psql -U user -d faq \\
      -c "CREATE EXTENSION IF NOT EXISTS vector;"

  Conferir que ativou:
    docker compose exec pgvector psql -U user -d faq \\
      -c "SELECT extname, extversion FROM pg_extension WHERE extname='vector';"

================================================================
  Acesso rapido aos servicos via CLI
================================================================

  Postgres (psql interativo):
    docker compose exec pgvector psql -U user -d faq

  Kestra_postgres (isolado em kestra-net, so via exec):
    docker compose exec kestra_postgres psql -U kestra -d kestra

  Elastic (health):
    curl -s http://localhost:9200/_cluster/health | jq

  Kestra (health):
    curl -s http://localhost:8081/health | jq

================================================================

EOF
