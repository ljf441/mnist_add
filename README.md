# mnist_add
An inference pipeline which adds handwritten MNIST digits.

# how to use with Docker
This project is able to be run using a Docker image. This environment includes Jupyter Notebooks as well as a conda environment with the requisite CUDA and CUDAnn libraries.
## NVIDIA Container Toolkit

The NVIDIA Container Toolkit must be installed such that this project can be run using the GPU. Instructions for this can be found in the [NVIDIA documentation](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html). These instructions are also replicated below for completeness.

## steps

1. Configure the root repository.

```
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
```
2. Update packages list.
```
sudo apt-get update
```
3. Install the NVIDIA Container Toolkit packages.
```
sudo apt-get install -y nvidia-container-toolkit
```
4. Configure Docker (this requires Docker to be already installed). If Docker is not installed, please install it using Docker Desktop.
```
sudo nvidia-ctk runtime configure --runtime=docker
```
5. Restart Docker.
```
sudo systemctl restart docker
```
6. Build the Docker image within the directory.
```
docker build -t mnist_add-img .
```
7. Run the Docker image, making sure to allow for GPU and port usage.
```
docker run --gpus all -it -p 8888:8888 mnist_add-img
```
8. This will result in Jupyter Notebook being run. You will see a URL like:
```
http://127.0.0.1:8888/?token=<token>
```
9. View this URL with a browser of your choice. Google Chrome or Firefox is recommended.
10. To stop running the container use Docker Desktop. To stop running Jupyter Notebook, type `CTRL-C` in the terminal.

## within the Docker image
The Docker image contains:
1. Jupyter Notebooks:
    - `pipeline.ipynb` covering tasks 1, 2, and 5 of the coursework.
    - `inference.ipynb` covering task 3 of the coursework.
    - `classifier.ipynb` covering task 4 of the coursework.
2. `.keras` and `.pkl` files:
    - Neural Networks:
        - `nn_best_study999_params.pkl`, which contains the best Optuna hyperparameter tuning results. This can be used to build the architecture for the best-performing neural network.
        - `nn_fitted_model999.keras`, which contains the fitted Tensorflow model weights. This can be loaded in and used immediately.
    - SVMs:
        - `best_svm_model.pkl`, which contains the best Optuna hyperparameter tuning results. This can be used to build the architecture for the best-performing SVM.
        - `svm_fitted_model.pkl`, which contains the fitted SVM model. This can be loaded in and used immediately.
    - Random Forest:
        - `best_forest_model.pkl`, which contains the best Optuna hyperparameter tuning results. This can be used to build the architecture for the best-performing Random Forest model.
    - AdaBoost:
        - `best_adaboost_model.pkl`, which contains the best Optuna hyperparameter tuning results. This can be used to build the architecture for the best-performing AdaBoost model.

# where to find the report
The report is located in the `report` folder and is named `report.pdf`.

# use of auto-generation tools

Auto-generation tools were used as follows:
- To help setup `Tensorflow` on a WSL2 environment to be able to use the GPU.
- Parsing error messages throughout the project.
- Assistance in formatting the report in $\LaTeX$, specifically with tables and referencing.
- Code prototyping in plotting the results for task 4. 

Auto-generation tools were not used elsewhere, for code generation or writing or otherwise.