COMPOSE = docker compose -f ../../../../docker-compose.yml
WORKDIR = /workspace/llm-zoomcamp-2026/05-monitoring/code/rag-app
EXEC = $(COMPOSE) exec --workdir $(WORKDIR) notebook

run:
	$(COMPOSE) up -d notebook
	$(EXEC) python assistant.py
chat:
	$(COMPOSE) up -d notebook
	$(EXEC) streamlit run app.py --server.address 0.0.0.0 --server.headless true
database:
	$(COMPOSE) exec pgvector psql -U user -d faq \
		-c "CREATE DATABASE course_assistant;"
init-db:
	$(EXEC) python db.py
check-db:
	$(COMPOSE) exec pgvector psql -U user -d course_assistant \
		-c "SELECT id, question, cost, timestamp FROM conversations;"
query-db:
	$(EXEC) python -c "from db import get_conversations; \
		[print(r.timestamp, r.model, f'{r.cost:.6f}', repr(r.answer[:60])) for r in get_conversations()]"