# tensorflow/tensorflow:1.12.3-gpu-py3 not working
FROM tensorflow/tensorflow:1.12.0-gpu-py3

RUN apt update && \
    apt install libsm6 libxext6 libxrender-dev -y && \
    apt install git nano wget tree -y && \
    rm -rf /var/lib/apt/lists/*

RUN pip install gpflow==1.3.0 && \
    pip install tqdm imutils  opencv-python && \
    pip install jupyter_contrib_nbextensions jupyter_nbextensions_configurator autopep8 && \
    jupyter contrib nbextension install --user && \
    jupyter nbextensions_configurator enable --user && \
    jupyter nbextension enable splitcell/splitcell && \
    jupyter nbextension enable codefolding/main && \
    jupyter nbextension enable execute_time/ExecuteTime && \
    jupyter nbextension enable snippets_menu/main && \
    jupyter nbextension enable code_prettify/autopep8 && \
    jupyter nbextension enable toggle_all_line_numbers/main && \
    jupyter nbextension enable latex_envs/latex_envs

RUN mv /notebooks/* /home/ && \
    mkdir /notebooks/tensorflow-notebooks && \
    mv /home/* /notebooks/tensorflow-notebooks/

COPY doc/source/notebooks/* /notebooks/gpflow-notebooks/

WORKDIR /notebooks

EXPOSE 8888

CMD ["/bin/bash", "-c", "jupyter notebook --ip=0.0.0.0 --allow-root"]