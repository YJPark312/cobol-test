# C2J-Pilot Docker 환경 구성 가이드

## 1. 전체 아키텍처 개요

```
┌─────────────────────────────────────────────────────────────────┐
│                      Docker Compose 환경                         │
│                                                                  │
│  ┌──────────┐     ┌──────────┐                                  │
│  │  c2j-app  │────▶│  neo4j   │  ← 그래프 DB (지식 저장소)       │
│  │  :8123    │     │ :7474/7687│                                 │
│  └────┬─────┘     └──────────┘                                  │
│       │                                                          │
│       │           ┌──────────────────────────────────────┐      │
│       └──────────▶│          Langfuse (LLM 관측)          │      │
│                   │  ┌──────────┐  ┌───────────────────┐ │      │
│                   │  │ langfuse  │  │  langfuse-worker  │ │      │
│                   │  │  :3000    │  │                   │ │      │
│                   │  └─────┬────┘  └────────┬──────────┘ │      │
│                   │        │                │             │      │
│                   │  ┌─────┴────────────────┴──────┐     │      │
│                   │  │  langfuse-db (PostgreSQL)    │     │      │
│                   │  │  langfuse-clickhouse         │     │      │
│                   │  │  langfuse-redis              │     │      │
│                   │  │  langfuse-minio              │     │      │
│                   │  └─────────────────────────────┘     │      │
│                   └──────────────────────────────────────┘      │
└─────────────────────────────────────────────────────────────────┘
```

### 컨테이너 목록

| 컨테이너 | 이미지 | 포트 | 역할 |
|-----------|--------|------|------|
| c2j-app | c2j-pilot-app:latest | 8123 | 메인 애플리케이션 |
| c2j-neo4j | neo4j:5-community | 7474 (UI), 7687 (Bolt) | 그래프 데이터베이스 |
| c2j-langfuse | langfuse/langfuse:3 | 3000 | LLM Observability UI |
| c2j-langfuse-worker | langfuse/langfuse-worker:3 | - | Langfuse 백그라운드 워커 |
| c2j-langfuse-db | postgres:17-alpine | 5432 (내부) | Langfuse 메타데이터 DB |
| c2j-langfuse-clickhouse | clickhouse/clickhouse-server:24.3 | 8123, 9000 (내부) | Langfuse 이벤트 분석 DB |
| c2j-langfuse-redis | redis:7-alpine | 6379 (내부) | Langfuse 캐시/큐 |
| c2j-langfuse-minio | minio/minio:latest | 9000 (내부) | Langfuse 오브젝트 스토리지 |

---

## 2. 사전 요구사항

- **Docker Desktop** (Mac/Windows) 또는 **Docker Engine** (Linux)
- **Docker Compose** v2 이상
- 최소 **8GB 이상 RAM**을 Docker에 할당 (Docker Desktop > Settings > Resources)
- 디스크 여유 공간 **15GB 이상** (이미지 + 볼륨 데이터)

### 버전 확인

```bash
docker --version          # 예: Docker version 29.2.1
docker compose version    # 예: Docker Compose version v5.1.0
```

---

## 3. 환경 변수 설정 (.env 파일)

프로젝트 루트에 `.env` 파일을 생성합니다:

```bash
cp .env.example .env   # 템플릿이 있는 경우
# 또는 직접 생성
```

`.env` 파일에 아래 값들을 설정합니다:

```env
# Neo4j 접속 정보
NEO4J_URI=bolt://neo4j:7687
NEO4J_USER=neo4j
NEO4J_PASSWORD=c2j-pilot-2024

# Anthropic API 키 (Claude AI 호출용)
ANTHROPIC_API_KEY=sk-ant-xxxxxxxxxxxxxxxx

# Langfuse 키 (Langfuse UI에서 프로젝트 생성 후 발급)
LANGFUSE_SECRET_KEY=sk-lf-xxxxxxxx
LANGFUSE_PUBLIC_KEY=pk-lf-xxxxxxxx
```

> **참고:** `LANGFUSE_SECRET_KEY`와 `LANGFUSE_PUBLIC_KEY`는 Langfuse 초기 설정 후 발급받습니다. 아래 "5. Langfuse 초기 설정" 참고.

---

## 4. 설치 및 실행

### 4-1. 전체 서비스 빌드 및 실행

```bash
cd /path/to/C2J-Pilot

# 이미지 빌드 + 전체 서비스 시작 (백그라운드)
docker compose up -d --build
```

### 4-2. 서비스별 개별 실행

```bash
# Neo4j만 실행
docker compose up -d neo4j

# Langfuse 관련 전체 실행 (의존성 자동 포함)
docker compose up -d langfuse

# 메인 앱 실행 (neo4j, langfuse 의존성 자동 시작)
docker compose up -d app
```

