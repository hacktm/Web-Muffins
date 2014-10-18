dom = React.DOM

FireBase = new Firebase("https://flickering-fire-8001.firebaseio.com")

refresh = true

login = (e, p) =>
  FireBase.authWithPassword({
    email: e
    password: p
  }, (error, authData) =>
    if error == null
      window.location.href = "/requests"
    else
      alert error
  )

$("#login-button").click ->
  login($("#login-email").val(), $("#login-password").val())

$("#register-button").click ->
  FireBase.createUser({
    email: $("#login-email").val()
    password: $("#login-password").val()
  }, (error) =>
    if error == null
      login($("#login-email").val(), $("#login-password").val())
    else
      alert error
  )

NewestRequestsComponent = React.createClass
  mixins: [ReactFireMixin]
  getInitialState: ->
    request: ""

  render: ->
    dom.p {}, @state.request.text

  componentWillMount: ->
    FireBase.child("requests").limit(1).on "child_added", (snapshot) =>
      if refresh
        @setState
          request: snapshot.val()

        refresh = false

        setTimeout (-> refresh = true), 7000

React.renderComponent NewestRequestsComponent(), document.getElementById("front-newest-requests")