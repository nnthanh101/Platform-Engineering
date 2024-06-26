### Stage 1. Builder Image
FROM python:3.12-slim AS builder

# ENV PIP_DEFAULT_TIMEOUT=100 \
#     ## Allow statements and log messages to immediately appear
#     PYTHONUNBUFFERED=1 \
#     ## disable a pip version check to reduce run-time & log-spam
#     PIP_DISABLE_PIP_VERSION_CHECK=1 \
#     ## cache is useless in docker image, so disable to reduce image size
#     PIP_NO_CACHE_DIR=1

ARG VENV_NAME="data-engineering"
ENV VENV_NAME=$VENV_NAME

RUN mkdir requirements
COPY install_requirements.sh requirements/
COPY requirements.txt requirements/
RUN bash ./requirements/install_requirements.sh $VENV_NAME

### Final Stage: copy the Python virtual environment from Builder Image
FROM python:3.12-slim AS final

ARG VENV_NAME="data-engineering"
ENV VENV_NAME=$VENV_NAME

LABEL maintainer="nnthanh101@gmail.com"
LABEL version="1.0.1"
ENV LANG=C.UTF-8
ENV TZ=Pacific/Auckland
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY --from=builder /opt/$VENV_NAME /opt/$VENV_NAME

COPY install_requirements.sh install_dependencies.sh requirements/
RUN bash ./requirements/install_dependencies.sh

RUN echo "source /opt/$VENV_NAME/bin/activate" >> ~/.bashrc