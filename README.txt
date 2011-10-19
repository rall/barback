= barback

* coming!

== DESCRIPTION:

Creates proxy instances of ActiveRecord and ActiveResource models, based on the json representation of a new instance, which will generate handlebars templates for client-side rendering

== FEATURES/PROBLEMS:
  
  

 coming up:
 * use partial render to encapsulate conditionals


== SYNOPSIS:

  Haml:

  %script{ :type => "text/x-handlebars-template", :name => "author", :class => "handlebars" }
    = render Author.handlebars_object

  HTML:

  <script class='handlebars' name='autho' type='text/x-handlebars-template'>
    <div class='author'>
      <h3>
        {{title}}
      </h3>
      <div class='cover-art'>
        <a href="/{{to_param}}/author"><img alt="{{name}}" src="{{display_image_url}}.jpg" title="{{name}}" width="140" /></a>
      </div>
      <div class='author_name'>
        <a href="/{{to_param}}/author">{{name}}</a>
      </div>
      <p class='info'>
        {{{bio}}}
      </p>
    </div>
  </script>



== REQUIREMENTS:

Rails 3.0 and above

== INSTALL:

gem install barback

== DEVELOPERS:

After checking out the source, run:

  $ rake newb

This task will install any missing dependencies, run the tests/specs,
and generate the RDoc.

== LICENSE:

(The MIT License)

Copyright (c) 2011 Richard Allaway

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
