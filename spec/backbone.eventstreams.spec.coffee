describe 'Backbone.EventStream', ->

    it 'can turn bacon.js properties to models', ->
        username = Bacon.once("johndoe")
        loggedIn = new Bacon.Bus
        user     = Bacon.combineTemplate({ username: username, loggedIn: loggedIn.toProperty(false) })
        model    = user.toModel()
        stub     = jasmine.createSpy('stub')

        model.on("change:loggedIn", stub)
        expect(model.get("loggedIn")).toBe false
        expect(stub).wasNotCalled()

        loggedIn.push(true)
        expect(stub).wasCalled()
        expect(model.get("loggedIn")).toBe true

        loggedIn.push()