FROM riordan/docker-jupyter-scipy-notebook-libpostal
# this container runs jupyter notebook by default

COPY piplist.txt piplist.txt
RUN pip install -r piplist.txt
RUN python -m spacy download en_core_web_md
# RUN python -m spacy download en_core_web_lg

# RUN jupyter notebook --generate-config -y

# https://jupyter-notebook.readthedocs.io/en/stable/public_server.html
# In [1]: from notebook.auth import passwd
# In [2]: passwd()
# Enter password: nms
# Verify password: nms
# Out[2]: 'sha1:67c9e60bb8b6:9ffede0825894254b2e042ea597d771089e11aed'

# puts the hashed password 'nms' into the default jupyter config file (python)
RUN echo "c.NotebookApp.password = 'sha1:9f9dbfde16b1:9b84749aa7238eeb706d72faa582de068d2e5268'" >> ~/.jupyter/jupyter_notebook_config.py

# RUN jupyter notebook

# CMD [ "jupyter", "notebook", "--ip='0.0.0.0'" ] 
#, "--NotebookApp.password='nms'" ]
# --NotebookApp.token="" 

# moved to piplist.txt
# RUN pip install pyshp geopandas descartes
# RUN pip install pyqt5  
USER root
# RUN apt-get install -y python-tk
RUN apt-get update
RUN apt-get install -y python3-pyqt5  
# RUN apt-get install -y pyqt5-dev-tools
# RUN apt-get install -y qttools5-dev-tools
USER jovyan
COPY Notebooks work/Notebooks
