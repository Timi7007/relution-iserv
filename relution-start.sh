#!/bin/bash
cd '/opt/relution'; docker-compose pull; docker-compose up --detach; docker logs -f docker_relution
