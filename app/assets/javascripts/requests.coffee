dom = React.DOM

FireBase = new Firebase("https://flickering-fire-8001.firebaseio.com")

get_tags = (tags) =>
  tags[0...3].map (tag) -> dom.a {href: "#"}, tag

get_idea = (idea) =>
  dom.div {class: "idea-element-body"},
    dom.div {class: "idea-element-details"},
      dom.a {href: "#"}, date
      dom.a {href: "#"}, author
      dom.a {href: "#"}, score
      get_tags tags
    dom.div {class: "idea-element-description"},
      dom.p {id: id}, text
    dom.div {class: "idea-element-control"},
      dom.a {id: id, href: "#"}, "Elaborate"
      dom.a {href: "#"}, "Edit"
      dom.a {href: "#"}, "Delete"

make_requests = (id, title, text, tags, score, author, date, ideas) =>
  dom.li {class: "idea-element-body"},
    dom.div {class: "idea-element-body"},
      dom.h2 {class: "idea-element-body-title"}, title
      dom.div {class: "idea-element-details"},
        dom.a {href: "#"}, date
        dom.a {href: "#"}, author
        dom.a {href: "#"}, score
        get_tags tags
      dom.div {class: "idea-element-description"},
        dom.p {id: id}, text
      dom.div {class: "idea-element-control"},
        dom.a {id: id, href: "#"}, "Elaborate"
        dom.a {href: "#"}, "Edit"
        dom.a {href: "#"}, "Delete"
      dom.ul {}, ideas.map (idea) -> dom.li get_idea idea


RequestsComponent = React.createClass
  mixins: [ReactFireMixin]
  getInitialState: ->
    requests: []

  render: ->
    list = []

    dom.ul {class: "idea-root"}, if @state.requests?
      @state.requests.map (req) ->
        console.log req
        make_requests(req.id,
        req.title, req.text, req.tags, req.score,
        req.author, req.date)

  componentWillMount: ->
    FireBase.child("requests").limit(10).on "child_added", (snapshot) =>
      requests = @state.requests
      node = snapshot.val()
      node.id = snapshot.name()
      requests.push(node)
      @setState
        requests: requests

React.renderComponent RequestsComponent(), document.getElementById("jstree")