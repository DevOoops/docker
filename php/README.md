# php

Karibbu php docker containers distributed on [docker hub](https://hub.docker.com/r/karibbu/php/tags/).

## Envs

|Name|Description|
|---|---|
|UPLOAD_MAX_SIZE|set php upload max size|
|MEMORY_LIMIT|set php memory limit|
|MAX_EXECUTION_TIME|set php max execution time|
|MAX_INPUT_VARS|set php max input vars|

### tideways

For tideways images, you have to set your api key on `tideways_api_key` secret or `TIDEWAYS_API_KEY` env

|Name|Description|
|---|---|
|TIDEWAYS_API_KEY|tideways api key|
|TIDEWAYS_ENV|tideways env uses `$XEONYS_PLATFORM_ENV` by default (replace prod by production)|
|TIDEWAY_HOST|identify machine on tideways uses container name by default|
|TIDEWAYS_PROXY|set the proxy url|
|TIDEWAYS_APP_NAME|app name uses stack name by default|
|TIDEWAYS_MONITOR_MODE|define monitoring mode see [tideways doc](https://tideways.io/profiler/article/43-sampling)|
|TIDEWAYS_COLLECT_MODE|define collect mode see [tideways doc](https://tideways.io/profiler/article/43-sampling)|
