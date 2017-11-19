# sol-SDLL

[ ![Codeship Status for skmgoldin/sol-sdll](https://app.codeship.com/projects/1d52a910-af98-0135-a0f9-6eb3a71c4596/status?branch=master)](https://app.codeship.com/projects/257509)

A doubly-linked list that enforces sorting and provides convenience functions for determining insert points.

## Initialize
The only environmental dependency you need is Node. Presently we can guarantee this all works with Node 8.
```
npm install
npm run compile
```

## Tests
Run the tests with `npm run test`.

## Composition of the repo
The repo is composed as a Truffle project, and is largely idiomatic to Truffle's conventions. The tests are in the `test` directory, the contracts are in the `contracts` directory and the migrations (deployment scripts) are in the `migrations` directory.

The sorted DLL is a composition of the EPM `dll` and `attrstore` libraries created by Yorke Rhodes and Cem Ozer.

## Design
The most important properties for EVM data structures are constant-time inserts and deletes. Lookups can be less efficient, since those can be done as simulated calls off-chain. A DLL is a nice data structure for the EVM since is permits constant time inserts and deletes. The tradeoff is that the insertion point has to be provided with the `insert` call, but a convenience function `getInsertPoint` is provided to this end.

Every node in the SDLL has an AttributeStore with which string-keyed data can be stored. All stored data must be uints (for now).

An SDLL has a `sortAttr` (sort attribute) with which the list is ordered. This attribute should be set at list instantiation and then protected.

## Using the SDLL
The SDLL is a library, so can be imported and used with Solidity's object-like syntax (`using SDLL for SDLL.Data`).

To see examples of usage, the test suite is instructive.

