# hash:sha256:7ee06ec1fd435d5cfa88fad9d2b6bf2b056daba049ff8c4930eb5dcb91a92691
FROM registry.codeocean.com/codeocean/r-studio:2022.07.0-548-r4.2.1-ubuntu18.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        libgdal-dev=2.2.3+dfsg-2 \
        libjq-dev=1.5+dfsg-2 \
        libprotobuf-dev=3.0.0-9.1ubuntu1 \
        libv8-dev=3.14.5.8-11ubuntu1 \
        protobuf-compiler=3.0.0-9.1ubuntu1 \
    && rm -rf /var/lib/apt/lists/*

RUN Rscript -e 'remotes::install_version("dplyr", "1.0.10")' \
    && Rscript -e 'remotes::install_version("ggmap", "3.0.1")' \
    && Rscript -e 'remotes::install_version("ggplot2", "3.4.0")' \
    && Rscript -e 'remotes::install_version("ggplotify", "0.1.0")' \
    && Rscript -e 'remotes::install_version("grid")' \
    && Rscript -e 'remotes::install_version("gridExtra", "2.3")' \
    && Rscript -e 'remotes::install_version("here", "1.0.1")' \
    && Rscript -e 'remotes::install_version("plotly", "4.10.1")' \
    && Rscript -e 'remotes::install_version("purrr", "1.0.1")' \
    && Rscript -e 'remotes::install_version("readr", "2.1.3")' \
    && Rscript -e 'remotes::install_version("rgdal", "1.6-4")' \
    && Rscript -e 'remotes::install_version("rmarkdown", "2.20")' \
    && Rscript -e 'remotes::install_version("scatterpie", "0.1.8")' \
    && Rscript -e 'remotes::install_version("sf", "1.0-9")' \
    && Rscript -e 'remotes::install_version("sp", "1.6-0")' \
    && Rscript -e 'remotes::install_version("tidycensus")' \
    && Rscript -e 'remotes::install_version("tidyr", "1.2.1")' \
    && Rscript -e 'remotes::install_version("tigris", "2.0")'

RUN Rscript -e 'remotes::install_github( \
        "mstrimas/smoothr", \
        ref = "2c0e05710d720d4a252788d2df3152d63b568c5c")' \
    && Rscript -e 'remotes::install_github( \
        "walkerke/tidycensus", \
        ref = "4dc46fd7dbba7d8ed4eb80168a38f18096804589")'

COPY postInstall /
RUN /postInstall
