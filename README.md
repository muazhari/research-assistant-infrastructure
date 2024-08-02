# research-assistant-infrastructure

## Getting Started
1. Clone [infrastructure](https://github.com/muazhari/research-assistant-infrastructure), [backend](https://github.com/muazhari/research-assistant-backend), and [frontend](https://github.com/muazhari/research-assistant-frontend) repositories.
2. Setup infrastructure, backend, and frontend dependencies.
3. Run the infrastructure, backend, and frontend services. 

## Example
```shell
cd C:\Data\Apps\research-assistant-infrastructure\docker\cuda-torch-tensorflow && docker build . -t muazhari/cuda-torch-tensorflow:latest && cd C:\Data\Apps\research-assistant-backend && docker build . -t muazhari/research-assistant-backend:latest && cd C:\Data\Apps\research-assistant-frontend && docker build . -t muazhari/research-assistant-frontend:latest && cd C:\Data\Apps\research-assistant-infrastructure\docker\one && docker compose up -d --build
```