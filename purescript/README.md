# Links

* [Jordan's Purescript References](https://github.com/JordanMartinez/purescript-jordans-reference)
* [New project guide](https://github.com/JordanMartinez/purescript-jordans-reference/blob/latestRelease/01-Build-Tools/03-New-Project-From-Start-to-Finish.md)

# Halogen (For version 4.0.0)

* [Sample Component code](https://github.com/slamdata/purescript-halogen/blob/v4.0.0/docs/2%20-%20Defining%20a%20component.md)

Some important types:

```
newtype HTML p i = HTML (VDom.VDom (Array (Prop (InputF Unit i))) p)

data Component (h :: Type -> Type -> Type) (f :: Type -> Type) i o (m :: Type -> Type)
```

# Halogen concepts

## Childless Component

* State
* Query Algebra
  - Constructors in query algebra define `action` and `requests`.
  - `Action` cause changes within a component and then return the `Unit` value.
  - `Requests` also cause changes within a component but return useful
    information when evaluated.

Example query algebra:

``` purescript
data Query a = Toggle a
             | IsOn (Boolean -> a)
```

* `Toggle a` is an action which will return an `Unit` value.
* `IsOn (Boolean -> a)` is an request which will return an `Boolean`.

* Input values
  - When your component appears as a child of another component, it
    can accept input from it's parent component.
* Output Messages
  - Output messages can be raised during query evaluation.
  - When you have no output messages, you can represent that as `Void` type.

```
myButton :: forall m. H.Component HH.HTML Query Unit Message m
```

* `Query` type is query algebra.
* `Unit` is input value.
* `Message` is oupput value.

``` purescript
render :: State -> H.ComponentHTML Query
eval :: Query ~> H.ComponentDSL State Query Message m
```

## Parent and Child component

``` purescript
render :: State -> H.ParentHTML Query ChildQuery Slot m
eval :: Query ~> H.ComponentDSL State Query ChildQuery Slot o m
```
