const add = (...xs) => xs.reduce((a, b) => a + b, 0)

const sub = (x, ...xs) => {
    if (x === undefined) {
      return 0
    }

    if (xs.length === 0) {
      return -x
    }

    return xs.reduce((a, b) => a - b, x)
  },
}


Object.assign(globalThis, {
  '+': add,
  '-': sub,
})
