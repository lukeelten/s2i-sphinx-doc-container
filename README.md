# Sphinx Documentation Openshift Source-to-image

## Build Docker image

``` bash
docker build -t iconoeugen/s2i-sphinx-doc .
```

## Want to try it right now?

To generate the documentation and make it available under a different context path, you can change the the following line accordingly:

``` bash
export CONTEXT_PATH=/
export MAKE_TARGET=html
```

Download the latest Openshift S2I tool and run the build:

``` bash
s2i build https://github.com/iconoeugen/s2i-sphinx-doc-container.git --context-dir=test/test-app -e MAKE_TARGET=${MAKE_TARGET} iconoeugen/s2i-sphinx-doc sphinx-doc-sample-app
```

Test the generated documentation:

```
docker run -p 8080:8080 -e CONTEXT_PATH=${CONTEXT_PATH} sphinx-doc-sample-app
```

**Accessing the application:**

``` bash
curl http://127.0.0.1:8080/${CONTEXT_PATH}
```

### Debug the scripts

To start each script manually to build the documentation and to run the HTTP server, you can start a docker instance:

``` bash
docker run -it --rm -p 8080:8080 -u $UID -v $PWD/test/test-app:/tmp/src -e CONTEXT_PATH=${CONTEXT_PATH} iconoeugen/s2i-sphinx-doc bash
```

To build the documentation inside the running container:

``` bash
/usr/libexec/s2i/assemble
```

To run the HTTP server inside the running container:

``` bash
/usr/libexec/s2i/run
```

## Environment variables

To set these environment variables, you can place them as a key value pair into a .s2i/environment file inside your source code repository.

* **PIP_INDEX_URL**

    Set this variable to use a custom index URL or mirror to download required packages
    during build process. This only affects packages listed in requirements.txt.

* **CONTEXT_PATH**

    The prefix of a URL path where the documentation will be made available. (Default: `/`)

* **MAKE_TARGET**

    A format is selected by specifying the builder name that is provided as target to sphinx generated Makefile. (Default: `html`)

## Initialize documentation in source code repository

``` bash
docker run -it --rm -u $UID -v docs:/opt/app-root/src s2i-sphinx-doc bash
```

Populate the documentation with a new Sphix documentation

``` bash
sphinx-quickstart
```

```
Welcome to the Sphinx 1.2.2 quickstart utility.

Please enter values for the following settings (just press Enter to
accept a default value, if one is given in brackets).

Enter the root path for documentation.
> Root path for the documentation [.]:

You have two options for placing the build directory for Sphinx output.
Either, you use a directory "_build" within the root path, or you separate
"source" and "build" directories within the root path.
> Separate source and build directories (y/n) [n]: y

Inside the root directory, two more directories will be created; "_templates"
for custom HTML templates and "_static" for custom stylesheets and other static
files. You can enter another prefix (such as ".") to replace the underscore.
> Name prefix for templates and static dir [_]:

The project name will occur in several places in the built documentation.
> Project name: Test
> Author name(s): Horatiu Vlad

Sphinx has the notion of a "version" and a "release" for the
software. Each version can have multiple releases. For example, for
Python the version is something like 2.5 or 3.0, while the release is
something like 2.5.1 or 3.0a1.  If you don't need this dual structure,
just set both to the same value.
> Project version: 0.0.1
> Project release [0.0.1]:

The file name suffix for source files. Commonly, this is either ".txt"
or ".rst".  Only files with this suffix are considered documents.
> Source file suffix [.rst]:

One document is special in that it is considered the top node of the
"contents tree", that is, it is the root of the hierarchical structure
of the documents. Normally, this is "index", but if your "index"
document is a custom template, you can also set this to another filename.
> Name of your master document (without suffix) [index]:

Sphinx can also add configuration for epub output:
> Do you want to use the epub builder (y/n) [n]:

Please indicate if you want to use one of the following Sphinx extensions:
> autodoc: automatically insert docstrings from modules (y/n) [n]:
> doctest: automatically test code snippets in doctest blocks (y/n) [n]:
> intersphinx: link between Sphinx documentation of different projects (y/n) [n]:
> todo: write "todo" entries that can be shown or hidden on build (y/n) [n]:
> coverage: checks for documentation coverage (y/n) [n]:
> pngmath: include math, rendered as PNG images (y/n) [n]:
> mathjax: include math, rendered in the browser by MathJax (y/n) [n]:
> ifconfig: conditional inclusion of content based on config values (y/n) [n]:
> viewcode: include links to the source code of documented Python objects (y/n) [n]:

A Makefile and a Windows command file can be generated for you so that you
only have to run e.g. `make html' instead of invoking sphinx-build
directly.
> Create Makefile? (y/n) [y]:
> Create Windows command file? (y/n) [y]: n

Creating file ./source/conf.py.
Creating file ./source/index.rst.
Creating file ./Makefile.

Finished: An initial directory structure has been created.

You should now populate your master file ./source/index.rst and create other documentation
source files. Use the Makefile to build the docs, like so:
   make builder
where "builder" is one of the supported builders, e.g. html, latex or linkcheck.
```

### Add dependencies

The requirements file is a way to get pip to install specific packages to make up an environment.
The requrement file must be named `requirements.txt` as expected by `pip`

### Use Read The Docs theme

To configure sphixn to use `ReadTheDocs` theme you have to change the `conf.py` property as follows:

```
html_theme = 'sphinx_rtd_theme'
```

and define the new python dependency in `requirements.txt` file:

```
sphinx_rtd_theme
```

## Openshift deploy template

### Create image stream

You must create an image stream for the S2I image builder before creating an application:

``` bash
oc create -f openshift/image-stream.json -n openshift
```

### Upload application template

To upload the template to your current project’s template library, pass the JSON file with the following command:

``` bash
oc create -f openshift/template.json
```
