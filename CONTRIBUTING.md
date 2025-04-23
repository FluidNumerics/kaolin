# Kaolin
Copyright 2025 Fluid Numerics LLC

### Code formatting
Each pull request is checked for formatting before running other tests. The `kaolin` project uses [`fprettify`](https://pypi.org/project/fprettify/) for formatting fortran source code. We have included a configuration file in the `kaolin` repository (`fprettify.config`) that can be used for ensuring formatting correctness.

#### Using pre-commit
SELF comes with a `.pre-commmit-config.yaml` file that can be used with [`pre-commit`](https://pre-commit.com/). The benefit of using pre-commit is that this automates applying formatting to all Fortran files in SELF with each commit. To use `pre-commit` :

1. Install `pre-commit` 

```
pip install pre-commit fprettify
```

2. Configure your pre-commit hooks. This command must be run from the root directory of the `kaolin` repository

```
pre-commit install
```

#### Manual formatting
You can run the following to format code to conform to the expected format for `kaolin`.

```
fprettify  './src/' --config-file ./fprettify.config --recursive --case 1 1 1 1
fprettify  './test/' --config-file ./fprettify.config --recursive --case 1 1 1 1
fprettify  './examples/' --config-file ./fprettify.config --recursive --case 1 1 1 1
```
