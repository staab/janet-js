import {PRIVATE, provide, wrap, keyword, method, provideFn} from 'janet-js'

class DomNode {
  constructor(node) {
    this[PRIVATE] = {node}
  }
  nodeType() {
    return keyword(this[PRIVATE].node.nodeType.toLowerCase())
  }
}

provide('dom-node', {
  type: 'abstract',
  ctor: DomNode,
})

provide('query-selector', {
  type: 'function'
  arguments: [{type: 'string'}],
  call: s => wrap('dom-node', document.querySelector(s)),
})
