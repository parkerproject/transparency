if module?.exports
  require './spec_helper'
  Transparency = require '../src/transparency'

describe "Transparency", ->

  it "should handle nested lists", ->
    template = $ """
     <div class="container">
        <h1 class="title"></h1>
        <p class="post"></p>
        <div class="comments">
          <div class="comment">
            <span class="name"></span>
            <span class="text"></span>
          </div>
        </div>
      </div>
      """

    data =
      title: 'Hello World'
      post:  'Hi there it is me'
      comments: [
        name: 'John'
        text: 'That rules'
      ,
        name: 'Arnold'
        text: 'Great post!'
      ]

    expected = $ """
      <div class="container">
        <h1 class="title">Hello World</h1>
        <p class="post">Hi there it is me</p>
        <div class="comments">
          <div class="comment">
            <span class="name">John</span>
            <span class="text">That rules</span>
          </div>
          <div class="comment">
            <span class="name">Arnold</span>
            <span class="text">Great post!</span>
          </div>
        </div>
      </div>
      """

    template.render data
    expect(template.html()).htmlToBeEqual expected.html()

  it "should handle nested lists with overlapping attributes", ->
    template = $ """
      <div class="container">
        <p class="tweet"></p>
        <div class="responses">
          <p class="tweet"></p>
        </div>
      </div>
      """

    data =
      responses: [
        tweet: 'It truly is!'
      ,
        tweet: 'I prefer JsUnit'
      ]
      tweet: 'Jasmine is great!'

    expected = $ """
      <div class="container">
        <p class="tweet">Jasmine is great!</p>
        <div class="responses">
          <p class="tweet">It truly is!</p>
          <p class="tweet">I prefer JsUnit</p>
        </div>
      </div>
      """

    template.render data
    expect(template.html()).htmlToBeEqual expected.html()

  it "should handle nested objects", ->
    template = $ """
      <div class="container">
        <div class="firstname"></div>
        <div class="lastname"></div>
        <div class="address">
          <div class="street"></div>
          <div class="zip"><span class="city"></span></div>
        </div>
      </div>
      """

    data =
      firstname: 'John'
      lastname:  'Wayne'
      address:
        street: '4th Street'
        city:   'San Francisco'
        zip:    '94199'

    expected = $ """
      <div class="container">
        <div class="firstname">John</div>
        <div class="lastname">Wayne</div>
        <div class="address">
          <div class="street">4th Street</div>
          <div class="zip">94199<span class="city">San Francisco</span></div>
        </div>
      </div>
      """

    template.render data
    expect(template.html()).htmlToBeEqual expected.html()

  it "should handle tables with dynamic headers", ->

    # IE6-8 fails to build proper DOM from table, if the cells are empty
    # As a workaround, fill the template with dummy values before parsing with jQuery
    template = $ """
      <table class="test_reports">
        <thead>
          <tr class="profiles">
            <th>
              <a class="name" href="#">profile</a>
            </th>
          </tr>
        </thead>
        <tbody>
          <tr class="profiles">
            <td class="testsets">
              <div class="testset">
                <a class="name" href="#">testset</a>
                <ul class="products">
                  <li>
                    <a class="name" href="#">product</a>
                  </li>
                </ul>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
      """

    data =
      release: "1.2"
      profiles: [
        name: 'Core'
        testsets: [
          name: "Sanity"
          products: [
            name: "N900"
          ,
            name: "Lenovo"
          ]
        ,
          name: "Acceptance"
          products: [
            name: "Netbook"
          ,
            name: "Pinetrail"
          ]
        ]
      ,
        name: 'Handset'
        testsets: [
          name: "Feature"
          products: [
            name: "N900"
          ,
            name: "Lenovo"
          ]
        ,
          name: 'NFT'
          products: [
            name: "Netbook"
          ,
            name: "iCDK"
          ]
        ]
      ]

    directives =
      profiles:
        name: href: -> "http://www.example.com/#{@name}"
        testsets:
          name: href: -> "http://www.example.com/#{@name}"
          products:
            name: href: -> "http://www.example.com/#{@name}"

    expected = $ """
      <table class="test_reports">
        <thead>
          <tr class="profiles">
            <th>
              <a class="name" href="http://www.example.com/Core">Core</a>
            </th>
            <th>
              <a class="name" href="http://www.example.com/Handset">Handset</a>
            </th>
          </tr>
        </thead>
        <tbody>
          <tr class="profiles">
            <td class="testsets">
              <div class="testset">
                <a class="name" href="http://www.example.com/Sanity">Sanity</a>
                <ul class="products">
                  <li>
                    <a class="name" href="http://www.example.com/N900">N900</a>
                  </li>
                  <li>
                    <a class="name" href="http://www.example.com/Lenovo">Lenovo</a>
                  </li>
                </ul>
              </div>
              <div class="testset">
                <a class="name" href="http://www.example.com/Acceptance">Acceptance</a>
                <ul class="products">
                  <li>
                    <a class="name" href="http://www.example.com/Netbook">Netbook</a>
                  </li>
                  <li>
                    <a class="name" href="http://www.example.com/Pinetrail">Pinetrail</a>
                  </li>
                </ul>
              </div>
            </td>
            <td class="testsets">
              <div class="testset">
                <a class="name" href="http://www.example.com/Feature">Feature</a>
                <ul class="products">
                  <li>
                    <a class="name" href="http://www.example.com/N900">N900</a>
                  </li>
                  <li>
                    <a class="name" href="http://www.example.com/Lenovo">Lenovo</a>
                  </li>
                </ul>
              </div>
              <div class="testset">
                <a class="name" href="http://www.example.com/NFT">NFT</a>
                <ul class="products">
                  <li>
                    <a class="name" href="http://www.example.com/Netbook">Netbook</a>
                  </li>
                  <li>
                    <a class="name" href="http://www.example.com/iCDK">iCDK</a>
                  </li>
                </ul>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
      """

    template.render(data, directives)
    expect(template.html()).htmlToBeEqual expected.html()
