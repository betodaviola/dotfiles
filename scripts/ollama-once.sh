#!/usr/bin/env bash

export OLLAMA_HOST=0.0.0.0:11434
export OLLAMA_CONTEXT_LENGTH=16384
export OLLAMA_MODELS=/mnt/storage/ollamaModels

ollama serve &
sleep 1

