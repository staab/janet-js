# janet-js

A compiler written in janet, to compile (a subset of) janet to javascript.

# Design

I want to try something different from simple janet-embedded-in-js ala clojurescript. Close host interop, while convenient, messes with a lot of the semantics of the language. In my experience, Clojurescript loses:

- Arity checks
- Type errors
- Property access errors
- Semantic differences between strings and keywords

I love the way Janet provides an C api for language extension rather than host interop. The C API has some limitations, but within those you can add whatever functionality you want to the language, all behind the facade of an "abstract type". I'd like to do the same for javascript.

There are some tradeoffs here; it won't be possible to access window.whatever from janet-js, since I want to take a more sandboxed approach. This might mean heavier code to implement run-time checks of janet semantics, and more memory to maintain annotations of javascript objects to maintain semantics when crossing language barries.

As an example, instead of `(= "object" (type (:querySelector document "a")))`, I want the user to have to explicitly opt-in to native functionality, and have it exposed not as a DOMNode, but as a janet-js abstract type. See the example directory for more details.

## Notes

- Reconcile asynchrony models - threads, fibers, promises
- Use Object.freeze for immutability
- Maybe use Maps or WeakMaps or some dictionary implementation that can use something other than strings as keys

# Disclaimer

This is pre-alpha software. Please open an issue if you'd like to use it in a project.
