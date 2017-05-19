
# HIT381 project files

Copyright © 2017 Samuel Walladge


## About

Files and such for the project - functional prototypes, etc.

## Links

Various versions are deployed at the following urls:

- deliverable 1 (initial design): <https://uni.swalladge.id.au/hit381/functional_prototype1/>
- deliverable 2 (adding functionality): <https://uni.swalladge.id.au/hit381/functional_prototype2/>
- deliverable 3 (as tested in user testing):
  <https://uni.swalladge.id.au/hit381/functional_prototype3/>
- deliverable 3 (with button redesign): <https://uni.swalladge.id.au/hit381/functional_prototype3-btn-redesign/>
- deliverable 4 (after user testing): <https://uni.swalladge.id.au/hit381/functional_prototype4/>
- deliverable 5 (after web tests): <https://uni.swalladge.id.au/hit381/functional_prototype5/>
- final prototype: <https://uni.swalladge.id.au/hit381/functional_prototype-final/>


## building the functional prototype

```
cd functional_prototype/
./build-js.sh
bower install
```

Now to test it, start a webserver with the root at `webapp/`.

```
darkhttpd webapp
```