### 4-3. 데이터 로더 실행 (일회성)

로더는 `loader` 프로파일로 분리되어 있어 별도 명령이 필요합니다:

```bash
# 지식 데이터 로딩 (Neo4j에 데이터 적재)
docker compose --profile loader up loader
```

### 4-4. 상태 확인

```bash
# 모든 컨테이너 상태 확인
docker compose ps

# 특정 컨테이너 로그 확인
docker compose logs -f app        # 앱 로그 (실시간)
docker compose logs -f neo4j      # Neo4j 로그
docker compose logs -f langfuse   # Langfuse 로그
```

---

## 5. Langfuse 초기 설정

Langfuse는 최초 실행 시 계정 및 프로젝트 설정이 필요합니다.

1. 모든 서비스 시작: `docker compose up -d`
2. 브라우저에서 **http://localhost:3000** 접속
3. **Sign Up** 으로 관리자 계정 생성
4. 프로젝트 생성 후 **Settings > API Keys** 에서 키 발급
5. 발급받은 키를 `.env` 파일에 입력:
   ```env
   LANGFUSE_SECRET_KEY=sk-lf-발급받은키
   LANGFUSE_PUBLIC_KEY=pk-lf-발급받은키
   ```
6. 앱 컨테이너 재시작:
   ```bash
   docker compose restart app
   ```

---

## 6. 접속 URL 정리

| 서비스 | URL | 용도 |
|--------|-----|------|
| 메인 앱 | http://localhost:8123 | C2J 파일럿 애플리케이션 |
| Neo4j Browser | http://localhost:7474 | 그래프 DB 쿼리/시각화 |
| Langfuse | http://localhost:3000 | LLM 호출 추적/모니터링 |

### Neo4j 접속 정보

- **URL:** bolt://localhost:7687
- **Username:** neo4j
- **Password:** c2j-pilot-2024

---

## 7. 서비스 간 연결 구조

Docker Compose가 자동으로 내부 네트워크를 생성하며, 컨테이너끼리는 **서비스명으로 통신**합니다:

```
app  →  neo4j:7687        (Bolt 프로토콜, 그래프 쿼리)
app  →  langfuse:3000     (HTTP, LLM 추적 데이터 전송)

langfuse        →  langfuse-db:5432          (PostgreSQL, 메타데이터)
langfuse        →  langfuse-clickhouse:8123  (ClickHouse, 이벤트 분석)
langfuse        →  langfuse-redis:6379       (Redis, 캐시/큐)
langfuse        →  langfuse-minio:9000       (MinIO, 파일 저장)
langfuse-worker →  (동일한 백엔드 서비스들 공유)
```

---

## 8. 데이터 영속성 (Volumes)

아래 Docker 볼륨에 데이터가 저장됩니다. 컨테이너를 삭제해도 볼륨은 유지됩니다:

| 볼륨 | 용도 |
|------|------|
| neo4j_data | Neo4j 그래프 데이터 |
| neo4j_logs | Neo4j 로그 |
| langfuse_pg_data | Langfuse PostgreSQL 데이터 |
| langfuse_ch_data | Langfuse ClickHouse 데이터 |
| langfuse_ch_logs | Langfuse ClickHouse 로그 |
| langfuse_minio_data | Langfuse MinIO 오브젝트 데이터 |

---

## 9. 중지 및 정리

```bash
# 서비스 중지 (데이터 유지)
docker compose down

# 서비스 중지 + 볼륨 삭제 (⚠️ 모든 데이터 삭제)
docker compose down -v

# 특정 서비스만 재시작
docker compose restart neo4j
docker compose restart langfuse
```

---

## 10. 트러블슈팅

### Langfuse가 시작되지 않는 경우

Langfuse는 DB, ClickHouse, Redis, MinIO가 모두 healthy 상태여야 시작됩니다.

```bash
# 의존 서비스 상태 확인
docker compose ps langfuse-db langfuse-clickhouse langfuse-redis langfuse-minio

# 개별 서비스 로그 확인
docker compose logs langfuse-db
```

### Neo4j 메모리 부족

`docker-compose.yml`에서 힙 메모리 조정:

```yaml
environment:
  - NEO4J_dbms_memory_heap_max__size=2G   # 기본 1G → 필요시 증가
```

### 포트 충돌

이미 사용 중인 포트가 있으면 `docker-compose.yml`에서 호스트 포트(왼쪽)를 변경합니다:

```yaml
ports:
  - "18123:8123"   # 호스트:컨테이너 (호스트 포트만 변경)
```

### 전체 초기화 (처음부터 다시)

```bash
docker compose down -v
docker compose up -d --build
```
